//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// dlnetwork.cpp
//
// Code generation for function 'dlnetwork'
//

// Include files
#include "dlnetwork.h"
#include "runQuantizedNet_internal_types.h"
#include "MWArmneonLayerImplFactory.hpp"
#include "MWArmneonTargetNetworkImpl.hpp"
#include "MWBfpRescaleLayer.hpp"
#include "MWBfpScaleLayer.hpp"
#include "MWCNNLayer.hpp"
#include "MWInputLayer.hpp"
#include "MWInt8FCLayer.hpp"
#include "MWOutputLayer.hpp"
#include "MWSigmoidLayer.hpp"
#include "MWTensor.hpp"
#include "MWTensorBase.hpp"
#include "stdio.h"
#include <cstdlib>

// Named Constants
const char *errStringBase{
    "Error during execution of the generated code. %s at line: %d, file: "
    "%s\nExiting program execution ...\n"};

// Function Declarations
static void checkRunTimeError(const char *errMsg, const char *file,
                              unsigned int b_line);

// Function Definitions
void my_net0_0::allocate()
{
  targetImpl->allocate(2, layers, numLayers, 0);
  for (int idx{0}; idx < 10; idx++) {
    layers[idx]->allocate();
  }
  (static_cast<MWTensor<float> *>(inputTensors[0]))
      ->setData(layers[0]->getLayerOutput(0));
}

void my_net0_0::cleanup()
{
  deallocate();
  for (int idx{0}; idx < 10; idx++) {
    layers[idx]->cleanup();
  }
  if (targetImpl) {
    targetImpl->cleanup();
  }
  isInitialized = false;
}

void my_net0_0::deallocate()
{
  targetImpl->deallocate();
  for (int idx{0}; idx < 10; idx++) {
    layers[idx]->deallocate();
  }
}

void my_net0_0::postsetup()
{
  targetImpl->postSetup();
}

void my_net0_0::resetState()
{
}

void my_net0_0::setSize()
{
  for (int idx{0}; idx < 10; idx++) {
    layers[idx]->propagateSize();
  }
  allocate();
  postsetup();
}

void my_net0_0::setup()
{
  if (isInitialized) {
    resetState();
  } else {
    targetImpl->preSetup();
    (static_cast<MWInputLayer *>(layers[0]))
        ->createInputLayer(targetImpl, inputTensors[0], "CU", 0);
    (static_cast<MWBfpScaleLayer *>(layers[1]))
        ->createBfpScaleLayer(targetImpl, layers[0]->getOutputTensor(0), -6,
                              true, "CU", -1);
    (static_cast<
         MWInt8FCLayer<signed char, signed char, MWArmneonLayerImplFactory> *>(
         layers[2]))
        ->createInt8FCLayer(
            targetImpl, layers[1]->getOutputTensor(0), 196, 30,
            "./codegen/lib/runQuantizedNet/cnn_my_net0_0_fc_1_w.bin",
            "./codegen/lib/runQuantizedNet/cnn_my_net0_0_fc_1_b.bin", "INT8",
            -3, -7, "CB", -1);
    (static_cast<MWBfpRescaleLayer *>(layers[3]))
        ->createBfpRescaleLayer(targetImpl, layers[2]->getOutputTensor(0), -3,
                                "CB", 1);
    (static_cast<MWSigmoidLayer *>(layers[4]))
        ->createSigmoidLayer(targetImpl, layers[3]->getOutputTensor(0), "CB",
                             -1);
    (static_cast<MWBfpScaleLayer *>(layers[5]))
        ->createBfpScaleLayer(targetImpl, layers[4]->getOutputTensor(0), -7,
                              true, "CB", -1);
    (static_cast<
         MWInt8FCLayer<signed char, signed char, MWArmneonLayerImplFactory> *>(
         layers[6]))
        ->createInt8FCLayer(
            targetImpl, layers[5]->getOutputTensor(0), 30, 10,
            "./codegen/lib/runQuantizedNet/cnn_my_net0_0_fc_2_w.bin",
            "./codegen/lib/runQuantizedNet/cnn_my_net0_0_fc_2_b.bin", "INT8",
            -3, -6, "CB", -1);
    (static_cast<MWBfpRescaleLayer *>(layers[7]))
        ->createBfpRescaleLayer(targetImpl, layers[6]->getOutputTensor(0), -3,
                                "CB", 0);
    (static_cast<MWSigmoidLayer *>(layers[8]))
        ->createSigmoidLayer(targetImpl, layers[7]->getOutputTensor(0), "CB",
                             -1);
    (static_cast<MWOutputLayer *>(layers[9]))
        ->createOutputLayer(targetImpl, layers[8]->getOutputTensor(0), "CB",
                            -1);
    outputTensors[0] = layers[9]->getOutputTensor(0);
    setSize();
  }
  isInitialized = true;
}

