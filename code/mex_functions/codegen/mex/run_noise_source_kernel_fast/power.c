/*
 * power.c
 *
 * Code generation for function 'power'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_noise_source_kernel_fast.h"
#include "power.h"

/* Function Definitions */
void power(const real_T a[90000], real_T y[90000])
{
  int32_T k;
  for (k = 0; k < 90000; k++) {
    y[k] = a[k] * a[k];
  }
}

/* End of code generation (power.c) */
