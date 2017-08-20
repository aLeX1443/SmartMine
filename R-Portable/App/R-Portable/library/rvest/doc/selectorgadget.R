## ---- echo = FALSE-------------------------------------------------------
embed_png <- function(path, dpi = NULL) {
  meta <- attr(png::readPNG(path, native = TRUE, info = TRUE), "info")
  if (!is.null(dpi)) meta$dpi <- rep(dpi, 2)

  knitr::asis_output(paste0(
    "<img src='", path, "'",
    " width=", round(meta$dim[1] / (meta$dpi[1] / 96)),
    " height=", round(meta$dim[2] / (meta$dpi[2] / 96)),
    " />"
  ))
}

knitr::opts_chunk$set(comment = "#>", collapse = TRUE)

## ---- echo = FALSE-------------------------------------------------------
embed_png("selectorgadget-1.png")

## ---- echo = FALSE-------------------------------------------------------
embed_png("selectorgadget-2.png")

## ---- echo = FALSE-------------------------------------------------------
embed_png("selectorgadget-3.png")

## ---- echo = FALSE-------------------------------------------------------
embed_png("selectorgadget-4.png")
embed_png("selectorgadget-5.png")

## ------------------------------------------------------------------------
library(rvest)
html <- read_html("http://www.imdb.com/title/tt1490017/")
cast <- html_nodes(html, "#titleCast .itemprop")
length(cast)
cast[1:2]

## ------------------------------------------------------------------------
cast <- html_nodes(html, "#titleCast span.itemprop")
length(cast)

html_text(cast)

