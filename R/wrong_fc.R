#' Check Italian fiscal codes
#' 
#' The function performs fiscal codes check (both regular and temporary
#' ones), computing the last (control) character basing on the others.  The
#' algorithm is intended to be quite "draconian", so you'll better make
#' some precleaning (remove blank spaces and upcase) if needed. See
#' examples.
#' 
#' @param fc A character vector of fiscal codes.
#' @return The function return \code{TRUE} if the fiscal code is wrong,
#' \code{FALSE} otherwise.
#' @references Law source: D.M. (Ministry of Finance) n. 13813 - 23/12/76 -
#' "Sistemi di codificazione dei soggetti da iscrivere all'anagrafe
#' tributaria". Supp. ord. G.U. 345 29/12/1976.
#' @examples
#' 
#' fc <- c(NA, "qWeASd34D12h 221M   ", " 12312312312 ")
#' wrong_fc(fc) 
#' fc <- gsub(" ","", toupper(fc))
#' wrong_fc(fc)
#' 
#' @export 
wrong_fc <- function(fc) 
{
  if( ! (is.character(fc) & is.null(dim(fc))) )
    stop("The input must be a character vector.")
    
  ## Matching patterns and dummy indexes
  reg_ptrn <- "[A-Z]{6}\\d{2}[A-Z]{1}\\d{2}[A-Z]{1}\\d{3}[A-Z]{1}" 
  tmp_ptrn <- "\\d{11}"
  reg_indx <- grepl(reg_ptrn, fc, perl = TRUE)
  tmp_indx <- grepl(tmp_ptrn, fc, perl = TRUE)

  ## Results: wrong until proven to be right (unless NA, handled below)
  fc_error <- rep(TRUE, length(fc))

  ## Check regular fc: to keep C side simple, regular and temporary
  ## codes are checked in two separate functions
  if (any(reg_indx))
    fc_error[reg_indx] <-
      .Call("wrong_reg_fc", fc[reg_indx], PACKAGE="ifctools")

  ## Check temporary fc (extended = FALSE causes more testing to be needed)
  if (any(tmp_indx))
    fc_error[tmp_indx] <-
      .Call("wrong_tmp_fc", fc[tmp_indx], PACKAGE="ifctools")

  ## managing NAs
  fc_error[is.na(fc)] <- NA

  ## Return
  fc_error
}




