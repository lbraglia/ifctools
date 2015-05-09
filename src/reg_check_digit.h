#ifndef REG_CHECK_DIGIT_H
#define REG_CHECK_DIGIT_H

#include "ifctools.h"

#define EVEN(x) ( ((x) % 2) == 0)

char reg_check_digit(const char * fc);
static int reg_recode_even_digits(char code);
static int reg_recode_odd_digits(char code);
static char reg_recode_remainder(int rem);

#endif	/* REG_CHECK_DIGIT_H */
