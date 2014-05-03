\name{fc_check}
\alias{fc_check}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Check fiscal codes
}
\description{
  
  The function performs fiscal codes (both temporary and definitive)
  check, computing the last (control) character basing on the others.
  The algorithm is intended to be quite "draconian", so you'll better
  make some precleaning (remove blank spaces and upcase) if needed. See
  examples.
  
}

\usage{
fc_check(fc)
}

\arguments{
  \item{fc}{A character vector of fiscal codes.}
}

% \details{
  

% }

\value{
  The function return \code{TRUE} if the fiscal code is wrong,
  \code{FALSE} otherwise. 
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}

}

\references{
Law source: D.M. (Ministry of Finance) n. 13813 - 23/12/76 - "Sistemi di
  codificazione dei soggetti da iscrivere all'anagrafe
  tributaria". Supp. ord. G.U. 345 29/12/1976.
% Algorithm implemented: \url{http://tinyurl.com/ifc-check-algorithm}.  
%  It further add some check retrieved from java sources
%   included with the official
%   \url{http://www.agenziaentrate.it/ilwwcm/connect/Nsi/Servizi/Codice+fiscale+-+tessera+sanitaria/Controllo/}{program}
%   of the tax office to do fiscal code checking.

}
\author{
  
  Luca Braglia <\email{lbraglia@gmail.com}>
  
}
% \note{
% %%  ~~further notes~~
% }

%% ~Make other sections like Warning with \section{Warning }{....} ~

%% \seealso{
%%   \code{\link{ifctools}}
%%   %% ~~objects to See Also as \code{\link{help}}, ~~~
%% }
\examples{

## As i've said, the algo is quite draconian. Consider the code
## "QWEASD34D12H221M" (fictitious but right). I would like
## "qWeASd34D12h 221M   " to be (and it's) TRUE, because i consider it
## as an error (it's diminishing match probability).

fc_check("qWeASd34D12h 221M   ") 

## So you'll betted do pre-cleaning (upcase and blank trimming)

fc <- c("qWeASd34D12h 221M   ", "12312312312")
fc <- gsub(" ","", toupper(fc))
fc_check(fc)

## Check results with (i.e.)
## http://www.nonsolocap.it/codice-fiscale/controllo/  

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ fiscal }
\keyword{ code }
\keyword{ codice }
\keyword{ fiscale }
\keyword{ codici }
\keyword{ fiscali }
\keyword{ check }
\keyword{ controllo }
