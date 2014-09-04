ifctools [![Build Status](https://travis-ci.org/lbraglia/ifctools.svg)](https://travis-ci.org/lbraglia/ifctools) [![Build status](https://ci.appveyor.com/api/projects/status/reyqnq9eqhcrtj96)](https://ci.appveyor.com/project/lbraglia/ifctools)
========

This [R](http://www.r-project.org/) package provides utility
fuctions to deal with italian [fiscal codes](http://en.wikipedia.org/wiki/Italian_fiscal_code_card).

Italian fiscal code constitutes a typical id for statistical
units among different italian datasets. It's a 16 char unique
value assigned by the tax office (the italian "Agenzia delle
Entrate"), given individual infos like name, surname, date and
place of birth.

From the data analyst standpoint, many times one need to merge
different data sources on the basis of a fiscal code vector; not
always these information are reliable (e.g. imputation
error). This can cause the units not to match.

This package aims to provide utility fuctions to deal with italian
fiscal codes. 

## Install

You can install this package via GitHub. Before that, you
need to setup [`devtools` and
Rtools](http://www.rstudio.com/products/rpackages/devtools/).

Then:
```r
install_github("ifctools", "lbraglia")
```
