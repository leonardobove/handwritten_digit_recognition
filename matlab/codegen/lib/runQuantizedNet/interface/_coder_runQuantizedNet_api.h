//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_runQuantizedNet_api.h
//
// Code generation for function 'runQuantizedNet'
//

#ifndef _CODER_RUNQUANTIZEDNET_API_H
#define _CODER_RUNQUANTIZEDNET_API_H

// Include files
#include "emlrt.h"
#include "mex.h"
#include "tmwtypes.h"
#include <algorithm>
#include <cstring>

// Variable Declarations
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

// Function Declarations
void runQuantizedNet(real32_T X[196], real32_T Y[10]);

void runQuantizedNet_api(const mxArray *prhs, const mxArray **plhs);

void runQuantizedNet_atexit();

void runQuantizedNet_initialize();

void runQuantizedNet_terminate();

void runQuantizedNet_xil_shutdown();

void runQuantizedNet_xil_terminate();

#endif
// End of code generation (_coder_runQuantizedNet_api.h)
