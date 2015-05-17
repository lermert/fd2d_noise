/*
 * exp.c
 *
 * Code generation for function 'exp'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_noise_source_kernel_fast.h"
#include "exp.h"

/* Function Definitions */
void b_exp(real_T x[90000])
{
  int32_T k;
  for (k = 0; k < 90000; k++) {
    x[k] = muDoubleScalarExp(x[k]);
  }
}

/* End of code generation (exp.c) */
