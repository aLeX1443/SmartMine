## ---- echo = FALSE, warning = FALSE, error = FALSE, message = FALSE, fig.width=6, fig.height=4----
library(gender)
library(dplyr)
library(ggplot2)

gender:::basic_names %>%
  filter(name %in% c("madison", "hillary", "monroe", "jordan")) %>%
  mutate(proportion_female = female / (female + male)) %>%
ggplot(aes(x = year, y = proportion_female, color = name)) +
  geom_line() +
  ggtitle("The changing gender of several names") +
  xlab("Birth year for U.S. babies") + 
  ylab("Proportion born female")

## ------------------------------------------------------------------------
library(gender)
gender(c("Madison", "Hillary"), years = 1940, method = "demo")
gender(c("Madison", "Hillary"), years = 2000, method = "demo")

## ----eval=FALSE----------------------------------------------------------
#  gender("Madison", years = c(1960, 1969), method = "ssa")

## ----eval=FALSE----------------------------------------------------------
#  gender("Madison", years = c(1860, 1869), method = "ipums")

## ----eval=FALSE----------------------------------------------------------
#  gender("Hilde", years = c(1860, 1869), method = "napp")

## ----eval=FALSE----------------------------------------------------------
#  gender("Hilde", years = c(1879), method = "napp", countries = "Sweden")

## ------------------------------------------------------------------------
library(dplyr)

demo_names <- c("Susan", "Susan", "Madison", "Madison",
                "Hillary", "Hillary", "Hillary")
demo_years <- c(rep(c(1930, 2000), 3), 1930)
demo_df <- data_frame(first_names = demo_names,
                      last_names = LETTERS[1:7],
                      years = demo_years,
                      min_years = demo_years - 3,
                      max_years = demo_years + 3)

demo_df

## ------------------------------------------------------------------------
results <- gender_df(demo_df, name_col = "first_names", year_col = "years",
                     method = "demo")
results

## ------------------------------------------------------------------------
demo_df %>% 
  left_join(results, by = c("first_names" = "name", "years" = "year_min"))

## ------------------------------------------------------------------------
gender_df(demo_df, name_col = "first_names",
          year_col = c("min_years", "max_years"), method = "demo")

## ------------------------------------------------------------------------
demo_df %>% 
  distinct(first_names, years) %>% 
  rowwise() %>% 
  do(results = gender(.$first_names, years = .$years, method = "demo")) %>% 
  do(bind_rows(.$results))

## ------------------------------------------------------------------------
demo_df %>% 
  distinct(first_names, years) %>% 
  group_by(years) %>% 
  do(results = gender(.$first_names, years = .$years[1], method = "demo")) %>% 
  do(bind_rows(.$results))

