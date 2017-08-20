### R code from vignette source 'extensions.Rnw'

###################################################
### code chunk number 1: Init
###################################################
library("tm")
library("XML")


###################################################
### code chunk number 2: extensions.Rnw:55-58
###################################################
VecSource <- function(x)
    SimpleSource(length = length(x), content = as.character(x),
                 class = "VecSource")


###################################################
### code chunk number 3: extensions.Rnw:68-72
###################################################
getElem.VecSource <-
function(x) list(content = x$content[x$position], uri = NULL)
pGetElem.VecSource <-
function(x) lapply(x$content, function(y) list(content = y, uri = NULL))


###################################################
### code chunk number 4: extensions.Rnw:100-102
###################################################
readPlain <- function(elem, language, id)
    PlainTextDocument(elem$content, id = id, language = language)


###################################################
### code chunk number 5: extensions.Rnw:130-135
###################################################
df <- data.frame(contents = c("content 1", "content 2", "content 3"),
                 title    = c("title 1"  , "title 2"  , "title 3"  ),
                 authors  = c("author 1" , "author 2" , "author 3" ),
                 topics   = c("topic 1"  , "topic 2"  , "topic 3"  ),
                 stringsAsFactors = FALSE)


###################################################
### code chunk number 6: Mapping
###################################################
m <- list(content = "contents", heading = "title",
          author = "authors", topic = "topics")


###################################################
### code chunk number 7: myReader
###################################################
myReader <- readTabular(mapping = m)


###################################################
### code chunk number 8: extensions.Rnw:157-158
###################################################
(corpus <- VCorpus(DataframeSource(df), readerControl = list(reader = myReader)))


###################################################
### code chunk number 9: extensions.Rnw:163-165
###################################################
corpus[[1]]
meta(corpus[[1]])


###################################################
### code chunk number 10: CustomXMLFile
###################################################
custom.xml <- system.file("texts", "custom.xml", package = "tm")
print(readLines(custom.xml), quote = FALSE)


###################################################
### code chunk number 11: mySource
###################################################
mySource <- function(x)
    XMLSource(x, function(tree) XML::xmlChildren(XML::xmlRoot(tree)),
              myXMLReader)


###################################################
### code chunk number 12: myXMLReader
###################################################
myXMLReader <- readXML(
    spec = list(author = list("node", "/document/writer"),
                content = list("node", "/document/description"),
                datetimestamp = list("function",
                    function(x) as.POSIXlt(Sys.time(), tz = "GMT")),
                description = list("attribute", "/document/@short"),
                heading = list("node", "/document/caption"),
                id = list("function", function(x) tempfile()),
                origin = list("unevaluated", "My private bibliography"),
                type = list("node", "/document/type")),
    doc = PlainTextDocument())


###################################################
### code chunk number 13: extensions.Rnw:273-274
###################################################
corpus <- VCorpus(mySource(custom.xml))


###################################################
### code chunk number 14: extensions.Rnw:278-280
###################################################
corpus[[1]]
meta(corpus[[1]])