static void checkRunTimeError(const char *errMsg, const char *file,
                              unsigned int b_line)
{
  printf(errStringBase, errMsg, b_line, file);
  exit(EXIT_FAILURE);
}

void my_net0_0::activations(int layerIdx)
{
  for (int idx{0}; idx <= layerIdx; idx++) {
    layers[idx]->predict();
  }
}

int my_net0_0::getBatchSize()
{
  return inputTensors[0]->getBatchSize();
}

float *my_net0_0::getInputDataPointer(int b_index)
{
  return (static_cast<MWTensor<float> *>(inputTensors[b_index]))->getData();
}

float *my_net0_0::getInputDataPointer()
{
  return (static_cast<MWTensor<float> *>(inputTensors[0]))->getData();
}

float *my_net0_0::getLayerOutput(int layerIndex, int portIndex)
{
  return targetImpl->getLayerOutput(layers, layerIndex, portIndex);
}

int my_net0_0::getLayerOutputSize(int layerIndex, int portIndex)
{
  return static_cast<unsigned int>(
             layers[layerIndex]->getOutputTensor(portIndex)->getNumElements()) *
         sizeof(float);
}

float *my_net0_0::getOutputDataPointer(int b_index)
{
  return (static_cast<MWTensor<float> *>(outputTensors[b_index]))->getData();
}

float *my_net0_0::getOutputDataPointer()
{
  return (static_cast<MWTensor<float> *>(outputTensors[0]))->getData();
}

int my_net0_0::getOutputSequenceLength(int layerIndex, int portIndex)
{
  return layers[layerIndex]->getOutputTensor(portIndex)->getSequenceLength();
}

my_net0_0::my_net0_0()
{
  numLayers = 10;
  isInitialized = false;
  targetImpl = 0;
  layers[0] = new MWInputLayer;
  layers[0]->setName("input");
  layers[1] = new MWBfpScaleLayer;
  layers[1]->setName("fc_1_scale_to_int8");
  layers[2] =
      new MWInt8FCLayer<signed char, signed char, MWArmneonLayerImplFactory>;
  layers[2]->setName("fc_1");
  layers[3] = new MWBfpRescaleLayer;
  layers[3]->setName("fc_1_rescale_to_fp32");
  layers[4] = new MWSigmoidLayer;
  layers[4]->setName("layer_1");
  layers[4]->setInPlaceIndex(0, 0);
  layers[5] = new MWBfpScaleLayer;
  layers[5]->setName("fc_2_scale_to_int8");
  layers[6] =
      new MWInt8FCLayer<signed char, signed char, MWArmneonLayerImplFactory>;
  layers[6]->setName("fc_2");
  layers[7] = new MWBfpRescaleLayer;
  layers[7]->setName("fc_2_rescale_to_fp32");
  layers[8] = new MWSigmoidLayer;
  layers[8]->setName("layer_2");
  layers[8]->setInPlaceIndex(0, 0);
  layers[9] = new MWOutputLayer;
  layers[9]->setName("output_layer_2");
  layers[9]->setInPlaceIndex(0, 0);
  targetImpl = new MWArmneonTarget::MWTargetNetworkImpl;
  inputTensors[0] = new MWTensor<float>;
  inputTensors[0]->setHeight(1);
  inputTensors[0]->setWidth(1);
  inputTensors[0]->setChannels(196);
  inputTensors[0]->setBatchSize(1);
  inputTensors[0]->setSequenceLength(1);
}

my_net0_0::~my_net0_0()
{
  try {
    if (isInitialized) {
      cleanup();
    }
    for (int idx{0}; idx < 10; idx++) {
      delete layers[idx];
    }
    if (targetImpl) {
      delete targetImpl;
    }
    delete inputTensors[0];
  } catch (...) {
  }
}

namespace coder {
namespace internal {
void dlnetwork_delete(my_net0_0 &obj)
{
  if (obj.isInitialized) {
    obj.cleanup();
  }
}

void dlnetwork_setup(my_net0_0 &obj)
{
  try {
    obj.setup();
  } catch (std::runtime_error const &err) {
    obj.cleanup();
    checkRunTimeError(err.what(), __FILE__, __LINE__);
  } catch (...) {
    obj.cleanup();
    checkRunTimeError("", __FILE__, __LINE__);
  }
}

} // namespace internal
} // namespace coder

// End of code generation (dlnetwork.cpp)
