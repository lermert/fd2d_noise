/*
 * run_forward_source_fast_types.h
 *
 * Code generation for function 'run_forward_source_fast'
 *
 */

#ifndef __RUN_FORWARD_SOURCE_FAST_TYPES_H__
#define __RUN_FORWARD_SOURCE_FAST_TYPES_H__

/* Include files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_c_run_forward_source_fastStackD
#define typedef_c_run_forward_source_fastStackD
typedef struct
{
    struct
    {
        real_T Z[90000];
        real_T X[90000];
        real_T b_X[90000];
        real_T dv3[90000];
        real_T dv4[90000];
        real_T dv5[90000];
        real_T dv6[90000];
    } f0;
    struct
    {
        creal_T S[90000];
        creal_T ifft_coeff[68362];
        real_T noise_source_distribution[90000];
        real_T v[90000];
        real_T absbound[90000];
        real_T DS[90000];
        real_T sxy[89700];
        real_T szy[89700];
        real_T out[89700];
        real_T b_out[89700];
    } f1;
} c_run_forward_source_fastStackD;
#endif /*typedef_c_run_forward_source_fastStackD*/
#ifndef struct_emxArray__common
#define struct_emxArray__common
struct emxArray__common
{
    void *data;
    int32_T *size;
    int32_T allocatedSize;
    int32_T numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray__common*/
#ifndef typedef_emxArray__common
#define typedef_emxArray__common
typedef struct emxArray__common emxArray__common;
#endif /*typedef_emxArray__common*/
#ifndef struct_emxArray_creal_T
#define struct_emxArray_creal_T
struct emxArray_creal_T
{
    creal_T *data;
    int32_T *size;
    int32_T allocatedSize;
    int32_T numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray_creal_T*/
#ifndef typedef_emxArray_creal_T
#define typedef_emxArray_creal_T
typedef struct emxArray_creal_T emxArray_creal_T;
#endif /*typedef_emxArray_creal_T*/
#ifndef struct_emxArray_int32_T
#define struct_emxArray_int32_T
struct emxArray_int32_T
{
    int32_T *data;
    int32_T *size;
    int32_T allocatedSize;
    int32_T numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray_int32_T*/
#ifndef typedef_emxArray_int32_T
#define typedef_emxArray_int32_T
typedef struct emxArray_int32_T emxArray_int32_T;
#endif /*typedef_emxArray_int32_T*/
#ifndef struct_emxArray_int32_T_1x300
#define struct_emxArray_int32_T_1x300
struct emxArray_int32_T_1x300
{
    int32_T data[300];
    int32_T size[2];
};
#endif /*struct_emxArray_int32_T_1x300*/
#ifndef typedef_emxArray_int32_T_1x300
#define typedef_emxArray_int32_T_1x300
typedef struct emxArray_int32_T_1x300 emxArray_int32_T_1x300;
#endif /*typedef_emxArray_int32_T_1x300*/
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T
struct emxArray_real_T
{
    real_T *data;
    int32_T *size;
    int32_T allocatedSize;
    int32_T numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray_real_T*/
#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T
typedef struct emxArray_real_T emxArray_real_T;
#endif /*typedef_emxArray_real_T*/

#endif
/* End of code generation (run_forward_source_fast_types.h) */
