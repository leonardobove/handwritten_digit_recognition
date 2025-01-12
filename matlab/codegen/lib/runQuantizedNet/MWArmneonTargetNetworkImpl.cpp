#include "MWArmneonTargetNetworkImpl.hpp"
#include "MWTargetNetworkImplBase.hpp"
#include "MWTargetTypes.hpp"
#include "MWTensorBase.hpp"
#include "MWTensor.hpp"
#include "MWCNNLayer.hpp"
#include "MWArmneonCNNLayerImpl.hpp"
#include "MWArmneonLayerImplFactory.hpp"
 namespace MWArmneonTarget { MWTargetNetworkImpl::MWTargetNetworkImpl() : 
MWTargetNetworkImplBase(MWTargetType::ARMNEON_TARGET, new 
MWArmneonLayerImplFactory) { } void MWTargetNetworkImpl::allocate(int 
numBufsToAlloc, MWCNNLayer* layers[], int numLayers, int maxCustomLayerBufSize) 
{ numBufs = numBufsToAlloc; maxBufSize = 
static_cast<size_t>(maxCustomLayerBufSize); for (int i = 0; i < numLayers; i++) 
{ MWCNNLayerImpl* owningLayerImpl = 
static_cast<MWCNNLayerImpl*>(layers[i]->getImpl()); if (owningLayerImpl != 
nullptr) { auto currLayerOpARMTensor = 
owningLayerImpl->getCurrentLayerOpArmTensor(); if (currLayerOpARMTensor) { 
size_t layerBufSize = 
(size_t)((owningLayerImpl->getCurrentLayerOpArmTensor()->info()->total_size()) 
/ sizeof(float)); maxBufSize = (maxBufSize < layerBufSize) ? layerBufSize : 
maxBufSize; } else { size_t layerBufSize = 
(size_t)layers[i]->getOutputTensor()->getNumElements(); maxBufSize = 
(maxBufSize < layerBufSize) ? layerBufSize : maxBufSize; } } } for (int i = 0; 
i < numBufs; i++) { MW_ALLOCATE_MEMORY_BUFFER(); } } void 
MWTargetNetworkImpl::allocatePermuteBuffers(int bufSize, int numBufsToAlloc) { 
npaEYSaGsfCvAUhwdtLe.reserve(numBufsToAlloc); for (int i = 0; i < 
numBufsToAlloc; i++) { float* memPtr = 0; memPtr = (float*)calloc(bufSize, 
sizeof(float)); npaEYSaGsfCvAUhwdtLe.push_back(memPtr); } } float* 
MWTargetNetworkImpl::getPermuteBuffer(int bufIndex) { return 
npaEYSaGsfCvAUhwdtLe[bufIndex]; } float* 
MWTargetNetworkImpl::getLayerOutput(MWCNNLayer* layers[], int layerIndex, int 
portIndex) { MWTensorBase* opTensor = 
layers[layerIndex]->getOutputTensor(portIndex); float* opData = 
getLayerActivation(opTensor); return opData; } float* 
MWTargetNetworkImpl::getLayerActivation(MWTensorBase* opTensorBase) { 
MWTensor<float>* opTensor = static_cast<MWTensor<float>*>(opTensorBase); auto 
owningLayer = opTensor->getOwner(); MWCNNLayerImpl* layerImpl = 
static_cast<MWCNNLayerImpl*>(owningLayer->getImpl()); if (layerImpl == nullptr) 
{  if (owningLayer->isCustomLayer()) { return 
static_cast<MWTensor<float>*>(opTensorBase)->getData(); } else { return 
getLayerActivation(opTensor->getOwner()->getInputTensor()); } } else { if 
(layerImpl->isHandCodedLayer()) { return 
static_cast<MWTensor<float>*>(opTensorBase)->getData(); } else { 
arm_compute::Tensor* currLayerArmTensor = 
layerImpl->getCurrentLayerOpArmTensor(); int layerOutputSize = 
opTensor->getNumElements(); float* m_data = (float*)malloc(sizeof(float) * 
layerOutputSize); MWACLUtils::fillTensorToBuffer<float>(m_data, 
*currLayerArmTensor); memcpy(opTensor->getData(), m_data, layerOutputSize * 
sizeof(float)); free(m_data); return opTensor->getData(); } } } void 
MWTargetNetworkImpl::createWorkSpace(float** ) { } void 
MWTargetNetworkImpl::setWorkSpaceSize(size_t ) { } size_t* 
MWTargetNetworkImpl::getWorkSpaceSize() { return nullptr; } float* 
MWTargetNetworkImpl::getWorkSpace() { return nullptr; } void 
MWTargetNetworkImpl::deallocate() { for (size_t i = 0; i < memBuffer.size(); 
i++) { if (memBuffer[i] != nullptr) { MW_FREE_MEMORY_BUFFER(); } } 
memBuffer.clear(); for (size_t i = 0; i < npaEYSaGsfCvAUhwdtLe.size(); i++) 
{ float* memPtr = npaEYSaGsfCvAUhwdtLe[i]; if (memPtr) { free(memPtr); } } 
npaEYSaGsfCvAUhwdtLe.clear(); } } 