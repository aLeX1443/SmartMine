### R code from vignette source 'unknown.Rnw'

###################################################
### code chunk number 1: ex01
###################################################
library("gdata")
xNum <- c(0, 6, 0, 7, 8, 9, NA)
isUnknown(x=xNum)


###################################################
### code chunk number 2: ex02
###################################################
isUnknown(x=xNum, unknown=0)


###################################################
### code chunk number 3: ex03
###################################################
isUnknown(x=xNum, unknown=c(0, NA))


###################################################
### code chunk number 4: ex04
###################################################
(xNum2 <- unknownToNA(x=xNum, unknown=0))


###################################################
### code chunk number 5: ex05
###################################################
NAToUnknown(x=xNum2, unknown=999)


###################################################
### code chunk number 6: ex06
###################################################
NAToUnknown(x=xNum2, unknown=7, force=TRUE)


###################################################
### code chunk number 7: ex07
###################################################
(xFac <- factor(c(0, "BA", "RA", "BA", NA, "NA")))
isUnknown(x=xFac)
isUnknown(x=xFac, unknown=0)
isUnknown(x=xFac, unknown=c(0, NA))
isUnknown(x=xFac, unknown=c(0, "NA"))
isUnknown(x=xFac, unknown=c(0, "NA", NA))

(xFac <- unknownToNA(x=xFac, unknown=0))
(xFac <- NAToUnknown(x=xFac, unknown=0))


###################################################
### code chunk number 8: ex08
###################################################
(xList <- list(a=xNum, b=xFac))
isUnknown(x=xList, unknown=0)


###################################################
### code chunk number 9: ex09
###################################################
isUnknown(x=xList, unknown=c(0, NA))


###################################################
### code chunk number 10: ex10
###################################################
(xList1 <- unknownToNA(x=xList,
                       unknown=list(b=c(0, "NA"),
                                    a=0)))


###################################################
### code chunk number 11: ex11
###################################################
NAToUnknown(x=xList1,
            unknown=list(b="no", a=0))


###################################################
### code chunk number 12: ex12
###################################################
df <- data.frame(col1=c(0, 1, 999, 2),
                 col2=c("a", "b", "c", "unknown"),
                 col3=c(0, 1, 2, 3),
                 col4=c(0, 1, 2, 2))


###################################################
### code chunk number 13: ex13
###################################################
tmp <- list(.default=0,
            col1=999,
            col2="unknown")
(df2 <- unknownToNA(x=df,
                    unknown=tmp))


###################################################
### code chunk number 14: ex14
###################################################
df2 <- df
cols <- c("col1", "col2")
tmp <- list(col1=999,
            col2="unknown")
df2[, cols] <- unknownToNA(x=df[, cols],
                           unknown=tmp)
df2


