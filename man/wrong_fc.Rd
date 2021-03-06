% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wrong_fc.R
\name{wrong_fc}
\alias{wrong_fc}
\title{Check Italian fiscal codes}
\usage{
wrong_fc(fc)
}
\arguments{
\item{fc}{A character vector of fiscal codes.}
}
\value{
The function return \code{TRUE} if the fiscal code is wrong,
\code{FALSE} otherwise.
}
\description{
The function performs fiscal codes check (both regular and temporary
ones), computing the last (control) character basing on the others.  The
algorithm is intended to be quite "draconian", so you'll better make
some pre-cleaning (keep only alphabetic characters and uppercase) if
needed. See examples.
}
\examples{

fc <- c(NA, "qWeASd34D12h 221M   ", " 12312312312 ")
wrong_fc(fc)
fc <- gsub(" ","", toupper(fc))
wrong_fc(fc)

}
\references{
Law source: D.M. (Ministry of Finance) n. 13813 - 23/12/76 -
"Sistemi di codificazione dei soggetti da iscrivere all'anagrafe
tributaria". Supp. ord. G.U. 345 29/12/1976.
}
