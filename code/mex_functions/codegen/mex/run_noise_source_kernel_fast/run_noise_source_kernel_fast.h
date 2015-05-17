/*
 * run_noise_source_kernel_fast.h
 *
 * Code generation for function 'run_noise_source_kernel_fast'
 *
 */

#ifndef __RUN_NOISE_SOURCE_KERNEL_FAST_H__
#define __RUN_NOISE_SOURCE_KERNEL_FAST_H__

/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blas.h"
#include "rtwtypes.h"
#include "run_noise_source_kernel_fast_types.h"

/* Function Declarations */
extern void run_noise_source_kernel_fast(c_run_noise_source_kernel_fastS *SD,
  const emlrtStack *sp, const emxArray_creal_T *G_2, const emxArray_real_T *stf,
  const emxArray_real_T *adsrc, real_T X[90000], real_T Z[90000], real_T K_s
  [3420000]);

#endif

/* End of code generation (run_noise_source_kernel_fast.h) */
