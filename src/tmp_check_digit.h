#ifndef TMP_CHECK_DIGIT_H
#define TMP_CHECK_DIGIT_H

#include "ifctools.h"

int tmp_check_digit(const char * fc);
static int tmp_recode_even_digits(int code);
static int tmp_recode_odd_digits(int code);

#endif	/* TMP_CHECK_DIGIT_H */
