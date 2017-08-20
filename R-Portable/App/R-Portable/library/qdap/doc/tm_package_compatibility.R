## ----setup, include=FALSE, cache=FALSE--------------------------------------------------
library(knitr); library(qdap); library(tm)
opts_chunk$set(fig.path='figure/minimal-', fig.align='center', fig.show='hold', 
    tidy=FALSE, cache=FALSE)
options(replace.assign=TRUE, width=90)
pdf.options(useDingbats = TRUE)

## ----packs, eval=FALSE------------------------------------------------------------------
#  library(qdap); library(tm)

## ----qdap_view_text, eval=FALSE---------------------------------------------------------
#  DATA
#  qview(DATA)
#  htruncdf(DATA)

## ----tm_view_text, eval=FALSE-----------------------------------------------------------
#  data("crude")
#  crude
#  inspect(crude)

## ----freq_dat---------------------------------------------------------------------------
tm_dat <- qdap_dat <- DATA[1:4, c(1, 4)]
rownames(tm_dat) <- paste("docs", 1:nrow(tm_dat))
tm_dat <- Corpus(DataframeSource(tm_dat[, 2, drop=FALSE]))

## ----freq_dat_view, echo=FALSE----------------------------------------------------------
qdap_dat

## ----freq_dat_qdap, eval=FALSE----------------------------------------------------------
#  with(qdap_dat, wfm(state, person))

## ----freq_dat_qdap2, echo=FALSE---------------------------------------------------------
with(qdap_dat, wfm(state, person))

## ----freq_dat_view_tm1, eval=FALSE------------------------------------------------------
#  TermDocumentMatrix(tm_dat,
#      control = list(
#          removePunctuation = TRUE,
#          wordLengths=c(0, Inf)
#      )
#  )

## ----freq_dat_view_tm1b, echo=FALSE-----------------------------------------------------
TermDocumentMatrix(tm_dat, 
    control = list(
        removePunctuation = TRUE, 
        wordLengths=c(0, Inf)
    )
)

## ----freq_dat_view_tm2, eval=FALSE------------------------------------------------------
#  inspect(TermDocumentMatrix(tm_dat,
#      control = list(
#          removePunctuation = TRUE,
#          wordLengths=c(0, Inf)
#      )
#  ))

## ----sum1, eval=FALSE-------------------------------------------------------------------
#  summary(with(qdap_dat, wfm(state, person)))

## ----sum2, echo=FALSE-------------------------------------------------------------------
summary(with(qdap_dat, wfm(state, person)))

## ----data_set_up------------------------------------------------------------------------
tm_dat <- qdap_dat <- DATA[1:4, c (1, 4) ]
rownames (tm_dat) <- paste ("docs", 1: nrow (tm_dat))
tm_dat <- Corpus(DataframeSource (tm_dat[, 2, drop=FALSE]))

qdap_wfm <- with (qdap_dat, wfm (state, person))
tm_tdm <- TermDocumentMatrix (tm_dat,
    control = list (
        removePunctuation = TRUE,
        wordLengths= c (0, Inf)
    )
)

## ----datviewing, eval=FALSE-------------------------------------------------------------
#  qdap_dat; qview(qdap_dat)
#  tm_dat; inspect(tm_dat)
#  qdap_wfm; summary(qdap_wfm)
#  tm_tdm; inspect(tm_tdm)

## ----corp2df, eval=FALSE----------------------------------------------------------------
#  as.data.frame(tm_dat)

## ----corp2df2, echo=FALSE---------------------------------------------------------------
as.data.frame(tm_dat)

## ----df2corp, eval=FALSE----------------------------------------------------------------
#  with(qdap_dat, as.Corpus(state, person))

## ----df2corp2, echo=FALSE---------------------------------------------------------------
with(qdap_dat, as.Corpus(state, person))

## ----as.wfm1, eval=FALSE----------------------------------------------------------------
#  as.wfm(tm_tdm)

## ----as.wfm2, echo=FALSE----------------------------------------------------------------
as.wfm(tm_tdm)

## ----wfm2tdm, eval=FALSE----------------------------------------------------------------
#  as.tdm(qdap_wfm)
#  as.dtm(qdap_wfm)

## ----wfm2tdm2, echo=FALSE---------------------------------------------------------------
as.tdm(qdap_wfm)

## ----wfm2tdm3, echo=FALSE---------------------------------------------------------------
as.dtm(qdap_wfm)

## ----corp2wfma, eval=FALSE--------------------------------------------------------------
#  as.wfm(tm_dat)

## ----corp2wfmb, echo=FALSE--------------------------------------------------------------
as.wfm(tm_dat)

## ----stem, eval=FALSE-------------------------------------------------------------------
#  sentSplit(qdap_dat, "state", stem = TRUE)

## ----stem2, echo=FALSE------------------------------------------------------------------
sentSplit(qdap_dat, "state", stem = TRUE)

## ----wfmdat-----------------------------------------------------------------------------
qdap_wfm <- with(qdap_dat, wfm(state, person))

## ----wfmdat2, echo=FALSE----------------------------------------------------------------
with(qdap_dat, wfm(state, person))

## ----filtera, eval=FALSE----------------------------------------------------------------
#  Filter(qdap_wfm, min = 5)

## ----filter2, echo=FALSE----------------------------------------------------------------
Filter(qdap_wfm, min = 5)

