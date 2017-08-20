### R code from vignette source 'mapLevels.Rnw'

###################################################
### code chunk number 1: ex01
###################################################
library(gdata)
(fac <- factor(c("B", "A", "Z", "D")))
(map <- mapLevels(x=fac))


###################################################
### code chunk number 2: ex02
###################################################
(int <- as.integer(fac))
mapLevels(x=int) <- map
int
identical(fac, int)


###################################################
### code chunk number 3: ex03
###################################################
str(map)


###################################################
### code chunk number 4: ex04
###################################################
map[[2]] <- as.integer(c(1, 2))
map
int <- as.integer(fac)
mapLevels(x=int) <- map
int


###################################################
### code chunk number 5: ex05
###################################################
(f1 <- factor(c("A", "D", "C")))
(f2 <- factor(c("B", "D", "C")))


###################################################
### code chunk number 6: ex06
###################################################
fTest <- f1
levels(fTest) <- c("A", "B", "C", "D")
fTest


###################################################
### code chunk number 7: ex07
###################################################
fTest <- f1
levels(fTest) <- list(A="A", B="B",
                      C="C", D="D")
fTest


###################################################
### code chunk number 8: ex08
###################################################
(bigMap <- mapLevels(x=list(f1, f2),
                     codes=FALSE,
                     combine=TRUE))
mapLevels(f1) <- bigMap
mapLevels(f2) <- bigMap
f1
f2
cbind(as.character(f1), as.integer(f1),
      as.character(f2), as.integer(f2))


