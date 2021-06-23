#include <stdio.h>
#include <string.h>
#include "reg_check_digit.h"
#include "reg_guess_fc_worker.h"

static int is_vowel(char c);
static char * extract_surname(const char * source, char * output);
static char * extract_name(const char * source, char * output);
static char * extract_year(const int year, char * output);
static char * extract_month(const int month, char * output);
static char * extract_day(const int day, const int female, char * output);

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
    extract_name(name,       fiscal_code + 3);
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
	    /* consonant: put it in the output */
	    *(output + ncons++) = c;
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
    int  ncons = 0;		/* number of consonants found */
    int  nvows = 0;		/* number of vowels found */
    char consonants[4] = {'\0'};
    char vowels[3] = {'\0'};
    static const char X[3] = {'X', 'X', 'X'};
    
    /* go through the string and put the consonants in the proper buffer */
    while (((c = *(source + i)) != '\0') && (ncons < 4) ){

	if ( !is_vowel( c )){
	    /* consonant: put it in the consonants */
	    *(consonants + ncons++) = c;
	} else {
	    /* letter is a vowel: put in the vowel buffer (if not already
	       full) */
	    if (nvows < 3) {
		*(vowels + nvows++) = c;
	    }
	}
	
	i++;
    }

    /* copy proper consonants */
    if (ncons == 4){
	*(output + 0) = *(consonants + 0); /* first */
	memcpy(output + 1, consonants + 2, 2); /* third and fourth */
	ncons = 3;			       /* for what follows ncons
						  need to be the inserted
						  consonants  */
    } else {
	memcpy(output, consonants, ncons);
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

static char * extract_year(const int year, char * output){
    sprintf(output, "%02d", year % 100);
    return output;
}

static char * extract_month(const int month, char * output){

    static const char months[] = {
	'A',			/* jan */
	'B',			/* feb */
	'C',			/* mar */
	'D',			/* apr */
	'E',			/* may */
	'H',			/* jul */
	'L',			/* jul */
	'M',			/* aug */
	'P',			/* sep */
	'R',			/* oct */
	'S',			/* nov */
	'T'			/* dec */
    };

    output[0] = months[month - 1];
    return output;

}


char * extract_day(const int day, const int female, char * output){
    sprintf(output, "%02d", day + 40 * (female != 0));
    return output;
}
