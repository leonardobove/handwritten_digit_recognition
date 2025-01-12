//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// runQuantizedNet.cpp
//
// Code generation for function 'runQuantizedNet'
//

// Include files
#include "runQuantizedNet.h"
#include "dlnetwork.h"
#include "predict.h"
#include "runQuantizedNet_data.h"
#include "runQuantizedNet_initialize.h"
#include "runQuantizedNet_internal_types.h"

// Variable Definitions
static my_net0_0 qNet;

static bool qNet_not_empty;

// Function Definitions
void runQuantizedNet(const float X[196], float Y[10])
{
  if (!isInitialized_runQuantizedNet) {
    runQuantizedNet_initialize();
  }
  //  Example function to process input through the network.
  //  Used for code generation
  if (!qNet_not_empty) {
    coder::internal::dlnetwork_setup(qNet);
    qNet.matlabCodegenIsDeleted = false;
    qNet_not_empty = true;
  }
  //  Predict output using the quantized network
  coder::internal::dlnetwork_predict(qNet, X, Y);
}

void runQuantizedNet_delete()
{
  if (!qNet.matlabCodegenIsDeleted) {
    qNet.matlabCodegenIsDeleted = true;
    coder::internal::dlnetwork_delete(qNet);
  }
}

void runQuantizedNet_init()
{
  qNet_not_empty = false;
  qNet.matlabCodegenIsDeleted = true;
}

// End of code generation (runQuantizedNet.cpp)
