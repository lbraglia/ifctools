#include "reg_check_digit.h"

/* compute right check digit */
char reg_check_digit(const char * fc){

    int recoded[REG_FC_LEN - 1] = {0}; /* recoded digits */
    int sum = 0;		   /* sum of recoded digits */
    int j;
    /* for each character store the recoded value*/
    for(j = 0; j < REG_FC_LEN - 1; j++){
	recoded[j] = ( IS_EVEN(j + 1) ?
		       reg_recode_even_digits :
		       reg_recode_odd_digits)(*(fc + j));
    }

    /* sum the recoded values */
    for(j = 0; j < REG_FC_LEN - 1; j++)
	sum += recoded[j];

    return reg_recode_remainder(sum % 26);
    
}

static int reg_recode_even_digits(char code){

    switch(code) {
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
	return ((int) (code - '0'));
    case 'A':
    case 'B':
    case 'C':
    case 'D':
    case 'E':
    case 'F':
    case 'G':
    case 'H':
    case 'I':
    case 'J':
    case 'K':
    case 'L':
    case 'M':
    case 'N':
    case 'O':
    case 'P':
    case 'Q':
    case 'R':
    case 'S':
    case 'T':
    case 'U':
    case 'V':
    case 'W':
    case 'X':
    case 'Y':
    case 'Z':
	return((int) (code - 'A'));
    default:
	return -1;
    }    

}

static int reg_recode_odd_digits(char code){

    switch(code) {
    case '0':
    case 'A':
	return 1;
    case '1':
    case 'B':
	return 0;
    case '2':
    case 'C':
	return 5;
    case '3':
    case 'D':
	return 7;
    case '4':
    case 'E':
	return 9;
    case '5':
    case 'F':
	return 13;
    case '6':
    case 'G':
	return 15;
    case '7':
    case 'H':
	return 17;
    case '8':
    case 'I':
	return 19;
    case '9':
    case 'J':
	return 21;
    case 'K':
	return 2;
    case 'L':
	return 4;
    case 'M':
	return 18;
    case 'N':
	return 20;
    case 'O':
	return 11;
    case 'P':
	return 3;
    case 'Q':
	return 6;
    case 'R':
	return 8;
    case 'S':
	return 12;
    case 'T':
	return 14;
    case 'U':
	return 16;
    case 'V':
	return 10;
    case 'W':
	return 22;
    case 'X':
	return 25;
    case 'Y':
	return 24;
    case 'Z':
	return 23;
    default:
	return -1;
    }    

}

static char reg_recode_remainder(int rem){

    return( ((char) rem) + 'A');

}
