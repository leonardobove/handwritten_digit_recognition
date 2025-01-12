//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_runQuantizedNet_api.cpp
//
// Code generation for function 'runQuantizedNet'
//

// Include files
#include "_coder_runQuantizedNet_api.h"
#include "_coder_runQuantizedNet_mex.h"

// Variable Definitions
emlrtCTX emlrtRootTLSGlobal{nullptr};

emlrtContext emlrtContextGlobal{
    true,                                                 // bFirstTime
    false,                                                // bInitialized
    131643U,                                              // fVersionInfo
    nullptr,                                              // fErrorFunction
    "runQuantizedNet",                                    // fFunctionName
    nullptr,                                              // fRTCallStack
    false,                                                // bDebugMode
    {2045744189U, 2170104910U, 2743257031U, 4284093946U}, // fSigWrd
    nullptr                                               // fSigMem
};

// Function Declarations
static real32_T (*b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                                     const emlrtMsgIdentifier *msgId))[196];

static real32_T (*emlrt_marshallIn(const emlrtStack &sp,
                                   const mxArray *b_nullptr,
                                   const char_T *identifier))[196];

static real32_T (*emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[196];

static const mxArray *emlrt_marshallOut(const real32_T u[10]);

// Function Definitions
static real32_T (*b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                                     const emlrtMsgIdentifier *msgId))[196]
{
  static const int32_T dims{196};
  int32_T i;
  real32_T(*ret)[196];
  boolean_T b{false};
  emlrtCheckVsBuiltInR2012b((emlrtConstCTX)&sp, msgId, src, "single", false, 1U,
                            (const void *)&dims, &b, &i);
  ret = (real32_T(*)[196])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real32_T (*emlrt_marshallIn(const emlrtStack &sp,
                                   const mxArray *b_nullptr,
                                   const char_T *identifier))[196]
{
  emlrtMsgIdentifier thisId;
  real32_T(*y)[196];
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  y = emlrt_marshallIn(sp, emlrtAlias(b_nullptr), &thisId);
  emlrtDestroyArray(&b_nullptr);
  return y;
}

static real32_T (*emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[196]
{
  real32_T(*y)[196];
  y = b_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *emlrt_marshallOut(const real32_T u[10])
{
  static const int32_T i{0};
  static const int32_T i1{10};
  const mxArray *m;
  const mxArray *y;
  y = nullptr;
  m = emlrtCreateNumericArray(1, (const void *)&i, mxSINGLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &i1, 1);
  emlrtAssign(&y, m);
  return y;
}

void runQuantizedNet_api(const mxArray *prhs, const mxArray **plhs)
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  real32_T(*X)[196];
  real32_T(*Y)[10];
  st.tls = emlrtRootTLSGlobal;
  Y = (real32_T(*)[10])mxMalloc(sizeof(real32_T[10]));
  // Marshall function inputs
  X = emlrt_marshallIn(st, emlrtAlias(prhs), "X");
  // Invoke the target function
  runQuantizedNet(*X, *Y);
  // Marshall function outputs
  *plhs = emlrt_marshallOut(*Y);
}

void runQuantizedNet_atexit()
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  runQuantizedNet_xil_terminate();
  runQuantizedNet_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void runQuantizedNet_initialize()
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, nullptr);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

void runQuantizedNet_terminate()
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

// End of code generation (_coder_runQuantizedNet_api.cpp)
