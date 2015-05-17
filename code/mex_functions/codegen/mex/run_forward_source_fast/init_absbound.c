/*
 * init_absbound.c
 *
 * Code generation for function 'init_absbound'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_forward_source_fast.h"
#include "init_absbound.h"
#include "exp.h"
#include "power.h"
#include "define_computational_domain.h"

/* Function Definitions */
void init_absbound(c_run_forward_source_fastStackD *SD, real_T absbound[90000])
{
  int32_T i1;
  int32_T i2;

  /*  get parameters */
  define_computational_domain(SD->f0.X, SD->f0.Z);

  /* - Initialisation of Cerjan-type absorbing boundary tapers ---------------- */
  /* -------------------------------------------------------------------------- */
  /* - left boundary */
  /* - right boundary */
  /* - bottom boundary */
  /* - top boundary */
  for (i1 = 0; i1 < 300; i1++) {
    for (i2 = 0; i2 < 300; i2++) {
      SD->f0.b_X[i2 + 300 * i1] = SD->f0.X[i1 + 300 * i2] - 30000.0;
    }
  }

  power(SD->f0.b_X, SD->f0.dv3);
  for (i1 = 0; i1 < 90000; i1++) {
    SD->f0.dv3[i1] = -SD->f0.dv3[i1] / 3.6E+9;
  }

  c_exp(SD->f0.dv3);
  for (i1 = 0; i1 < 300; i1++) {
    for (i2 = 0; i2 < 300; i2++) {
      SD->f0.b_X[i2 + 300 * i1] = SD->f0.X[i1 + 300 * i2] - 370000.0;
    }
  }

  power(SD->f0.b_X, SD->f0.dv4);
  for (i1 = 0; i1 < 90000; i1++) {
    SD->f0.dv4[i1] = -SD->f0.dv4[i1] / 3.6E+9;
  }

  c_exp(SD->f0.dv4);
  for (i1 = 0; i1 < 300; i1++) {
    for (i2 = 0; i2 < 300; i2++) {
      SD->f0.b_X[i2 + 300 * i1] = SD->f0.Z[i1 + 300 * i2] - 30000.0;
    }
  }

  power(SD->f0.b_X, SD->f0.dv5);
  for (i1 = 0; i1 < 90000; i1++) {
    SD->f0.dv5[i1] = -SD->f0.dv5[i1] / 3.6E+9;
  }

  c_exp(SD->f0.dv5);
  for (i1 = 0; i1 < 300; i1++) {
    for (i2 = 0; i2 < 300; i2++) {
      SD->f0.b_X[i2 + 300 * i1] = SD->f0.Z[i1 + 300 * i2] - 370000.0;
    }
  }

  power(SD->f0.b_X, SD->f0.dv6);
  for (i1 = 0; i1 < 90000; i1++) {
    SD->f0.dv6[i1] = -SD->f0.dv6[i1] / 3.6E+9;
  }

  c_exp(SD->f0.dv6);
  for (i1 = 0; i1 < 300; i1++) {
    for (i2 = 0; i2 < 300; i2++) {
      absbound[i2 + 300 * i1] = ((real_T)(SD->f0.X[i1 + 300 * i2] > 30000.0) +
        SD->f0.dv3[i2 + 300 * i1] * (real_T)(SD->f0.X[i1 + 300 * i2] <= 30000.0))
        * ((real_T)(SD->f0.X[i1 + 300 * i2] < 370000.0) + SD->f0.dv4[i2 + 300 *
           i1] * (real_T)(SD->f0.X[i1 + 300 * i2] >= 370000.0)) * ((real_T)
        (SD->f0.Z[i1 + 300 * i2] > 30000.0) + SD->f0.dv5[i2 + 300 * i1] *
        (real_T)(SD->f0.Z[i1 + 300 * i2] <= 30000.0)) * ((real_T)(SD->f0.Z[i1 +
        300 * i2] < 370000.0) + SD->f0.dv6[i2 + 300 * i1] * (real_T)(SD->f0.Z[i1
        + 300 * i2] >= 370000.0));
    }
  }
}

/* End of code generation (init_absbound.c) */
