#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP reg_guess_fc(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP reg_wrong_fc(SEXP);
extern SEXP tmp_wrong_fc(SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"reg_guess_fc", (DL_FUNC) &reg_guess_fc, 7},
    {"reg_wrong_fc", (DL_FUNC) &reg_wrong_fc, 1},
    {"tmp_wrong_fc", (DL_FUNC) &tmp_wrong_fc, 1},
    {NULL, NULL, 0}
};

void R_init_ifctools(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
