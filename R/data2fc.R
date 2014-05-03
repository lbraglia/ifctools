# load("C://lavori/cf/avv.rda")
# source("C://lavori/cf/data2cf.R")

#data2fc <- function(cogn,     # Cognome
#                    nom,      # Nome
#                    datnas,   # Data nascita
#                    gender,   # Genere==DONNA: 1=F, 0=M
#                    comnas    # Comune di nascita
#                    ) {
#
#}



# Funzione per creare le prime tre lettere dato il vettore di cognomi
#get_cogn <- function(cogn)
#{
    # Per info
    # http://www.agenziaentrate.gov.it/ilwwcm/connect/Nsi/Servizi/Codice+fiscale+-+tessera+sanitaria/NSI+Informazioni+sulla+codificazione+delle+persone+fisiche    
    
    # Faccio l'upcase e tolgo tutto quello che non è lettera
#     cogn <- gsub("[\\W_0-9]", "" ,toupper(cogn), perl = T)

     # Le vocali accentate o con dieresi sono trattate come vocali normali
     # http://www.nonsolocap.it/codice-fiscale/?cg=BRAGLIA&nm=L%D9CA&ss=M&lg=REGGIO+EMILIA&dn=04/11/1983

#    cogn <- gsub("[ÀÁÄ]", "A",  cogn, perl = T)
#    cogn <- gsub("[ÈÉË]", "E",  cogn, perl = T)             
##    cogn <- gsub("[ÌÍÏ]", "I",  cogn, perl = T)
#    cogn <- gsub("[ÒÓÖ]", "O",  cogn, perl = T)
#    cogn <- gsub("[ÙÚÜ]", "U",  cogn, perl = T)
    


    # Individuazione delle prime tre vocali/consonanti
    
#    cogn                        
#}
              
#get_cogn(c("ÈÉas[]da_sda     sd", "35a#  d;123?'"))

#c("BRAGLIA","LUCA")

# Prime tre consonanti  e prime tre vocali
#mycogn <- "FO"

provgc <- function(mycogn) {
  vows <- LETTERS [  c(1,5,9,15,21)]
  cons <- LETTERS [- c(1,5,9,15,21)]
  let<- unlist(strsplit(mycogn, ""))
  my3cons <- let [! is.na(cons[charmatch( let, cons)])] [1:3]
  my3vows <- let [! is.na(vows[charmatch( let, vows)])] [1:3]

  # Eliminazione delle NA
  my3cons<-my3cons[!is.na(my3cons)]
  my3vows<-my3vows[!is.na(my3vows)]
 
  # Combinazione secondo l'algoritmo
  # incollo prima tutte le consonanti poi ci attacco le vocali
  # alla fine le X, poi trimmo a 3

  strtrim(paste(  paste( my3cons, sep="", collapse=""),
                  paste( my3vows, sep="", collapse=""),
                  "XXX",
                  sep="",
                  collapse = ""
                ) 
          ,3
          )
}
                
provgn <- function(mynom) {
  vows <- LETTERS [  c(1,5,9,15,21)]
  cons <- LETTERS [- c(1,5,9,15,21)]
  let<- unlist(strsplit(mynom, ""))                            
  mycons <- let [! is.na(cons[charmatch( let, cons)])] [1:4]
  myvows <- let [! is.na(vows[charmatch( let, vows)])] [1:3]
  mycons<-mycons[!is.na(mycons)]
  myvows<-myvows[!is.na(myvows)]

  if (length(mycons)==4)
    nom <- paste( mycons[1], mycons[3],mycons[4],sep="", collapse="" )
  else
    nom <- strtrim(paste( paste( mycons, sep="", collapse=""),
                          paste( myvows, sep="", collapse=""),
                          "XXX",
                          sep="",
                          collapse = ""
                ) 
          ,3
          )
  
  nom
}
  
  
provdatses <- function(dat_nas, donna) {
  require(car)
  day<- format(dat_nas , "%d")
  day<- paste("0", as.character( as.numeric(day)+donna*40 ),sep="", collapse="")
  day<- substr(day, nchar(day)-1, nchar(day))
  mon<- format(dat_nas , "%m")
  mon<- recode(mon,"'01'='A'; '02'='B'; '03'='C'; '04'='D';'05'='E'; '06'='H';'07'='L';'08'='M'; '09'='P';'10'='R';'11'='S'; '12'='T'" )
  yea<- format(dat_nas , "%y")
  
  
  paste(  yea, mon, day,sep="", collapse="" )
              
}              
              
                 
             
              
