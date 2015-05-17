/*
 * run_forward_source_fast.h
 *
 * Code generation for function 'run_forward_source_fast'
 *
 */

#ifndef __RUN_FORWARD_SOURCE_FAST_H__
#define __RUN_FORWARD_SOURCE_FAST_H__

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
#include "run_forward_source_fast_types.h"

/* Function Declarations */
extern void run_forward_source_fast(c_run_forward_source_fastStackD *SD, const
  emlrtStack *sp, emxArray_creal_T *G_2, const emxArray_real_T *x, const
  emxArray_real_T *rec, emxArray_real_T *displacement_seismograms, real_T t[1799]);

#endif

/* End of code generation (run_forward_source_fast.h) */
