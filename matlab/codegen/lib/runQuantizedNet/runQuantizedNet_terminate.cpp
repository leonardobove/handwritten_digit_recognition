//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// runQuantizedNet_terminate.cpp
//
// Code generation for function 'runQuantizedNet_terminate'
//

// Include files
#include "runQuantizedNet_terminate.h"
#include "runQuantizedNet.h"
#include "runQuantizedNet_data.h"

// Function Definitions
void runQuantizedNet_terminate()
{
  runQuantizedNet_delete();
  isInitialized_runQuantizedNet = false;
}

// End of code generation (runQuantizedNet_terminate.cpp)
