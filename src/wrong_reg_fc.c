#include <R.h>
#include <Rinternals.h>
#include "ifctools.h"
#include "reg_check_digit.h"

SEXP wrong_reg_fc(SEXP fiscalCodes){

    int len = length(fiscalCodes); /* input */
    const char * fc;
    SEXP res;			   /* results vector */
    res = PROTECT(allocVector(LGLSXP, len));
    int * pres = LOGICAL(res);
    /* check each fiscal code in turn */
    for(int i = 0; i < len; i++){
	fc = CHAR(STRING_ELT(fiscalCodes, i));
	pres[i] = reg_check_digit(fc) != (*(fc + (FC_LEN - 1)));
    }
    UNPROTECT(1);
    return res;

}



