/*
 * exp.h
 *
 * Code generation for function 'exp'
 *
 */

#ifndef __EXP_H__
#define __EXP_H__

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
extern void b_exp(creal_T x[1799]);
extern void c_exp(real_T x[90000]);

#endif

/* End of code generation (exp.h) */
