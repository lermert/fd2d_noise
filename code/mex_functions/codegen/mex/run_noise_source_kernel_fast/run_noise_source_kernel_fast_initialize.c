/*
 * run_noise_source_kernel_fast_initialize.c
 *
 * Code generation for function 'run_noise_source_kernel_fast_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_noise_source_kernel_fast.h"
#include "run_noise_source_kernel_fast_initialize.h"
#include "run_noise_source_kernel_fast_data.h"

/* Function Definitions */
void run_noise_source_kernel_fast_initialize(emlrtContext *aContext)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, aContext, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (run_noise_source_kernel_fast_initialize.c) */
