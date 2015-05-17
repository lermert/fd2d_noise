/*
 * run_forward_source_fast_terminate.c
 *
 * Code generation for function 'run_forward_source_fast_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_forward_source_fast.h"
#include "run_forward_source_fast_terminate.h"

/* Function Definitions */
void run_forward_source_fast_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void run_forward_source_fast_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (run_forward_source_fast_terminate.c) */
