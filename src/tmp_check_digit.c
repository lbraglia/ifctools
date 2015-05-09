#include "tmp_check_digit.h"

int tmp_check_digit(const char * fc){

    int recoded[TMP_FC_LEN - 1] = {0}; /* recoded digits */
    int sum = 0;		   /* sum of recoded digits */
    int j;
    
    /* for each character store the recoded value*/
    for(j = 0; j < TMP_FC_LEN - 1; j++){
	recoded[j] = ( IS_EVEN(j + 1) ?
		       tmp_recode_even_digits :
		       tmp_recode_odd_digits)((int)(*(fc + j) - '0'));
    }
    
    /* sum the recoded values */
    for(j = 0; j < TMP_FC_LEN - 1; j++)
	sum += recoded[j];
    
    return ((10 - (sum % 10)) % 10);

}

static int tmp_recode_even_digits(int code){

    static const int result[] = {0, 2, 4, 6, 8, 1, 3, 5, 7, 9};
    return result[code];

}

static int tmp_recode_odd_digits(int code){

    return code;

}
