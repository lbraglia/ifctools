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
    int i;		       /* a counter */
    char single_fiscal_code[REG_FC_LEN + 1] = {'\0'}; /* single fc buffer */
    SEXP fiscal_codes = PROTECT(allocVector(STRSXP, len)); /* results */

    /* for each element in turn */
    for(i = 0; i < len; i++){

	SET_STRING_ELT(fiscal_codes,
		       i,
		       mkChar(reg_guess_fc_worker(CHAR(STRING_ELT(surname, i)),
						  CHAR(STRING_ELT(name, i)),
						  INTEGER(year)[i],
						  INTEGER(month)[i],
						  INTEGER(day)[i],
						  INTEGER(female)[i],
						  CHAR(STRING_ELT(codice_catastale, i)),
						  single_fiscal_code)));
	memset(single_fiscal_code, '\0', REG_FC_LEN + 1);
    }
    
    UNPROTECT(1);
    return fiscal_codes;
}
