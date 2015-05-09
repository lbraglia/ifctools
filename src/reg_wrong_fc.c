#include <R.h>
#include <Rinternals.h>
#include "ifctools.h"
#include "reg_check_digit.h"

SEXP reg_wrong_fc(SEXP fiscalCodes){

    int len = length(fiscalCodes); /* input */
    const char * fc;

    SEXP res;			   /* results vector */
    res = PROTECT(allocVector(LGLSXP, len));
    int * pres = LOGICAL(res);
    int i;
    
    /* check each fiscal code in turn */
    for(i = 0; i < len; i++){
	fc = CHAR(STRING_ELT(fiscalCodes, i));
	pres[i] = reg_check_digit(fc) != (*(fc + (REG_FC_LEN - 1)));
    }
    
    UNPROTECT(1);
    return res;
}



