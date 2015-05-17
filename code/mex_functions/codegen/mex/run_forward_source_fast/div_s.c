/*
 * div_s.c
 *
 * Code generation for function 'div_s'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_forward_source_fast.h"
#include "div_s.h"
#include "run_forward_source_fast_data.h"

/* Function Definitions */
void div_s(const emlrtStack *sp, const real_T sxy[89700], const real_T szy[89700],
           real_T out[90000])
{
  int32_T i;
  int32_T i3;

  /* ========================================================================== */
  /*  compute the divergence of the stress tensor */
  /*  */
  /*  input: */
  /* ------- */
  /*  sxy, szy: stress tensor components */
  /*  dx, dz: grid spacings in x- and z-directions */
  /*  nx, nz: number of grid points in x- and z-directions */
  /*  order: finite-difference order (2 or 4) */
  /*  */
  /*  output: */
  /* -------- */
  /*  stress tensor divergence */
  /* ========================================================================== */
  memset(&out[0], 0, 90000U * sizeof(real_T));
  for (i = 0; i < 296; i++) {
    for (i3 = 0; i3 < 300; i3++) {
      out[(i + 300 * i3) + 2] = 9.0 * (sxy[(i + 299 * i3) + 2] - sxy[(i + 299 *
        i3) + 1]) / 10702.341137123745 - (sxy[(i + 299 * i3) + 3] - sxy[i + 299 *
        i3]) / 32107.023411371236;
    }

    emlrtBreakCheckFastR2012b(emlrtBreakCheckR2012bFlagVar, sp);
  }

  for (i = 0; i < 296; i++) {
    for (i3 = 0; i3 < 300; i3++) {
      out[i3 + 300 * (i + 2)] = (out[i3 + 300 * (i + 2)] + 9.0 * (szy[i3 + 300 *
                                  (i + 2)] - szy[i3 + 300 * (i + 1)]) /
        10702.341137123745) - (szy[i3 + 300 * (i + 3)] - szy[i3 + 300 * i]) /
        32107.023411371236;
    }

    emlrtBreakCheckFastR2012b(emlrtBreakCheckR2012bFlagVar, sp);
  }
}

/* End of code generation (div_s.c) */
