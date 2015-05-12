#include <stdio.h>
#include <string.h>
#include "reg_check_digit.h"
#include "reg_guess_fc_worker.h"

static int is_vowel(char c);
static char * extract_surname(const char * source, char * output);
static char * extract_name(const char * source, char * output);
static char * extract_year(int year, char * output);
static char * extract_month(int month, char * output);
static char * extract_day(int day, int female, char * output);

char * reg_guess_fc_worker(const char * surname,
			   const char * name,
			   const int year,
			   const int month,
			   const int day,
			   const int female,
			   const char * codice_catastale,
			   char * fiscal_code)
{
    
    extract_surname(surname, fiscal_code);
    extract_name(name,    fiscal_code + 3);
    extract_year(year,       fiscal_code + 6);        
    extract_month(month,     fiscal_code + 8);
    extract_day(day, female, fiscal_code + 9);
    strncat(fiscal_code + 11, codice_catastale, 4);
    *(fiscal_code + 15) = reg_check_digit(fiscal_code);
    
    return fiscal_code;

}

/* todo optimize on the basis of vowel frequency in italian surnames */
static int is_vowel(char c){
    switch (c) {
    case 'A':
    case 'E':
    case 'I':
    case 'O':
    case 'U':
	return 1;
    default:
	return 0;
    }
}

static char * extract_surname(const char * source, char * output){
    char c;			/* considered letter */
    int  i = 0;			/* cycle counter */
    int  ncons = 0;		/* number of consonants  */
    int  nvows = 0;		/* number of vowels found */
    char vowels[3] = {'\0'};
    static const char X[3] = {'X', 'X', 'X'};
    
    /* go through the string and put the consonants in the output */
    while (((c = *(source + i)) != '\0') && (ncons < 3) ){

	if ( !is_vowel( c )){
	    /* letter is not a vowel: if it's not a white space too (aka it's a
	       consonant) put it in the output */  
	    if( c != ' ') {
		*(output + ncons++) = c;
	    }
	} else {
	    /* letter is a vowel: put in the vowel buffer (if not already
	       full) */
	    if (nvows < 3) {
		*(vowels + nvows++) = c;
	    }
	}
	
	i++;
    }

    /* copy needed vowels */
    /* 3 - ncons bytes would be needed */
    /* nvows is what is available */
    memcpy(output + ncons, vowels, MIN(3 - ncons, nvows));

    /* add needed 'X' */
    /* 3 - ncons - nvows is what is needed */
    if (3 - ncons - nvows > 0)
    	memcpy(output + ncons + nvows, X, 3 - ncons - nvows);
    
    return output;
}

static char * extract_name(const char * source, char * output){
    char c;			/* considered letter */
    int  i = 0;			/* cycle counter */
    int  ncons = 0;		/* number of consonants  */
    int  nvows = 0;		/* number of vowels found */
    char vowels[3] = {'\0'};
    static const char X[3] = {'X', 'X', 'X'};
    
    /* go through the string and put the consonants in the output */
    while (((c = *(source + i)) != '\0') && (ncons < 3) ){

	if ( !is_vowel( c )){
	    /* letter is not a vowel: if it's not a white space too (aka it's a
	       consonant) put it in the output */  
	    if( c != ' ') {
		*(output + ncons++) = c;
	    }
	} else {
	    /* letter is a vowel: put in the vowel buffer (if not already
	       full) */
	    if (nvows < 3) {
		*(vowels + nvows++) = c;
	    }
	}
	
	i++;
    }

    /* copy needed vowels */
    /* 3 - ncons bytes would be needed */
    /* nvows is what is available */
    memcpy(output + ncons, vowels, MIN(3 - ncons, nvows));

    /* add needed 'X' */
    /* 3 - ncons - nvows is what is needed */
    if (3 - ncons - nvows > 0)
    	memcpy(output + ncons + nvows, X, 3 - ncons - nvows);
    
    return output;
}





static char * extract_year(int year, char * output){
    sprintf(output, "%2d", year % 1900);
    return output;
}

static char * extract_month(int month, char * output){

    switch (month) {
    case 1:
	output[0] = 'A';
	break;
    case 2:
	output[0] = 'B';
	break;
    case 3:
	output[0] = 'C';
	break;
    case 4:
	output[0] = 'D';
	break;
    case 5:
	output[0] = 'E';
	break;
    case 6:
	output[0] = 'H';
	break;
    case 7:
	output[0] = 'L';
	break;
    case 8:
	output[0] = 'M';
	break;
    case 9:
	output[0] = 'P';
	break;
    case 10:
	output[0] = 'R';
	break;
    case 11:
	output[0] = 'S';
	break;
    case 12:
	output[0] = 'T';
	break;
    default:
	break;
    }

    return output;
	   
}


char * extract_day(int day, int female, char * output){
    sprintf(output, "%02d", day + 40 * (female != 0));
    return output;
}
