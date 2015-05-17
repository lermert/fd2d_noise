/*
 * exp.c
 *
 * Code generation for function 'exp'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_forward_source_fast.h"
#include "exp.h"

/* Function Definitions */
void b_exp(creal_T x[1799])
{
  int32_T k;
  real_T x_re;
  real_T r;
  for (k = 0; k < 1799; k++) {
    if (muDoubleScalarIsInf(x[k].im) && muDoubleScalarIsInf(x[k].re) && (x[k].re
         < 0.0)) {
      x_re = 0.0;
      r = 0.0;
    } else {
      r = muDoubleScalarExp(x[k].re / 2.0);
      x_re = r * (r * muDoubleScalarCos(x[k].im));
      r *= r * muDoubleScalarSin(x[k].im);
    }

    x[k].re = x_re;
    x[k].im = r;
  }
}

void c_exp(real_T x[90000])
{
  int32_T k;
  for (k = 0; k < 90000; k++) {
    x[k] = muDoubleScalarExp(x[k]);
  }
}

/* End of code generation (exp.c) */
