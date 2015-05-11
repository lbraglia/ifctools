#include <R.h>
#include <Rinternals.h>
#include "ifctools.h"
#include "reg_guess_fc_worker.h"

SEXP reg_guess_fc(SEXP surname,
		  SEXP name,
		  SEXP year,
		  SEXP month,
		  SEXP day,
		  SEXP female,
		  SEXP codice_catastale)
{

    int len = length(surname); /* input length*/
    int i;			/* a counter */

    const char * Surname;  /* c-level surname */
    const char * Name;	  /* c-level name */
    const char * Codice_catastale; /* c-level codice catastale */

    /* a single fiscal code buffer */
    char single_fiscal_code[REG_FC_LEN + 1] = {'\0'};
    SEXP fiscal_codes;    /* returned vector of fiscal codes */

    /* allocate results vector */
    fiscal_codes = PROTECT(allocVector(STRSXP, len));
    /* move SEXP data of fiscal codes to c-level */
    
    
    /* check each record in turn */
    for(i = 0; i < len; i++){

	Surname = CHAR(STRING_ELT(surname, i));
	Name    = CHAR(STRING_ELT(name   , i));
	Codice_catastale = CHAR(STRING_ELT(codice_catastale, i));
	
	SET_STRING_ELT(fiscal_codes,
		       i,
		       mkChar(reg_guess_fc_worker(Surname,
						  Name,
						  INTEGER(year)[i],
						  INTEGER(month)[i],
						  INTEGER(day)[i],
						  INTEGER(female)[i],
						  Codice_catastale,
						  single_fiscal_code)));
	memset(single_fiscal_code, '\0', REG_FC_LEN + 1);
    }
    
    UNPROTECT(1);
    return fiscal_codes;
}



