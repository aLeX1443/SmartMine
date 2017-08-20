## ----setup, include=FALSE, cache=FALSE--------------------------------------------------
library(knitr); library(qdap)
opts_chunk$set(fig.path='figure/minimal-', fig.align='center', fig.show='hold', 
    tidy=FALSE, cache=FALSE)
options(replace.assign=TRUE, width=90)
pdf.options(useDingbats = TRUE)

## ----checking1--------------------------------------------------------------------------
x <- c("i like", "i want. thet them .", "I am ! that|", "", NA,
    "they,were there", ".", "   ", "?", "3;", "I like goud eggs!",
    "i 4like...", "\\tgreat",  "She said \"yes\"")
x

## ----checking2--------------------------------------------------------------------------
check_text(x)

## ----bug1-------------------------------------------------------------------------------
fake_fun <- function(x) {
    stopifnot(!any(grepl("talk", x)))
    x
}

## ----bug2, eval=FALSE-------------------------------------------------------------------
#  with(DATA, fake_fun(state))

## ----bug3-------------------------------------------------------------------------------
with(DATA[1:5, ] , fake_fun(state))

## ----bug4, eval=FALSE-------------------------------------------------------------------
#  with(DATA[5:11, ] , fake_fun(state))

## ----bug5-------------------------------------------------------------------------------
with(DATA[5:8, ] , fake_fun(state))

## ----bug6, eval=FALSE-------------------------------------------------------------------
#  with(DATA[9:11, ] , fake_fun(state))

## ----bug7, eval=FALSE-------------------------------------------------------------------
#  with(DATA[9, ] , fake_fun(state))

## ----bug8, eval=FALSE-------------------------------------------------------------------
#  with(DATA[9, ], fake_fun(substring(state, 1:20)))

## ----bug9-------------------------------------------------------------------------------
with(DATA[9, ], fake_fun(substring(state, 21)))

