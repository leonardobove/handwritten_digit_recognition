#include "MWArmneonSigmoidLayerImpl.hpp"
#include "MWArmneonCNNLayerImpl.hpp"
#include "MWCNNLayer.hpp"
#include "MWTensorBase.hpp"
#include "MWTensor.hpp"
#include "MWACLUtils.hpp"
#include <arm_neon.h>
#include <memory>
#include <cassert>
#include <cstring>
#include <cstdio>
 namespace MWArmneonTarget { class MWTargetNetworkImpl; 
MWSigmoidLayerImpl::MWSigmoidLayerImpl(MWCNNLayer* layer, MWTargetNetworkImpl* 
ntwk_impl) : MWCNNLayerImpl(layer, ntwk_impl) {
#if ARMCOMPUTE_SIGMOID
 setupIpArmTensors(); setCurrentLayerOpArmTensor(std::make_shared<arm_compute::Tensor>());
#else
 aFDPITUhkPdupMfPOBnd = true;
#endif
 } MWSigmoidLayerImpl::~MWSigmoidLayerImpl() { } void 
MWSigmoidLayerImpl::propagateSize() {
#if ARMCOMPUTE_SIGMOID
 m_actLayer = std::unique_ptr<arm_compute::NEActivationLayer>(new 
arm_compute::NEActivationLayer); configureIpArmTensors(); arm_compute::Tensor* 
prevLayerarmTensor = getCurrentLayerIpArmTensor(); bool 
doesPrevLayerHas2DArmTensor = prevLayerarmTensor->info()->num_dimensions() <= 2 
&& ipTensor->getHeight() == 1 && ipTensor->getWidth() == 1; if 
(doesPrevLayerHas2DArmTensor) { 
getCurrentLayerOpArmTensor()->allocator()->init(arm_compute::TensorInfo( 
arm_compute::TensorShape( (long unsigned int)opTensor->getChannels(), (long 
unsigned int)(opTensor->getSequenceLength() * opTensor->getBatchSize())), 1, 
arm_compute::DataType::F32)); } else { 
getCurrentLayerOpArmTensor()->allocator()->init(arm_compute::TensorInfo( 
arm_compute::TensorShape( (long unsigned int)ipTensor->getWidth(), (long 
unsigned int)ipTensor->getHeight(), (long unsigned int)opTensor->getChannels(), 
(long unsigned int)(opTensor->getSequenceLength() * opTensor->getBatchSize())), 
1, arm_compute::DataType::F32)); } m_actLayer->configure(prevLayerarmTensor, 
getCurrentLayerOpArmTensor(), arm_compute::ActivationLayerInfo( arm_compute::ActivationLayerInfo::ActivationFunction::LOGISTIC));
#endif
 } void MWSigmoidLayerImpl::predict() { MWCNNLayer* sigmoidLayer = getLayer(); 
MWTensorBase* opTensorBase = sigmoidLayer->getOutputTensor(); MWTensorBase* 
ipTensorBase = sigmoidLayer->getInputTensor(); MWTensor<float>* ipTensor = 
static_cast<MWTensor<float>*>(ipTensorBase); MWTensor<float>* opTensor = static_cast<MWTensor<float>*>(opTensorBase);
#if ARMCOMPUTE_SIGMOID
 prepareIpArmTensorsForPredict(); m_actLayer->run();
#else
 float* VenwEUlYwOBrwLVUhgUH = 
static_cast<float*>(getUnpaddedIpData(ipTensorBase)); float* 
jLmklYtHcmTxayQTpmRw = opTensor->getData(); auto prevLayerarmTensor = 
MWACLUtils::getLayerOpArmTensor(ipTensorBase); if (prevLayerarmTensor && 
prevLayerarmTensor->info()->has_padding()) { 
MWACLUtils::fillTensorToBuffer<float>(VenwEUlYwOBrwLVUhgUH, 
*prevLayerarmTensor); }
#pragma omp parallel for
 for (int i = 0; i < ipTensor->getNumElements(); i++) { jLmklYtHcmTxayQTpmRw[i] 
= 1 / (1 + exp((-1) * VenwEUlYwOBrwLVUhgUH[i])); }
#endif
#if MW_SIGMOID_TAP
#if ARMCOMPUTE_SIGMOID
 mw_interm_tap(*getCurrentLayerOpArmTensor(), opTensorBase->getNumElements(), tap_count++);
#else
 mw_interm_tap(opTensor->getData(), opTensorBase->getNumElements(), tap_count++);
#endif
#endif
 } } 