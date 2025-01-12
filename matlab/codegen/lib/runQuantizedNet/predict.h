//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// predict.h
//
// Code generation for function 'predict'
//

#ifndef PREDICT_H
#define PREDICT_H

// Include files
#include "rtwtypes.h"
#include <cstddef>
#include <cstdlib>

// Type Declarations
class my_net0_0;

// Function Declarations
namespace coder {
namespace internal {
void dlnetwork_predict(my_net0_0 &obj, const float varargin_1_Data[196],
                       float varargout_1_Data[10]);

}
} // namespace coder

#endif
// End of code generation (predict.h)
