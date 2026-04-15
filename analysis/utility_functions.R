###################
# Utility functions 
###################
se <- function(x) sqrt(var(x)/length(x))
starLabel<- function(p) 
{
  cuts <- c(0.01, 0.05, 0.1)
  if (any(p <= cuts)) {
    symbol <- c("***", "**\\hphantom{*}", "*\\hphantom{**}")[p <= cuts][1]
  }
  else {
    symbol <- "\\hphantom{***}"
  }
  symbol
}

get_confint <- function(model, vcovCL){
  t<-qt(.95, model$df.residual)
  ct<-coeftest(model, vcovCL)
  est<-cbind(ct[,1], ct[,1]-t*ct[,2], ct[,1]+t*ct[,2])
  colnames(est)<-c("Estimate","LowerCI","UpperCI")
  return(est)
}

### Function for Latex Charecteristic Table----
digits <- 2
numberFormat <- function(x) formatC(x, digits = digits, format = "f")
seBracket <- function(x) paste("(", x, ")", sep = "")

LineFun<- function(form,label="",df){
  df <- data.table::data.table(df)
  m1<- lm(formula(form),data=df)
  m1.vcovCL<-cluster.vcov(m1, df[,economic_opening])  
  c<- m1$coefficients[1]
  t<- m1$coefficients[1]+m1$coefficients[2]
  n<- nrow(m1$model)
  vars<- paste0(as.character(form[2])," ~ 1")
  m2c<- lm(vars, data=subset(df,trt==0))
  m2c.vcovCL<-cluster.vcov(m2c, df[trt==0,economic_opening])
  se_c<- coeftest(m2c, m2c.vcovCL)[2]
  m2t<- lm(vars, data=subset(df,trt==1))
  m2t.vcovCL<-cluster.vcov(m2t, df[trt==1,economic_opening])
  se_t<- coeftest(m2t, m2t.vcovCL)[2]
  coef<- m1$coefficients[2]
  se<- coeftest(m1, m1.vcovCL)[4]
  p<- coeftest(m1, m1.vcovCL)[8]
  display.p <- if (p < 0.001) "<0.001" else numberFormat(p)
  paste("&", label,"&",
        #n, "&",
        numberFormat(c), 
        seBracket( numberFormat(se_c )),
        "&",
        numberFormat(t),
        seBracket( numberFormat(se_t )),
        "&",
        numberFormat(coef),
        paste0(seBracket( numberFormat(se )), "$^{", starLabel(p), "}$"),
        "&",
        numberFormat(100 * coef/c),
        " \\\\ \n", sep = " ")
}


LineFun_OLS<- function(form,label="",df){
  m1<- lm(formula(form),data=df)
  c<- m1$coefficients[1]
  t<- m1$coefficients[1]+m1$coefficients[2]
  vars<- paste0(as.character(form[2])," ~ 1")
  m2c<- lm(vars, data=subset(df,trt==0))
  se_c<- coeftest(m2c)[2]
  m2t<- lm(vars, data=subset(df,trt==1))
  se_t<- coeftest(m2t)[2]
  n<- nrow(m1$model)
  coef<- m1$coefficients[2]
  se<- coeftest(m1)[4]
  p<- coeftest(m1)[8]
  display.p <- if (p < 0.001) "<0.001" else numberFormat(p)
  paste("&", label,"&",
        #n, "&",
        numberFormat(c),
        seBracket( numberFormat(se_c )),
        "&",
        numberFormat(t),
        seBracket( numberFormat(se_t )),
        "&",
        numberFormat(coef), 
        paste0(seBracket( numberFormat(se )), "$^{", starLabel(p), "}$"),
        "&",
        numberFormat(100 * coef/c),
         "\\\\ \n ", sep = " ")
}

note.wrapper.helper <- function(guts, width = 1.0, include.star = TRUE){
    note <- c("\\\\",
              paste0("\\begin{minipage}{", width, "\\textwidth}"),
              paste0("\\begin{footnotesize}"),
              paste0("\\emph{Notes:}", guts),
              ifelse(include.star, "\\starlanguage", ""),
              paste0("\\end{footnotesize}"),
              "\\end{minipage}")
    note
}

AddTableNote<- function(stargazer.object, out.file, note, adjust = 3){
  "Adds a table note to a stargazer table. It assumes that the\n     last three lines of stargazer output are useless."
  n <- length(stargazer.object)
  write(stargazer.object[1:(n - adjust)], out.file)
  write(c("\\end{tabular}"), out.file, append = TRUE)
  write(note, out.file, append = TRUE)
  write(c("\\end{table}"), out.file, append = TRUE)
}

AddTableNoteSideWays <- function(stargazer.object, out.file, note, adjust = 3){
  "Adds a table note to a stargazer table. It assumes that the
     last three lines of stargazer output are useless."
  n <- length(stargazer.object)
  write(stargazer.object[1:(n - adjust)], out.file)
  write(c("\\end{tabular}"), out.file, append = TRUE)
  write(note, out.file, append = TRUE)
  write(c("\\end{sidewaystable}"), out.file, append = TRUE)
} 

#Create Cluster-Robust SE Function
cl<- function(dat,fm, cluster){
  attach(dat, warn.conflicts = F)
  library(sandwich)
  M <- length(unique(cluster))
  N <- length(cluster)
  K <- fm$rank
  dfc <- (M/(M-1))*((N-1)/(N-K))
  uj  <- apply(estfun(fm),2, function(x) tapply(x, cluster, sum));
  vcovCL <- dfc*sandwich(fm, meat=crossprod(uj)/N)
  std.err <- sqrt(diag(vcovCL))
  return(std.err) 
}
