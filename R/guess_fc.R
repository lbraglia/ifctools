#' Guess Italian Fiscal Code
#' 
#' The function tryies to guess regular fiscal code, extracting relevant
#' alphanumeric digits from surname, name, birth date, gender and 'codice
#' catastale' (computing the last character, the control digit).
#' 
#' @param surname character, surname
#' @param name character, names
#' @param birthdate Date, date of birth
#' @param female logical, female indicator variable (\code{FALSE} = man,
#' \code{TRUE} = woman)
#' @param codice_catastale  italian 'codice catastale' (an identifier) of
#' the 'comune' of birth
#' @return The function return a character vector of fiscal code. 
#' @examples
#' 
#' ## ... using fake data
#' surnames <- c("Rossi", "Bianchi")
#' names <- c("Mario", "Giovanna")
#' birthdates <- as.Date(c("1960-01-01", "1970-01-01"))
#' comune_of_birth <- c("F205", # milan
#'                      "H501") # rome
#' female <- c(FALSE, TRUE)
#' guess_fc(surnames, names, birthdates, female, comune_of_birth)
#' ## c("RSSMRA60A01F205T", "BNCGNN70A41H501V")
#' 
#' @export 
guess_fc <- function(surname = NULL,
                     name = NULL,
                     birthdate = NULL,
                     female = NULL,
                     codice_catastale = NULL) 
{

  ## validate input
  if(! is.character(surname))
    stop("surname must be a character vector.")
  if(! is.character(name))
    stop("name must be a character vector.")
  if(! inherits(birthdate, "Date"))
    stop("birthdate must be a Date vector.")
  if(! is.logical(female))
    stop("female must be a logical vector.")
  if(! is.character(codice_catastale))
    stop("codice_catastale must be a character vector.")

  ## validate lengths
  Len <- unlist(lapply(list(surname, name, birthdate,
                            female, codice_catastale),
                length))
  if (var(Len) > 0){
    stop("all vector must be of the same legth")
  }
  
  ## normalize input
  surname[surname %in% ""] <- NA
  name[name %in% ""] <- NA
  codice_catastale[codice_catastale %in% ""]  <- NA  
  female <- as.integer(female)
  year <- as.integer(format(birthdate, "%Y"))
  month <- as.integer(format(birthdate, "%m"))
  day <- as.integer(format(birthdate, "%d"))

  ## locate rows with NAs
  NAS <- apply(do.call("rbind",
                       lapply(list(surname, name, birthdate,
                                   female, codice_catastale),
                              is.na)),
               2, any)

  ## return value
  rval <- rep(NA_character_, Len[1])
  rval[!NAS] <- .Call("reg_wrong_fc",
                      surname[!NAS],
                      name[!NAS],
                      year[!NAS],
                      month[!NAS],
                      day[!NAS],
                      female[!NAS],
                      codice_catastale[!NAS],
                      PACKAGE = "ifctools")
  rval

}
