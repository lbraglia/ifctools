fc.check <- function(fc) 
{
  ## require(car)

  if( ! (is.vector(fc) & typeof(fc)=="character")  )
    stop("The input must be a character vector.")
  
  ## Matching patterns and dummies
  dfnt.ptrn <-
    "[A-Z]{6}\\d{2}[A-Z]{1}\\d{2}[A-Z]{1}\\d{3}[A-Z]{1}" 
  tmp.ptrn <-  "\\d{11}"
  definitivo <- grepl( dfnt.ptrn, fc, perl=TRUE)
  provvisorio <- grepl( tmp.ptrn, fc, perl=TRUE)

  ## Return value generation
  fc.error <- rep(TRUE, length(fc))
  if (any(definitivo)){                 # Check definitive fc
    fc.error[definitivo]  <- dfnt.fc.check(fc[definitivo])
  }
  if (any(provvisorio)){                # Check temp fc:
                                        # extended=F cause more
                                        # testing is needed
    fc.error[provvisorio] <- tmp.fc.check(fc[provvisorio], extended=FALSE)
  }                                     
  fc.error[is.na(fc)]   <- NA

  ## Return
  as.logical(fc.error)
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

  prime7 <- as.numeric(substr(fc, 1,7))
  coduff <- as.numeric(substr(fc, 8,10))
  check.digit <- as.numeric(substr(fc, 11,11))

  coduff.nullo <- coduff==0
  
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






## Definitive fiscal code main check function

dfnt.fc.check <- function(fc){
  
  uno <- substr(fc, 1,1)
  due <- substr(fc, 2,2)
  tre <- substr(fc, 3,3)
  quattro <- substr(fc, 4,4)
  cinque <- substr(fc, 5,5)
  sei <- substr(fc, 6,6)
  sette <- substr(fc, 7,7)
  otto <- substr(fc, 8,8)
  nove <- substr(fc, 9,9)
  dieci <- substr(fc, 10,10)
  undici <- substr(fc, 11,11)
  dodici <- substr(fc, 12,12)
  tredici <- substr(fc, 13,13)
  quattordici <- substr(fc, 14,14)
  quindici <- substr(fc, 15,15)
  sedici <- substr(fc, 16,16)


# Controllo coerenza codice controllo con il resto
# -------------------------------------------------
# recode dei caratteri alfanumerici pari
# due, quattro, sei, otto, dieci, dodici, quattordici


  par1 <- "'0'=0"
  par2 <- "'1'=1"
  par3 <- "'2'=2"
  par4 <- "'3'=3"
  par5 <- "'4'=4"
  par6 <- "'5'=5"
  par7 <- "'6'=6"
  par8 <- "'7'=7"
  par9 <- "'8'=8"
  par10 <- "'9'=9"
  par11 <- "'A'=0"
  par12 <- "'B'=1"
  par13 <- "'C'=2"
  par14 <- "'D'=3"
  par15 <- "'E'=4"
  par16 <- "'F'=5"
  par17 <- "'G'=6"
  par18 <- "'H'=7"
  par19 <- "'I'=8"
  par20 <- "'J'=9"
  par21 <- "'K'=10"
  par22 <- "'L'=11"
  par23 <- "'M'=12"
  par24 <- "'N'=13"
  par25 <- "'O'=14"
  par26 <- "'P'=15"
  par27 <- "'Q'=16"
  par28 <- "'R'=17"
  par29 <- "'S'=18"
  par30 <- "'T'=19"
  par31 <- "'U'=20"
  par32 <- "'V'=21"
  par33 <- "'W'=22"
  par34 <- "'X'=23"
  par35 <- "'Y'=24"
  par36 <- "'Z'=25"



  recode_pari <- paste( par1 , par2 , par3 , par4 , par5 , par6 ,
                     par7 , par8 , par9 , par10 , par11 , par12 ,
                     par13 , par14 , par15 , par16 , par17 ,
                     par18 , par19 , par20 , par21 , par22 ,
                     par23 , par24 , par25 , par26 , par27 ,
                     par28 , par29 , par30 , par31 , par32 ,
                     par33 , par34 , par35 , par36 , "else=NA",
                     sep=";")
  
  
  due_rec<- recode(due, recode_pari )
  quattro_rec<- recode(quattro , recode_pari )
  sei_rec<- recode(sei , recode_pari )
  otto_rec<- recode(otto , recode_pari )
  dieci_rec<- recode( dieci, recode_pari )
  dodici_rec<- recode( dodici, recode_pari )
  quattordici_rec<- recode( quattordici, recode_pari )


                                        # recode dei caratteri
                                        # alfanumerici dispari
                                        # uno, tre, cinque,
                                        # sette, nove, undici,
                                        # tredici, quindici



  dis1 <- "'0'=1"
  dis2 <- "'1'=0"
  dis3 <- "'2'=5"
  dis4 <- "'3'=7"
  dis5 <- "'4'=9"
  dis6 <- "'5'=13"
  dis7 <- "'6'=15"
  dis8 <- "'7'=17"
  dis9 <- "'8'=19"
  dis10 <- "'9'=21"
  dis11 <- "'A'=1"
  dis12 <- "'B'=0"
  dis13 <- "'C'=5"
  dis14 <- "'D'=7"
  dis15 <- "'E'=9"
  dis16 <- "'F'=13"
  dis17 <- "'G'=15"
  dis18 <- "'H'=17"
  dis19 <- "'I'=19"
  dis20 <- "'J'=21"
  dis21 <- "'K'=2"
  dis22 <- "'L'=4"
  dis23 <- "'M'=18"
  dis24 <- "'N'=20"
  dis25 <- "'O'=11"
  dis26 <- "'P'=3"
  dis27 <- "'Q'=6"
  dis28 <- "'R'=8"
  dis29 <- "'S'=12"
  dis30 <- "'T'=14"
  dis31 <- "'U'=16"
  dis32 <- "'V'=10"
  dis33 <- "'W'=22"
  dis34 <- "'X'=25"
  dis35 <- "'Y'=24"
  dis36 <- "'Z'=23"


recode_disp <- paste( dis1 , dis2 , dis3 , dis4 , dis5 , dis6 ,
                     dis7 , dis8 , dis9 , dis10 , dis11 , dis12 ,
                     dis13 , dis14 , dis15 , dis16 , dis17 ,
                     dis18 , dis19 , dis20 , dis21 , dis22 ,
                     dis23 , dis24 , dis25 , dis26 , dis27 ,
                     dis28 , dis29 , dis30 , dis31 , dis32 ,
                     dis33 , dis34 , dis35 , dis36 , "else=NA",
                     sep=";")


uno_rec<- recode(uno, recode_disp )
tre_rec<- recode(tre, recode_disp )
cinque_rec<- recode(cinque, recode_disp )
sette_rec<- recode(sette, recode_disp )
nove_rec<- recode(nove, recode_disp )
undici_rec<- recode(undici, recode_disp )
tredici_rec<- recode(tredici, recode_disp )
quindici_rec<- recode(quindici, recode_disp )

somma <- 
  uno_rec 	+ 
    due_rec  	+ 
      tre_rec 	+
        quattro_rec	+
          cinque_rec 	+
            sei_rec 	+
              sette_rec 	+
                otto_rec 	+
                  nove_rec 	+
                    dieci_rec 	+
                      undici_rec 	+
                        dodici_rec 	+
                          tredici_rec +
                            quattordici_rec	+
                              quindici_rec
  

  restodiv <- somma %% 26	



  res1<-"0='A'"
  res2<-"1='B'"
  res3<-"2='C'"
  res4<-"3='D'"
  res5<-"4='E'"
  res6<-"5='F'"
  res7<-"6='G'"
  res8<-"7='H'"
  res9<-"8='I'"
  res10<-"9='J'"
  res11<-"10='K'"
  res12<-"11='L'"
  res13<-"12='M'"
  res14<-"13='N'"
  res15<-"14='O'"
  res16<-"15='P'"
  res17<-"16='Q'"
  res18<-"17='R'"
  res19<-"18='S'"
  res20<-"19='T'"
  res21<-"20='U'"
  res22<-"21='V'"
  res23<-"22='W'"
  res24<-"23='X'"
  res25<-"24='Y'"
  res26<-"25='Z'"
  
  recode_resto<- paste( res1 , res2 , res3 , res4 , res5 , res6 ,
                       res7 , res8 , res9 , res10 , res11 , res12
                       , res13 , res14 , res15 , res16 , res17 ,
                       res18 , res19 , res20 , res21 , res22 ,
                       res23 , res24 , res25 , res26 , "else=NA",
                       sep=";")
  
  codice <- recode(restodiv,recode_resto)

  as.logical(codice!=sedici)

}
