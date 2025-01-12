#include "MWArmneonCustomLayerBase.hpp"
#include "MWArmneonTargetNetworkImpl.hpp"
#include "MWTensorBase.hpp"
#include "MWTensor.hpp"
#include "MWCNNLayer.hpp"
#include "MWACLUtils.hpp"
 MWArmneonCustomLayerBase::MWArmneonCustomLayerBase() : m_ntwkImpl(nullptr) { 
m_isCustomLayer = true; } void 
MWArmneonCustomLayerBase::setupLayer(MWArmneonTarget::MWTargetNetworkImpl* 
targetImpl) { m_ntwkImpl = targetImpl; } bool 
MWArmneonCustomLayerBase::isSharedIpArmTensorData(MWTensorBase* aTensor) { auto 
prevLayerOpArmTensor = MWACLUtils::getLayerOpArmTensor(aTensor); if 
(prevLayerOpArmTensor != nullptr && 
prevLayerOpArmTensor->info()->has_padding()) { return false; } else { return 
true; } } void MWArmneonCustomLayerBase::allocate() { for (size_t inIdx = 0; 
inIdx < getNumInputs(); ++inIdx) { allocateInputData(inIdx); } for (size_t 
outIdx = 0; outIdx < getNumOutputs(); ++outIdx) { allocateOutputData(outIdx); } 
} void MWArmneonCustomLayerBase::allocateInputData(int inIdx) { MWTensorBase* 
ipTensorBase = getInputTensor(inIdx); MWTensor<float>* ipTensor = 
static_cast<MWTensor<float>*>(ipTensorBase); bool shareIpArmTensorData = 
isSharedIpArmTensorData(ipTensorBase); if (!shareIpArmTensorData) { 
setUnpaddedIpData(ipTensorBase, (float*)calloc(ipTensor->getNumElements(), 
sizeof(float))); } else { setUnpaddedIpData(ipTensorBase, 
(float*)ipTensor->getData()); } } void 
MWArmneonCustomLayerBase::setUnpaddedIpData(MWTensorBase* aTensor, float* 
bufPtr) { YMNbgnUYZspjMLjwcIOS[aTensor] = bufPtr; } float* 
MWArmneonCustomLayerBase::getUnpaddedIpData(MWTensorBase* aTensor) { if 
(YMNbgnUYZspjMLjwcIOS.size() >= 1) { return 
YMNbgnUYZspjMLjwcIOS[aTensor]; } else { return NULL; } } void 
MWArmneonCustomLayerBase::allocateOutputData(int outIdx) { MWTensorBase* 
opTensorBase = getOutputTensor(outIdx); MWTensor<float>* opTensor = 
static_cast<MWTensor<float>*>(opTensorBase); int outBufIndex = 
opTensor->getopBufIndex(); int inIdx = getInPlaceIndex(outIdx); if (outBufIndex 
< 0) {  if (inIdx != -1) {  MWTensorBase* ipTensorBase = getInputTensor(inIdx); 
MWTensor<float>* ipTensor = static_cast<MWTensor<float>*>(ipTensorBase); float* 
ipData = ipTensor->getData(); opTensor->setData(ipData); } else {  int 
eWYFXrUazhqiEIscccda = opTensorBase->getNumElements(); 
opTensor->setData((float*)calloc(eWYFXrUazhqiEIscccda, sizeof(float))); } } 
else { float* opBuffer = 
(float*)(MW_GET_BUFFER(m_ntwkImpl->memBuffer[outBufIndex])); 
opTensor->setData(opBuffer); } } void 
MWArmneonCustomLayerBase::prepareUnpaddedIpData() { for (size_t inIdx = 0; 
inIdx < getNumInputs(); inIdx++) { MWTensorBase* ipTensorBase = 
getInputTensor(inIdx); float* UVzBVEOIylFjkSgHwFMp = 
getUnpaddedIpData(ipTensorBase); auto prevLayerarmTensor = 
MWACLUtils::getLayerOpArmTensor(ipTensorBase); if (prevLayerarmTensor && 
prevLayerarmTensor->info()->has_padding()) { 
MWACLUtils::fillTensorToBuffer(UVzBVEOIylFjkSgHwFMp, *prevLayerarmTensor); } 
} } void MWArmneonCustomLayerBase::reorderData(MWTensorBase* aTensorBase, int 
bufIndex, MWTensorBase::DIMSLABEL sourceLayout[], MWTensorBase::DIMSLABEL 
targetLayout[], bool isInputReorder) { MWTensor<float>* aTensor = 
static_cast<MWTensor<float>*>(aTensorBase); float* ipBuf; float* outBuf; if 
(isInputReorder) {  ipBuf = getUnpaddedIpData(aTensorBase); outBuf = 
m_ntwkImpl->getPermuteBuffer(bufIndex); } else {  ipBuf = 
m_ntwkImpl->getPermuteBuffer(bufIndex); outBuf = aTensor->getData(); } const 
int size = 5; int sourceDims[size], targetDims[size]; 
aTensorBase->getDimsByLayout(sourceLayout, size, sourceDims); 
aTensorBase->getDimsByLayout(targetLayout, size, targetDims); int 
strides[size]; MWTensorBase::getTransformStrides(sourceLayout, targetLayout, 
targetDims, size, strides); MWACLUtils::doPermutation(ipBuf, outBuf, 
sourceDims, strides); } void MWArmneonCustomLayerBase::deallocate() { for 
(size_t inIdx = 0; inIdx < getNumInputs(); ++inIdx) { MWTensorBase* 
ipTensorBase = getInputTensor(inIdx); bool shareIpArmTensorData = 
isSharedIpArmTensorData(ipTensorBase); if (!shareIpArmTensorData) { float* 
ipDataBuf = (float*)getUnpaddedIpData(ipTensorBase); if (ipDataBuf) { 
free(ipDataBuf); setUnpaddedIpData(ipTensorBase, NULL); } } } for (size_t 
outIdx = 0; outIdx < getNumOutputs(); ++outIdx) { MWTensorBase* opTensorBase = 
getOutputTensor(outIdx); MWTensor<float>* opTensor = 
static_cast<MWTensor<float>*>(opTensorBase); int inPlaceIdx = 
getInPlaceIndex(outIdx); int opBufIdx = opTensor->getopBufIndex(); if (opBufIdx 
< 0 && inPlaceIdx == -1) {  float* opDataBuf = opTensor->getData(); if 
(opDataBuf) { free(opDataBuf); } opTensor->setData(NULL); } } } void 
MWArmneonCustomLayerBase::cleanup() { this->cleanupLayer(); 
this->MWCNNLayer::cleanup(); } 
MWArmneonCustomLayerBase::~MWArmneonCustomLayerBase() { }