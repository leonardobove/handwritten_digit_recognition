//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// predict.cpp
//
// Code generation for function 'predict'
//

// Include files
#include "predict.h"
#include "dlnetwork.h"
#include "runQuantizedNet_internal_types.h"
#include <cstring>

// Function Definitions
namespace coder {
namespace internal {
void dlnetwork_predict(my_net0_0 &obj, const float varargin_1_Data[196],
                       float varargout_1_Data[10])
{
  memcpy(obj.getInputDataPointer(0), varargin_1_Data,
         obj.getLayerOutputSize(0, 0));
  obj.activations(9);
  memcpy(varargout_1_Data, obj.getLayerOutput(9, 0),
         obj.getLayerOutputSize(9, 0));
}

} // namespace internal
} // namespace coder

// End of code generation (predict.cpp)