## ----filterb, eval=FALSE----------------------------------------------------------------
#  Filter(qdap_wfm, min = 5, max = 7)

## ----filter3, echo=FALSE----------------------------------------------------------------
Filter(qdap_wfm, min = 5, max = 7)

## ----filterd, eval=FALSE----------------------------------------------------------------
#  Filter(qdap_wfm, 4, 4)

## ----filter4, echo=FALSE----------------------------------------------------------------
Filter(qdap_wfm, 4, 4)

## ----filtere, eval=FALSE----------------------------------------------------------------
#  Filter(qdap_wfm, 4, 4, count.apostrophe = FALSE)

## ----filter5, echo=FALSE----------------------------------------------------------------
Filter(qdap_wfm, 4, 4, count.apostrophe = FALSE)

## ----filterf, eval=FALSE----------------------------------------------------------------
#  Filter(qdap_wfm, 3, 4)

## ----filter6, echo=FALSE----------------------------------------------------------------
Filter(qdap_wfm, 3, 4)

## ----filterg, eval=FALSE----------------------------------------------------------------
#  Filter(qdap_wfm, 3, 4, stopwords = Top200Words)

## ----filter7, echo=FALSE----------------------------------------------------------------
Filter(qdap_wfm, 3, 4, stopwords = Top200Words)

## ----wfmdat2b---------------------------------------------------------------------------
a <- with(DATA, wfm(state, list(sex, adult)))

## ----wfmdat2c, echo=FALSE---------------------------------------------------------------
summary(a)

## ----apply_as_tm1-----------------------------------------------------------------------
out <- apply_as_tm(a, tm::removeSparseTerms, sparse=0.6)

## ----apply_as_tm2a, eval=FALSE----------------------------------------------------------
#  summary(out)

## ----apply_as_tm2, echo=FALSE-----------------------------------------------------------
summary(out)

## ----apply_as_tm3a, eval=FALSE----------------------------------------------------------
#  class(out)

## ----apply_as_tm3, echo=FALSE-----------------------------------------------------------
class(out)

## ----apply_as_tm4, eval=FALSE-----------------------------------------------------------
#  apply_as_tm(a, tm::findAssocs, "computer", .8)
#  apply_as_tm(a, tm::findFreqTerms, 2, 3)
#  apply_as_tm(a, tm::Zipf_plot)
#  apply_as_tm(a, tm::Heaps_plot)
#  apply_as_tm(a, tm:::plot.TermDocumentMatrix, corThreshold = 0.4)
#  
#  library(proxy)
#  apply_as_tm(a, tm::weightBin)
#  apply_as_tm(a, tm::weightBin, to.qdap = FALSE)
#  apply_as_tm(a, tm::weightSMART)
#  apply_as_tm(a, tm::weightTfIdf)

## ----apply_as_df1, eval = FALSE---------------------------------------------------------
#  matches <- list(
#      good = "fun",
#      bad = c("dumb", "stinks", "liar")
#  )
#  
#  apply_as_df(tm_dat, trans_cloud, grouping.var=NULL,
#      target.words=matches, cloud.colors = c("red", "blue", "grey75"))

## ----apply_as_df2, echo=FALSE, fig.height=5---------------------------------------------
matches <- list(
    good = "fun",
    bad = c("dumb", "stinks", "liar")
)

apply_as_df(tm_dat, trans_cloud, grouping.var=NULL,
    target.words=matches, cloud.colors = c("red", "blue", "grey75"))

## ----apply_as_df3, eval=FALSE-----------------------------------------------------------
#  library(tm)
#  reut21578 <- system.file("texts", "crude", package = "tm")
#  reuters <- Corpus(DirSource(reut21578),
#      readerControl = list(reader = readReut21578XML))
#  
#  apply_as_df(reuters, word_stats)
#  apply_as_df(reuters, formality)
#  apply_as_df(reuters, word_list)
#  apply_as_df(reuters, polarity)
#  apply_as_df(reuters, Dissimilarity)
#  apply_as_df(reuters, diversity)
#  apply_as_df(tm_dat, pos_by)
#  apply_as_df(reuters, flesch_kincaid)
#  apply_as_df(tm_dat, trans_venn)
#  apply_as_df(reuters, gantt_plot)
#  apply_as_df(reuters, rank_freq_mplot)
#  apply_as_df(reuters, character_table)
#  apply_as_df(reuters, trans_cloud)
#  
#  matches2 <- list(
#      oil = qcv(oil, crude),
#      money = c("economic", "money")
#  )
#  
#  (termco_out <- apply_as_df(reuters, termco, match.list = matches2))
#  plot(termco_out, values = TRUE, high="red")
#  
#  (wordcor_out <- apply_as_df(reuters, word_cor, word = unlist(matches2)))
#  plot(wordcor_out)
#  
#  (f_terms <- apply_as_df(reuters, freq_terms, at.least = 3))
#  plot(f_terms)
#  
#  finds <- apply_as_df(reuters, freq_terms, at.least = 5,
#      top = 5, stopwords = Top100Words)
#  apply_as_df(reuters, dispersion_plot, match.terms = finds[, 1],
#      total.color = NULL)

## ----add1, eval=FALSE-------------------------------------------------------------------
#  browseVignettes(package = "tm")

## ----add2, eval=FALSE-------------------------------------------------------------------
#  browseVignettes(package = "qdap")

