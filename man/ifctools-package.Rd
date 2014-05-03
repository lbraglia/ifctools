\name{ifctools-package}
\alias{ifctools-package}
\alias{ifctools}
\docType{package}
\title{
  Italian fiscal code miscellaneous utilities
}
\description{
  
Italian fiscal code constitutes a typical id for statistical units among
different italian datasets. It's a 16 char unique value assigned by the
tax office (the italian "Agenzia delle Entrate"), given individual infos
like name, surname, date and place of birth.

From the data analyst standpoint, many times one need to merge different
data sources on the basis of a fiscal code vector; not always these
information are reliable (e.g. imputation error). This can cause the
units not to match.

This package provides utility fuctions to deal with italian fiscal codes
. The most important ones are \code{\link{fc.check}} and \code{data2fc}:
they can be used to determine if fiscal codes are wrong and, if so, to
"guess" the right ones (provided you've the necessary data).

}
\details{
\tabular{ll}{
Package: \tab ifctools\cr
Type: \tab Package\cr
Version: \tab 0.1\cr
Date: \tab 2010-01-27\cr
Depends: \tab car \cr
License: \tab GPL (>=2)\cr
LazyLoad: \tab yes\cr
}
}
\author{
  Luca Braglia <\email{lbraglia@gmail.com}>
}
\references{
    
}

\keyword{ package }
\keyword{ fiscal }
\keyword{ code }
\keyword{ codice }
\keyword{ fiscale }
\keyword{ codici }
\keyword{ fiscali }
\keyword{ check }

\seealso{
  \code{\link{fc.check}}
}
\examples{
## TODO: make this runnable
## final.fc <- ifelse(fc.check(fc), data2fc(data), fc)
}
