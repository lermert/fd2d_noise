/*
 * _coder_run_noise_source_kernel_fast_api.c
 *
 * Code generation for function '_coder_run_noise_source_kernel_fast_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_noise_source_kernel_fast.h"
#include "_coder_run_noise_source_kernel_fast_api.h"
#include "run_noise_source_kernel_fast_emxutil.h"

/* Variable Definitions */
static emlrtRTEInfo c_emlrtRTEI = { 1, 1,
  "_coder_run_noise_source_kernel_fast_api", "" };

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_creal_T *y);
static const mxArray *b_emlrt_marshallOut(const real_T u[3420000]);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *stf, const
  char_T *identifier, emxArray_real_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *adsrc, const
  char_T *identifier, emxArray_real_T *y);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *G_2, const
  char_T *identifier, emxArray_creal_T *y);
static const mxArray *emlrt_marshallOut(const real_T u[90000]);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_creal_T *ret);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_creal_T *y)
{
  g_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *b_emlrt_marshallOut(const real_T u[3420000])
{
  const mxArray *y;
  static const int32_T iv7[3] = { 0, 0, 0 };

  const mxArray *m2;
  static const int32_T iv8[3] = { 300, 300, 38 };

  y = NULL;
  m2 = emlrtCreateNumericArray(3, iv7, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m2, (void *)u);
  emlrtSetDimensions((mxArray *)m2, iv8, 3);
  emlrtAssign(&y, m2);
  return y;
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *stf, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  d_emlrt_marshallIn(sp, emlrtAlias(stf), &thisId, y);
  emlrtDestroyArray(&stf);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  h_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *adsrc, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  f_emlrt_marshallIn(sp, emlrtAlias(adsrc), &thisId, y);
  emlrtDestroyArray(&adsrc);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *G_2, const
  char_T *identifier, emxArray_creal_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  b_emlrt_marshallIn(sp, emlrtAlias(G_2), &thisId, y);
  emlrtDestroyArray(&G_2);
}

static const mxArray *emlrt_marshallOut(const real_T u[90000])
{
  const mxArray *y;
  static const int32_T iv5[2] = { 0, 0 };

  const mxArray *m1;
  static const int32_T iv6[2] = { 300, 300 };

  y = NULL;
  m1 = emlrtCreateNumericArray(2, iv5, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m1, (void *)u);
  emlrtSetDimensions((mxArray *)m1, iv6, 2);
  emlrtAssign(&y, m1);
  return y;
}

static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  i_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_creal_T *ret)
{
  int32_T iv9[3];
  boolean_T bv0[3];
  int32_T i;
  int32_T iv10[3];
  for (i = 0; i < 3; i++) {
    iv9[i] = -1;
    bv0[i] = true;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", true, 3U, iv9, bv0, iv10);
  i = ret->size[0] * ret->size[1] * ret->size[2];
  ret->size[0] = iv10[0];
  ret->size[1] = iv10[1];
  ret->size[2] = iv10[2];
  emxEnsureCapacity(sp, (emxArray__common *)ret, i, (int32_T)sizeof(creal_T),
                    (emlrtRTEInfo *)NULL);
  emlrtImportArrayR2011b(src, ret->data, 8, true);
  emlrtDestroyArray(&src);
}

static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  int32_T iv11[2];
  boolean_T bv1[2];
  int32_T i;
  int32_T iv12[2];
  for (i = 0; i < 2; i++) {
    iv11[i] = -1;
    bv1[i] = true;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv11, bv1, iv12);
  ret->size[0] = iv12[0];
  ret->size[1] = iv12[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  int32_T iv13[2];
  boolean_T bv2[2];
  int32_T i6;
  int32_T iv14[2];
  for (i6 = 0; i6 < 2; i6++) {
    iv13[i6] = 3 * i6 - 1;
    bv2[i6] = true;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv13, bv2, iv14);
  ret->size[0] = iv14[0];
  ret->size[1] = iv14[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

void run_noise_source_kernel_fast_api(c_run_noise_source_kernel_fastS *SD, const
  mxArray * const prhs[3], const mxArray *plhs[3])
{
  real_T (*X)[90000];
  real_T (*Z)[90000];
  real_T (*K_s)[3420000];
  emxArray_creal_T *G_2;
  emxArray_real_T *stf;
  emxArray_real_T *adsrc;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  X = (real_T (*)[90000])mxMalloc(sizeof(real_T [90000]));
  Z = (real_T (*)[90000])mxMalloc(sizeof(real_T [90000]));
  K_s = (real_T (*)[3420000])mxMalloc(sizeof(real_T [3420000]));
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  b_emxInit_creal_T(&st, &G_2, 3, &c_emlrtRTEI, true);
  emxInit_real_T(&st, &stf, 2, &c_emlrtRTEI, true);
  emxInit_real_T(&st, &adsrc, 2, &c_emlrtRTEI, true);

  /* Marshall function inputs */
  emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "G_2", G_2);
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "stf", stf);
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "adsrc", adsrc);

  /* Invoke the target function */
  run_noise_source_kernel_fast(SD, &st, G_2, stf, adsrc, *X, *Z, *K_s);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*X);
  plhs[1] = emlrt_marshallOut(*Z);
  plhs[2] = b_emlrt_marshallOut(*K_s);
  adsrc->canFreeData = false;
  emxFree_real_T(&adsrc);
  stf->canFreeData = false;
  emxFree_real_T(&stf);
  emxFree_creal_T(&G_2);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_run_noise_source_kernel_fast_api.c) */
