Italian Fiscal Codes with R
===========================

This [R](http://www.r-project.org/) package provides utility
fuctions to deal with italian fiscal codes.

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
need to setup `devtools` 

```R
install.packages("devtools", dependencies=TRUE)
```

Then:
```r
install_github("ifctools", "lbraglia")
```
On *some Unix platform* `install_github` has been [reported](https://github.com/hadley/devtools/issues/467) not to
work as expected. A handy workaround, in the meantime, could be the following
simple bash script (eg named `r_install_github`):

```bash
#!/bin/bash

cd /tmp && \
rm -rf R_install_github && \
mkdir R_install_github  && \
cd R_install_github && \
wget https://github.com/$2/$1/archive/master.zip && \
unzip master.zip
R CMD build $1-master && \
R CMD INSTALL $1*.tar.gz && \
cd /tmp && \
rm -rf R_install_github
```

and to install `ifctools` (after giving execution permissions and
putting it in a `PATH` directory):
```bash
r_install_github ifctools lbraglia
```