## Temporary fiscal code main check function
tmp.fc.check <- function(fc, extended=FALSE){

    uno <- as.numeric(substr(fc, 1,1))
    due <- as.numeric(substr(fc, 2,2))
    tre <- as.numeric(substr(fc, 3,3))
    quattro <- as.numeric(substr(fc, 4,4))
    cinque <- as.numeric(substr(fc, 5,5))
    sei <- as.numeric(substr(fc, 6,6))
    sette <- as.numeric(substr(fc, 7,7))
    otto <- as.numeric(substr(fc, 8,8))
    nove <- as.numeric(substr(fc, 9,9))
    dieci <- as.numeric(substr(fc, 10,10))
    check.digit <- as.numeric(substr(fc, 11,11))
    
    dispari <- uno + tre + cinque + sette + nove

    pari <-
        tmp.fc.check.helper(due) + 
            tmp.fc.check.helper(quattro) +
                tmp.fc.check.helper(sei) +
                    tmp.fc.check.helper(otto) +
                        tmp.fc.check.helper(dieci)

    somma <- as.character(dispari+pari)

    subtraction <- (10 - as.numeric(substr(somma, nchar(somma),
                                           nchar(somma))))

    ## C'è errore se le unità della sottrazione (resto della
    ## divisione per 10) non sono uguali al codice di controllo

    error <- (subtraction %% 10) != check.digit

    ## la regola generica presentata nella legge (TODO)
    ## terminerebbe qui; nel sorgente java messo a disposizione
    ## dalla sogei per il calcolo si introducono alcune eccezioni
    ## legate al codice di ufficio, che si rifanno al documento
    ## (TODO). La loro applicazione, nella presente implementazione
    ## è legata alla variabile "extended", specificata in sede di
    ## chiamata di tmp.fc.check.

    prime7 <- as.numeric(substr(fc, 1,7))
    coduff <- as.numeric(substr(fc, 8,10))
    coduff.nullo <- coduff==0

    if(extended) {
        
        ## Se il cf ha le prime 7 cifre che sono tutte nulle è
        ## sbagliato, anche se il codice di controllo è giusto. Testato
        ## sul programma sogei con il codice (TODO)
        
        error[prime7==0] <- TRUE
        
        ## se il codice ufficio è nullo(==0) e 0<prime7<273961 il codice
        ## fiscale è giusto qualunque sia il codice di controllo (anche
        ## se è sbagliato).  Testato sul programma sogei con il codice
        ## (TODO)
        
        error[coduff.nullo & prime7>0 & prime7<273961] <- FALSE
        
        ## se il codice ufficio è nullo e prime7 sono nei range
        ## (estremi inclusi)
        ## 273961 - 4000000
        ## 1072488 - 1500000
        ## 1828637 - 2000000
        ## 2054096 - 9999999
        ## allora il cf è sbagliato

        error[coduff.nullo & (
            ( prime7 >=  273961 & prime7 <= 4000000) |
            ( prime7 >= 1072488 & prime7 <= 1500000) |
            ( prime7 >= 1828637 & prime7 <= 2000000) |
            ( prime7 >= 2054096 & prime7 <= 9999999) 
            )] <- TRUE
        
        ## se il codice ufficio è nei range
        ## 0 < coduff <101
        ## 119 < coduff <122
        ## 122 <= coduff <= 150
        ## 246 <= coduff <= 300
        ## 767 <= coduff <= 899
        ## 951 <= coduff <= 999
        ## allora il cf (persone fisiche) è sbagliato

        error[
              ( coduff >    0 & coduff < 101) |
              ( coduff >  119 & coduff < 122) |
              ( coduff >= 122 & coduff <= 150) |
              ( coduff >= 246 & coduff <= 300) |
              ( coduff >= 767 & coduff <= 899) |
              ( coduff >= 951 & coduff <= 999) 
              ] <- TRUE
        
    }
    
    as.logical(error)
    
}


## tmp.fc.get.check.digit <- function(fc){

##   uno <- as.numeric(substr(fc, 1,1))
##   due <- as.numeric(substr(fc, 2,2))
##   tre <- as.numeric(substr(fc, 3,3))
##   quattro <- as.numeric(substr(fc, 4,4))
##   cinque <- as.numeric(substr(fc, 5,5))
##   sei <- as.numeric(substr(fc, 6,6))
##   sette <- as.numeric(substr(fc, 7,7))
##   otto <- as.numeric(substr(fc, 8,8))
##   nove <- as.numeric(substr(fc, 9,9))
##   dieci <- as.numeric(substr(fc, 10,10))

##   foo <- uno + tre + cinque + sette + nove

##   bar <-
##     tmp.fc.check.helper(due) + 
##     tmp.fc.check.helper(quattro) +
##     tmp.fc.check.helper(sei) +
##     tmp.fc.check.helper(otto) +
##     tmp.fc.check.helper(dieci)

##   asd <- as.character(foo+bar)

##   subtraction <- (10 - as.numeric(substr(asd, nchar(asd),
##                                          nchar(asd))))

##   subtraction %% 10

## }



tmp.fc.check.helper <- function(value){

    result <- c(0,                        # 0*2
                2,                        # 1*2
                4,                        # ...
                6,
                8,
                1,                        # 5*2=10 -> 1+0=1
                3,                        # 6*2=12 -> 1+2=3
                5,                        # ...
                7,
                9)
    
    result[value+1]

}
