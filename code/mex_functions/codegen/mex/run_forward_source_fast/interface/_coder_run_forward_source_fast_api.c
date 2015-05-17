/*
 * _coder_run_forward_source_fast_api.c
 *
 * Code generation for function '_coder_run_forward_source_fast_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "run_forward_source_fast.h"
#include "_coder_run_forward_source_fast_api.h"
#include "run_forward_source_fast_emxutil.h"

/* Variable Definitions */
static emlrtRTEInfo c_emlrtRTEI = { 1, 1, "_coder_run_forward_source_fast_api",
  "" };

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_creal_T *y);
static const mxArray *b_emlrt_marshallOut(const real_T u[1799]);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *x, const
  char_T *identifier, emxArray_real_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *rec, const
  char_T *identifier, emxArray_real_T *y);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *G_2, const
  char_T *identifier, emxArray_creal_T *y);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);
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

static const mxArray *b_emlrt_marshallOut(const real_T u[1799])
{
  const mxArray *y;
  static const int32_T iv9[2] = { 0, 0 };

  const mxArray *m3;
  static const int32_T iv10[2] = { 1, 1799 };

  y = NULL;
  m3 = emlrtCreateNumericArray(2, iv9, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m3, (void *)u);
  emlrtSetDimensions((mxArray *)m3, iv10, 2);
  emlrtAssign(&y, m3);
  return y;
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *x, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  d_emlrt_marshallIn(sp, emlrtAlias(x), &thisId, y);
  emlrtDestroyArray(&x);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  h_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *rec, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  f_emlrt_marshallIn(sp, emlrtAlias(rec), &thisId, y);
  emlrtDestroyArray(&rec);
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

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  static const int32_T iv8[2] = { 0, 0 };

  const mxArray *m2;
  y = NULL;
  m2 = emlrtCreateNumericArray(2, iv8, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m2, (void *)u->data);
  emlrtSetDimensions((mxArray *)m2, u->size, 2);
  emlrtAssign(&y, m2);
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
  int32_T iv11[3];
  boolean_T bv0[3];
  int32_T i;
  int32_T iv12[3];
  for (i = 0; i < 3; i++) {
    iv11[i] = -1;
    bv0[i] = true;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", true, 3U, iv11, bv0, iv12);
  i = ret->size[0] * ret->size[1] * ret->size[2];
  ret->size[0] = iv12[0];
  ret->size[1] = iv12[1];
  ret->size[2] = iv12[2];
  emxEnsureCapacity(sp, (emxArray__common *)ret, i, (int32_T)sizeof(creal_T),
                    (emlrtRTEInfo *)NULL);
  emlrtImportArrayR2011b(src, ret->data, 8, true);
  emlrtDestroyArray(&src);
}

static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  int32_T iv13[2];
  boolean_T bv1[2];
  int32_T i;
  int32_T iv14[2];
  for (i = 0; i < 2; i++) {
    iv13[i] = -1;
    bv1[i] = true;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv13, bv1, iv14);
  ret->size[0] = iv14[0];
  ret->size[1] = iv14[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  int32_T iv15[2];
  boolean_T bv2[2];
  int32_T i4;
  int32_T iv16[2];
  for (i4 = 0; i4 < 2; i4++) {
    iv15[i4] = 3 * i4 - 1;
    bv2[i4] = true;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv15, bv2, iv16);
  ret->size[0] = iv16[0];
  ret->size[1] = iv16[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

void run_forward_source_fast_api(c_run_forward_source_fastStackD *SD, const
  mxArray * const prhs[3], const mxArray *plhs[2])
{
  real_T (*t)[1799];
  emxArray_creal_T *G_2;
  emxArray_real_T *x;
  emxArray_real_T *rec;
  emxArray_real_T *displacement_seismograms;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  t = (real_T (*)[1799])mxMalloc(sizeof(real_T [1799]));
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  b_emxInit_creal_T(&st, &G_2, 3, &c_emlrtRTEI, true);
  emxInit_real_T(&st, &x, 2, &c_emlrtRTEI, true);
  emxInit_real_T(&st, &rec, 2, &c_emlrtRTEI, true);
  emxInit_real_T(&st, &displacement_seismograms, 2, &c_emlrtRTEI, true);

  /* Marshall function inputs */
  emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "G_2", G_2);
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "x", x);
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "rec", rec);

  /* Invoke the target function */
  run_forward_source_fast(SD, &st, G_2, x, rec, displacement_seismograms, *t);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(displacement_seismograms);
  plhs[1] = b_emlrt_marshallOut(*t);
  displacement_seismograms->canFreeData = false;
  emxFree_real_T(&displacement_seismograms);
  rec->canFreeData = false;
  emxFree_real_T(&rec);
  x->canFreeData = false;
  emxFree_real_T(&x);
  emxFree_creal_T(&G_2);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_run_forward_source_fast_api.c) */
