/*
 * abs.c
 *
 * Code generation for function 'abs'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_forward_source_fast.h"
#include "abs.h"

/* Function Definitions */
void b_abs(const real_T x[300], real_T y[300])
{
  int32_T k;
  for (k = 0; k < 300; k++) {
    y[k] = muDoubleScalarAbs(x[k]);
  }
}

/* End of code generation (abs.c) */
