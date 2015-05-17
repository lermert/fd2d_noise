/*
 * _coder_run_forward_source_fast_mex.c
 *
 * Code generation for function 'run_forward_source_fast'
 *
 */

/* Include files */
#include "mex.h"
#include "_coder_run_forward_source_fast_api.h"
#include "run_forward_source_fast_initialize.h"
#include "run_forward_source_fast_terminate.h"

/* Function Declarations */
static void run_forward_source_fast_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

/* Variable Definitions */
emlrtContext emlrtContextGlobal = { true, false, EMLRT_VERSION_INFO, NULL, "run_forward_source_fast", NULL, false, {2045744189U,2170104910U,2743257031U,4284093946U}, NULL };
void *emlrtRootTLSGlobal = NULL;

/* Function Definitions */
static void run_forward_source_fast_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  const mxArray *outputs[2];
  const mxArray *inputs[3];
  int n = 0;
  int nOutputs = (nlhs < 1 ? 1 : nlhs);
  int nInputs = nrhs;
  emlrtStack st = { NULL, NULL, NULL };
  c_run_forward_source_fastStackD* d_run_forward_source_fastStackD = (c_run_forward_source_fastStackD*)mxCalloc(1,sizeof(c_run_forward_source_fastStackD));
  /* Module initialization. */
  run_forward_source_fast_initialize(&emlrtContextGlobal);
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, mxINT32_CLASS, 3, mxCHAR_CLASS, 23, "run_forward_source_fast");
  } else if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, mxCHAR_CLASS, 23, "run_forward_source_fast");
  }
  /* Temporary copy for mex inputs. */
  for (n = 0; n < nInputs; ++n) {
    inputs[n] = prhs[n];
  }
  /* Call the function. */
  run_forward_source_fast_api(d_run_forward_source_fastStackD, inputs, outputs);
  /* Copy over outputs to the caller. */
  for (n = 0; n < nOutputs; ++n) {
    plhs[n] = emlrtReturnArrayR2009a(outputs[n]);
  }
  /* Module finalization. */
  run_forward_source_fast_terminate();
  mxFree(d_run_forward_source_fastStackD);
}

void run_forward_source_fast_atexit_wrapper(void)
{
   run_forward_source_fast_atexit();
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(run_forward_source_fast_atexit_wrapper);
  /* Dispatch the entry-point. */
  run_forward_source_fast_mexFunction(nlhs, plhs, nrhs, prhs);
}
/* End of code generation (_coder_run_forward_source_fast_mex.c) */
