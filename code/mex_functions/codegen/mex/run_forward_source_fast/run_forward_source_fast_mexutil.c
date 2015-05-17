/*
 * run_forward_source_fast_mexutil.c
 *
 * Code generation for function 'run_forward_source_fast_mexutil'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_forward_source_fast.h"
#include "run_forward_source_fast_mexutil.h"

/* Function Definitions */
void error(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(sp, 0, NULL, 1, &pArray, "error", true, location);
}

/* End of code generation (run_forward_source_fast_mexutil.c) */
