#include <R.h>
#include <Rinternals.h>

#define FC_LEN 11
#define EVEN(x) ( ((x) % 2) == 0)

int tmp_recode_even_digits(int code);
int tmp_recode_odd_digits(int code);

SEXP wrong_tmp_fc(SEXP fiscalCodes){

    int len = length(fiscalCodes); /* input */
    const char * fc;

    SEXP res;			   /* results vector */
    res = PROTECT(allocVector(LGLSXP, len));
    int * pres = LOGICAL(res);

    int recoded[FC_LEN - 1] = {0}; /* recoded digits */
    int sum = 0;		   /* sum of recoded digits */
    
    int i, j;			/* misc counters */
    
    /* for each fiscal code */
    for(int i = 0; i < len; i++){
	fc = CHAR(STRING_ELT(fiscalCodes, i));

	/* for each character store the recoded value*/
	for(j = 0; j < FC_LEN - 1; j++){
	    recoded[j] = ( EVEN(j + 1) ?
			   tmp_recode_even_digits :
			   tmp_recode_odd_digits)((int)(*(fc + j) - '0'));
	}

	/* sum the recoded values */
	for(j = 0; j < FC_LEN - 1; j++)
	    sum += recoded[j];
	
	/* set output  */
	pres[i] = ((10 - (sum % 10)) % 10) != ((*(fc + (FC_LEN - 1))) - '0');

	/* clean */
	sum = 0;
	memset(recoded, 0, sizeof(int) * (FC_LEN - 1));
		 
    }

    UNPROTECT(1);
    return res;
}

/*  pari */
int tmp_recode_even_digits(int code){

    static const int result[] = {0, 2, 4, 6, 8, 1, 3, 5, 7, 9};
    return result[code];

}

/*  dispari */
int tmp_recode_odd_digits(int code){

    return code;

}
