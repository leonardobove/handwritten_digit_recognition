//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// runQuantizedNet_internal_types.h
//
// Code generation for function 'runQuantizedNet'
//

#ifndef RUNQUANTIZEDNET_INTERNAL_TYPES_H
#define RUNQUANTIZEDNET_INTERNAL_TYPES_H

// Include files
#include "rtwtypes.h"
#include "runQuantizedNet_types.h"
#include "MWArmneonTargetNetworkImpl.hpp"
#include "MWCNNLayer.hpp"
#include "MWTensorBase.hpp"

// Type Definitions
class my_net0_0 {
public:
  my_net0_0();
  void setSize();
  void resetState();
  void setup();
  void activations(int layerIdx);
  void cleanup();
  float *getLayerOutput(int layerIndex, int portIndex);
  int getLayerOutputSize(int layerIndex, int portIndex);
  float *getInputDataPointer(int b_index);
  float *getInputDataPointer();
  float *getOutputDataPointer(int b_index);
  float *getOutputDataPointer();
  int getBatchSize();
  int getOutputSequenceLength(int layerIndex, int portIndex);
  ~my_net0_0();

private:
  void allocate();
  void postsetup();
  void deallocate();

public:
  bool isInitialized;
  bool matlabCodegenIsDeleted;

private:
  int numLayers;
  MWTensorBase *inputTensors[1];
  MWTensorBase *outputTensors[1];
  MWCNNLayer *layers[10];
  MWArmneonTarget::MWTargetNetworkImpl *targetImpl;
};

#endif
// End of code generation (runQuantizedNet_internal_types.h)
