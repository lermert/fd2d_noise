/*
 * init_absbound.c
 *
 * Code generation for function 'init_absbound'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_noise_source_kernel_fast.h"
#include "init_absbound.h"
#include "exp.h"
#include "power.h"
#include "define_computational_domain.h"

/* Function Definitions */
void init_absbound(c_run_noise_source_kernel_fastS *SD, real_T absbound[90000])
{
  int32_T i4;
  int32_T i5;

  /*  get parameters */
  define_computational_domain(SD->f0.X, SD->f0.Z);

  /* - Initialisation of Cerjan-type absorbing boundary tapers ---------------- */
  /* -------------------------------------------------------------------------- */
  /* - left boundary */
  /* - right boundary */
  /* - bottom boundary */
  /* - top boundary */
  for (i4 = 0; i4 < 300; i4++) {
    for (i5 = 0; i5 < 300; i5++) {
      SD->f0.b_X[i5 + 300 * i4] = SD->f0.X[i4 + 300 * i5] - 30000.0;
    }
  }

  power(SD->f0.b_X, SD->f0.dv2);
  for (i4 = 0; i4 < 90000; i4++) {
    SD->f0.dv2[i4] = -SD->f0.dv2[i4] / 3.6E+9;
  }

  b_exp(SD->f0.dv2);
  for (i4 = 0; i4 < 300; i4++) {
    for (i5 = 0; i5 < 300; i5++) {
      SD->f0.b_X[i5 + 300 * i4] = SD->f0.X[i4 + 300 * i5] - 370000.0;
    }
  }

  power(SD->f0.b_X, SD->f0.dv3);
  for (i4 = 0; i4 < 90000; i4++) {
    SD->f0.dv3[i4] = -SD->f0.dv3[i4] / 3.6E+9;
  }

  b_exp(SD->f0.dv3);
  for (i4 = 0; i4 < 300; i4++) {
    for (i5 = 0; i5 < 300; i5++) {
      SD->f0.b_X[i5 + 300 * i4] = SD->f0.Z[i4 + 300 * i5] - 30000.0;
    }
  }

  power(SD->f0.b_X, SD->f0.dv4);
  for (i4 = 0; i4 < 90000; i4++) {
    SD->f0.dv4[i4] = -SD->f0.dv4[i4] / 3.6E+9;
  }

  b_exp(SD->f0.dv4);
  for (i4 = 0; i4 < 300; i4++) {
    for (i5 = 0; i5 < 300; i5++) {
      SD->f0.b_X[i5 + 300 * i4] = SD->f0.Z[i4 + 300 * i5] - 370000.0;
    }
  }

  power(SD->f0.b_X, SD->f0.dv5);
  for (i4 = 0; i4 < 90000; i4++) {
    SD->f0.dv5[i4] = -SD->f0.dv5[i4] / 3.6E+9;
  }

  b_exp(SD->f0.dv5);
  for (i4 = 0; i4 < 300; i4++) {
    for (i5 = 0; i5 < 300; i5++) {
      absbound[i5 + 300 * i4] = ((real_T)(SD->f0.X[i4 + 300 * i5] > 30000.0) +
        SD->f0.dv2[i5 + 300 * i4] * (real_T)(SD->f0.X[i4 + 300 * i5] <= 30000.0))
        * ((real_T)(SD->f0.X[i4 + 300 * i5] < 370000.0) + SD->f0.dv3[i5 + 300 *
           i4] * (real_T)(SD->f0.X[i4 + 300 * i5] >= 370000.0)) * ((real_T)
        (SD->f0.Z[i4 + 300 * i5] > 30000.0) + SD->f0.dv4[i5 + 300 * i4] *
        (real_T)(SD->f0.Z[i4 + 300 * i5] <= 30000.0)) * ((real_T)(SD->f0.Z[i4 +
        300 * i5] < 370000.0) + SD->f0.dv5[i5 + 300 * i4] * (real_T)(SD->f0.Z[i4
        + 300 * i5] >= 370000.0));
    }
  }
}

/* End of code generation (init_absbound.c) */
