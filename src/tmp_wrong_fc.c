#include <R.h>
#include <Rinternals.h>
#include "ifctools.h"
#include "tmp_check_digit.h"

SEXP tmp_wrong_fc(SEXP fiscalCodes){

    int len = length(fiscalCodes); /* input */
    const char * fc;

    SEXP res;			   /* results vector */
    res = PROTECT(allocVector(LGLSXP, len));
    int * pres = LOGICAL(res);
    int i;
    
    /* check each fiscal code in turn */
    for(i = 0; i < len; i++){
	fc = CHAR(STRING_ELT(fiscalCodes, i));
	pres[i] = tmp_check_digit(fc) != ((*(fc + (TMP_FC_LEN - 1))) - '0');
    }

    UNPROTECT(1);
    return res;

}
