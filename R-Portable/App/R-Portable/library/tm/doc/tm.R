### R code from vignette source 'tm.Rnw'
### Encoding: UTF-8

###################################################
### code chunk number 1: Init
###################################################
library("tm")
data("crude")


###################################################
### code chunk number 2: Ovid
###################################################
txt <- system.file("texts", "txt", package = "tm")
(ovid <- VCorpus(DirSource(txt, encoding = "UTF-8"),
                 readerControl = list(language = "lat")))


###################################################
### code chunk number 3: VectorSource
###################################################
docs <- c("This is a text.", "This another one.")
VCorpus(VectorSource(docs))


###################################################
### code chunk number 4: Reuters
###################################################
reut21578 <- system.file("texts", "crude", package = "tm")
reuters <- VCorpus(DirSource(reut21578),
                   readerControl = list(reader = readReut21578XMLasPlain))


###################################################
### code chunk number 5: tm.Rnw:117-118 (eval = FALSE)
###################################################
## writeCorpus(ovid)


###################################################
### code chunk number 6: tm.Rnw:128-129
###################################################
inspect(ovid[1:2])


###################################################
### code chunk number 7: tm.Rnw:133-135
###################################################
meta(ovid[[2]], "id")
identical(ovid[[2]], ovid[["ovid_2.txt"]])


###################################################
### code chunk number 8: tm.Rnw:139-141
###################################################
inspect(ovid[[2]])
lapply(ovid[1:2], as.character)


###################################################
### code chunk number 9: tm.Rnw:155-156
###################################################
reuters <- tm_map(reuters, stripWhitespace)


###################################################
### code chunk number 10: tm.Rnw:161-162
###################################################
reuters <- tm_map(reuters, content_transformer(tolower))


###################################################
### code chunk number 11: Stopwords
###################################################
reuters <- tm_map(reuters, removeWords, stopwords("english"))


###################################################
### code chunk number 12: Stemming
###################################################
tm_map(reuters, stemDocument)


###################################################
### code chunk number 13: tm.Rnw:193-196
###################################################
idx <- meta(reuters, "id") == '237' &
  meta(reuters, "heading") == 'INDONESIA SEEN AT CROSSROADS OVER ECONOMIC CHANGE'
reuters[idx]


###################################################
### code chunk number 14: DublinCore
###################################################
DublinCore(crude[[1]], "Creator") <- "Ano Nymous"
meta(crude[[1]])


###################################################
### code chunk number 15: tm.Rnw:227-231
###################################################
meta(crude, tag = "test", type = "corpus") <- "test meta"
meta(crude, type = "corpus")
meta(crude, "foo") <- letters[1:20]
meta(crude)


###################################################
### code chunk number 16: tm.Rnw:250-252
###################################################
dtm <- DocumentTermMatrix(reuters)
inspect(dtm[5:10, 740:743])


###################################################
### code chunk number 17: tm.Rnw:261-262
###################################################
findFreqTerms(dtm, 5)


###################################################
### code chunk number 18: tm.Rnw:267-268
###################################################
findAssocs(dtm, "opec", 0.8)


###################################################
### code chunk number 19: tm.Rnw:276-277
###################################################
inspect(removeSparseTerms(dtm, 0.4))


###################################################
### code chunk number 20: tm.Rnw:291-293
###################################################
inspect(DocumentTermMatrix(reuters,
                           list(dictionary = c("prices", "crude", "oil"))))


