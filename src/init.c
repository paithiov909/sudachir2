
#include <stdint.h>
#include <Rinternals.h>
#include <R_ext/Parse.h>

#include "rust/api.h"

static uintptr_t TAGGED_POINTER_MASK = (uintptr_t)1;

SEXP handle_result(SEXP res_) {
    uintptr_t res = (uintptr_t)res_;

    // An error is indicated by tag.
    if ((res & TAGGED_POINTER_MASK) == 1) {
        // Remove tag
        SEXP res_aligned = (SEXP)(res & ~TAGGED_POINTER_MASK);

        // Currently, there are two types of error cases:
        //
        //   1. Error from Rust code
        //   2. Error from R's C API, which is caught by R_UnwindProtect()
        //
        if (TYPEOF(res_aligned) == CHARSXP) {
            // In case 1, the result is an error message that can be passed to
            // Rf_errorcall() directly.
            Rf_errorcall(R_NilValue, "%s", CHAR(res_aligned));
        } else {
            // In case 2, the result is the token to restart the
            // cleanup process on R's side.
            R_ContinueUnwind(res_aligned);
        }
    }

    return (SEXP)res;
}

SEXP savvy_tagger_inner__impl(SEXP c_arg__x, SEXP c_arg__mode, SEXP c_arg__config_file, SEXP c_arg__resource_dir, SEXP c_arg__dictionary_path) {
    SEXP res = savvy_tagger_inner__ffi(c_arg__x, c_arg__mode, c_arg__config_file, c_arg__resource_dir, c_arg__dictionary_path);
    return handle_result(res);
}


static const R_CallMethodDef CallEntries[] = {
    {"savvy_tagger_inner__impl", (DL_FUNC) &savvy_tagger_inner__impl, 5},
    {NULL, NULL, 0}
};

void R_init_sudachir2(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);

    // Functions for initialzation, if any.

}
