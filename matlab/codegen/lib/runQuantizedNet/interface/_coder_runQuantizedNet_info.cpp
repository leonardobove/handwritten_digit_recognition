//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_runQuantizedNet_info.cpp
//
// Code generation for function 'runQuantizedNet'
//

// Include files
#include "_coder_runQuantizedNet_info.h"
#include "emlrt.h"
#include "tmwtypes.h"

// Function Declarations
static const mxArray *emlrtMexFcnResolvedFunctionsInfo();

// Function Definitions
static const mxArray *emlrtMexFcnResolvedFunctionsInfo()
{
  const mxArray *nameCaptureInfo;
  const char_T *data[4]{
      "789ce553cd4ec24018dc1a34c604e5643cf9081e397804829a88c196c6836b60693fe886"
      "ee6ed3aed0fa12be8aefe3cb68e90f65934d898978702ed3c974bf99"
      "fdd222e36e6020844e51868ba38c9bb96ee57c80b6a1fa86860b1ca2c6d6b9c27fcfd911"
      "5c422c33c10983f2a42b18e584cb5112000a2112fe12dcb533a33e8c",
      "2803ab2a1e52c5fa15ab14a9953e773d7016d62b43a1176d1afa5551ee63a2b96fa3661f"
      "2ad47da8effd97bc8f1fe615f3ef6bf20affd97ee95e633b8230c23e"
      "084e700fa28514011e5a3dec11eeae422a25f0b14be7548e4370c49c534905c78c489f4c"
      "314b38c8ab6f51ed3fd1f43bdbb1bfeeff68a2e33577e0d3d867dec9",
      "258ef79957e0aff262cdbc5dbfbf734d5e4bf16fcd763cb55dd39c05cbe4a9df69bfad1e"
      "07379b1ec39a9cba1e48a37f7bfe17c92e56b2",
      ""};
  nameCaptureInfo = nullptr;
  emlrtNameCaptureMxArrayR2016a(&data[0], 1584U, &nameCaptureInfo);
  return nameCaptureInfo;
}

mxArray *emlrtMexFcnProperties()
{
  mxArray *xEntryPoints;
  mxArray *xInputs;
  mxArray *xResult;
  const char_T *propFieldName[9]{"Version",
                                 "ResolvedFunctions",
                                 "Checksum",
                                 "EntryPoints",
                                 "CoverageInfo",
                                 "IsPolymorphic",
                                 "PropertyList",
                                 "UUID",
                                 "ClassEntryPointIsHandle"};
  const char_T *epFieldName[8]{
      "Name",     "NumberOfInputs", "NumberOfOutputs", "ConstantInputs",
      "FullPath", "TimeStamp",      "Constructor",     "Visible"};
  xEntryPoints =
      emlrtCreateStructMatrix(1, 1, 8, (const char_T **)&epFieldName[0]);
  xInputs = emlrtCreateLogicalMatrix(1, 1);
  emlrtSetField(xEntryPoints, 0, "Name",
                emlrtMxCreateString("runQuantizedNet"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs",
                emlrtMxCreateDoubleScalar(1.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs",
                emlrtMxCreateDoubleScalar(1.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  emlrtSetField(
      xEntryPoints, 0, "FullPath",
      emlrtMxCreateString("C:\\Users\\leona\\Desktop\\PSD\\handwritten_digit_"
                          "recognition\\matlab\\runQuantizedNet.m"));
  emlrtSetField(xEntryPoints, 0, "TimeStamp",
                emlrtMxCreateDoubleScalar(739630.01056712959));
  emlrtSetField(xEntryPoints, 0, "Constructor",
                emlrtMxCreateLogicalScalar(false));
  emlrtSetField(xEntryPoints, 0, "Visible", emlrtMxCreateLogicalScalar(true));
  xResult =
      emlrtCreateStructMatrix(1, 1, 9, (const char_T **)&propFieldName[0]);
  emlrtSetField(xResult, 0, "Version",
                emlrtMxCreateString("23.2.0.2485118 (R2023b) Update 6"));
  emlrtSetField(xResult, 0, "ResolvedFunctions",
                (mxArray *)emlrtMexFcnResolvedFunctionsInfo());
  emlrtSetField(xResult, 0, "Checksum",
                emlrtMxCreateString("HR6xbUdRRfpvyWFB6zwQMG"));
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  return xResult;
}

// End of code generation (_coder_runQuantizedNet_info.cpp)
