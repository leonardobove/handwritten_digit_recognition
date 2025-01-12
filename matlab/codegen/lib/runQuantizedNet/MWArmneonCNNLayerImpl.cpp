#include "MWArmneonCNNLayerImpl.hpp"
#include "MWCNNLayer.hpp"
#include "MWTensorBase.hpp"
#include "MWTensor.hpp"
#include "MWArmneonTargetNetworkImpl.hpp"
#include "MWACLUtils.hpp"
#include <arm_neon.h>
#include <memory>
#include <cassert>
#include <cstring>
#include <cstdio>
 namespace MWArmneonTarget {
#if MW_LAYERS_TAP
 extern void mw_interm_tap(arm_compute::Tensor& armTensor, int size, int 
count); extern void mw_interm_tap(float* memBuf, int size, int count); extern 
int tap_count;
#endif
 MWCNNLayerImpl::MWCNNLayerImpl(MWCNNLayer* layer, MWTargetNetworkImpl* 
ntwk_impl) : MWCNNLayerImplBase(layer) , cwCXkgHfZmFQRzNVUlCO(ntwk_impl) { } 
void MWCNNLayerImpl::allocateOutput(int outIdx) { if 
(getLayer()->getOutputTensor(outIdx)->isFloat()) { 
this->allocateOutputImpl<float>(outIdx); } else { 
assert(getLayer()->getOutputTensor(outIdx)->isInt8()); 
this->allocateOutputImpl<signed char>(outIdx); } } template <class T> void 
MWCNNLayerImpl::allocateOutputImpl(int outIdx) { if (this->isHandCodedLayer()) 
{ allocateHandCodedLayerOpData<T>(outIdx); } else { 
allocateACLLayerOpData<T>(outIdx); } } template <class T> void 
MWCNNLayerImpl::allocateACLLayerOpData(int outIdx) { MWTensorBase* opTensorBase 
= getLayer()->getOutputTensor(outIdx); MWTensor<T>* opTensor = 
static_cast<MWTensor<T>*>(opTensorBase); int outBufIndex = 
opTensor->getopBufIndex(); int inIdx = getLayer()->getInPlaceIndex(outIdx); if 
(inIdx == -1) { if (outBufIndex < 0) {  
getCurrentLayerOpArmTensor(outIdx)->allocator()->allocate(); } else { 
getCurrentLayerOpArmTensor(outIdx)->allocator()->import_memory( 
cwCXkgHfZmFQRzNVUlCO->memBuffer[outBufIndex]); } } else { auto ipArmTensor = 
getCurrentLayerIpArmTensor(inIdx); auto opArmTensor = 
getCurrentLayerOpArmTensor(outIdx); if (ipArmTensor != opArmTensor) { T* 
ipArmTensorData = (T*)ipArmTensor->buffer(); 
getCurrentLayerOpArmTensor(outIdx)->allocator()->import_memory(ipArmTensorData); 
} } opTensor->setData((T*)getCurrentLayerOpArmTensor(outIdx)->buffer()); } 
template <class T> void MWCNNLayerImpl::allocateHandCodedLayerOpData(int 
outIdx) { MWTensorBase* opTensorBase = getLayer()->getOutputTensor(outIdx); 
MWTensor<T>* opTensor = static_cast<MWTensor<T>*>(opTensorBase); int 
outBufIndex = opTensor->getopBufIndex(); bool bufferReuse = outBufIndex >= 0; 
int inIdx = getLayer()->getInPlaceIndex(outIdx); bool inPlace = inIdx != -1; if 
(!bufferReuse) {  if (inPlace) {  MWTensorBase* ipTensorBase = 
getLayer()->getInputTensor(inIdx); T* ipData = 
(T*)getUnpaddedIpData(ipTensorBase); opTensor->setData(ipData); } else {  int 
eWYFXrUazhqiEIscccda = opTensorBase->getNumElements(); 
opTensor->setData((T*)calloc(eWYFXrUazhqiEIscccda, sizeof(T))); } } else { 
assert(!inPlace); auto opBuffer = 
MW_GET_BUFFER(cwCXkgHfZmFQRzNVUlCO->memBuffer[outBufIndex]); 
opTensor->setData((T*)opBuffer); } } template void 
MWCNNLayerImpl::allocateOutputImpl<float>(int); template void 
MWCNNLayerImpl::allocateOutputImpl<signed char>(int); void 
MWCNNLayerImpl::deallocateOutput(int outIdx) { if 
(getLayer()->getOutputTensor(outIdx)->isFloat()) { 
this->deallocateOutputImpl<float>(outIdx); } else { 
assert(getLayer()->getOutputTensor(outIdx)->isInt8()); 
this->deallocateOutputImpl<signed char>(outIdx); } } template <class T> void 
MWCNNLayerImpl::deallocateOutputImpl(int outIdx) { MWTensorBase* opTensorBase = 
getLayer()->getOutputTensor(outIdx); MWTensor<T>* opTensor = 
static_cast<MWTensor<T>*>(opTensorBase); int inPlaceIdx = 
getLayer()->getInPlaceIndex(outIdx); int opBufIdx = opTensor->getopBufIndex(); 
if (opBufIdx < 0 && inPlaceIdx == -1) { if (this->isHandCodedLayer()) { T* 
opDataBuf = opTensor->getData(); if (opDataBuf) { free(opDataBuf); } } 
opTensor->setData((T*)nullptr);  } } template void 
MWCNNLayerImpl::deallocateOutputImpl<float>(int); template void 
MWCNNLayerImpl::deallocateOutputImpl<signed char>(int); void 
MWCNNLayerImpl::allocateInput(int inIdx) { MWTensorBase* ipTensor = 
getLayer()->getInputTensor(inIdx); if (ipTensor->isFloat()) { 
allocateInputImpl<float>(inIdx); } else { assert(ipTensor->isInt8()); 
allocateInputImpl<signed char>(inIdx); } } template <class T> void 
MWCNNLayerImpl::allocateInputImpl(int inIdx) { MWTensorBase* ipTensorBase = 
getLayer()->getInputTensor(inIdx); MWTensor<T>* ipTensor = 
static_cast<MWTensor<T>*>(ipTensorBase); auto prevLayerOpArmTensor = 
MWACLUtils::getLayerOpArmTensor(ipTensorBase); if (this->isHandCodedLayer()) {  
if (prevLayerOpArmTensor != nullptr) { if 
(prevLayerOpArmTensor->info()->has_padding()) { 
setUnpaddedIpData<T>(ipTensorBase, (T*)calloc(ipTensor->getNumElements(), 
sizeof(T))); } else { setUnpaddedIpData<T>(ipTensorBase, 
(T*)prevLayerOpArmTensor->buffer()); } } else { 
setUnpaddedIpData<T>(ipTensorBase, (T*)ipTensor->getData()); } } else {  if 
(prevLayerOpArmTensor == nullptr) { if 
(getCurrentLayerIpArmTensor(inIdx)->info()->has_padding()) { 
getCurrentLayerIpArmTensor(inIdx)->allocator()->allocate(); } else { T* ipData 
= (T*)ipTensor->getData(); 
getCurrentLayerIpArmTensor(inIdx)->allocator()->import_memory(ipData); } } } } 
template void MWCNNLayerImpl::allocateInputImpl<float>(int); template void 
MWCNNLayerImpl::allocateInputImpl<signed char>(int); void 
MWCNNLayerImpl::deallocateInput(int inIdx) { MWTensorBase* ipTensorBase = 
getLayer()->getInputTensor(inIdx); if (ipTensorBase->isFloat()) { 
deallocateInputImpl<float>(inIdx); } else { assert(ipTensorBase->isInt8()); 
deallocateInputImpl<signed char>(inIdx); } } template <class T> void 
MWCNNLayerImpl::deallocateInputImpl(int inIdx) { MWTensorBase* ipTensorBase = 
getLayer()->getInputTensor(inIdx); MWTensor<T>* ipTensor = 
static_cast<MWTensor<T>*>(ipTensorBase); auto prevLayerOpArmTensor = 
MWACLUtils::getLayerOpArmTensor(ipTensor); if (this->isHandCodedLayer()) {  if 
(prevLayerOpArmTensor != nullptr && 
prevLayerOpArmTensor->info()->has_padding()) { T* ipDataBuf = 
(T*)getUnpaddedIpData(ipTensorBase); if (ipDataBuf) { free(ipDataBuf); 
setUnpaddedIpData<T>(ipTensorBase, (T*)NULL); } } } } template void 
MWCNNLayerImpl::deallocateInputImpl<float>(int); template void 
MWCNNLayerImpl::deallocateInputImpl<signed char>(int); template <class T> void 
MWCNNLayerImpl::setUnpaddedIpData(MWTensorBase* aTensor, T* bufPtr) { 
YMNbgnUYZspjMLjwcIOS[aTensor] = (T*)bufPtr; } void* 
MWCNNLayerImpl::getUnpaddedIpData(MWTensorBase* aTensor) { if 
(YMNbgnUYZspjMLjwcIOS.size() >= 1) { return 
YMNbgnUYZspjMLjwcIOS[aTensor]; } else { return NULL; } } void 
MWCNNLayerImpl::setupIpArmTensors() { int numInputs = 
static_cast<int>(getLayer()->getNumInputs()); for (int inIdx = 0; inIdx < 
numInputs; inIdx++) { MWTensorBase* ipTensor = 
getLayer()->getInputTensor(inIdx); auto prevLayerOpArmTensorSharedPtr = 
MWACLUtils::getLayerOpArmTensorsharedPtr(ipTensor); if 
(prevLayerOpArmTensorSharedPtr) { 
setCurrentLayerIpArmTensor(prevLayerOpArmTensorSharedPtr, inIdx); } else { 
setCurrentLayerIpArmTensor(std::make_shared<arm_compute::Tensor>(), inIdx); } } 
} void MWCNNLayerImpl::prepareIpArmTensorsForPredict() { int numInputs = 
getLayer()->getNumInputs(); for (int inIdx = 0; inIdx < numInputs; inIdx++) { 
MWTensorBase* ipTensorBase = getLayer()->getInputTensor(inIdx); if 
(ipTensorBase->isFloat()) { MWTensor<float>* ipTensor = 
static_cast<MWTensor<float>*>(ipTensorBase); auto prevLayerOpArmTensor = 
MWACLUtils::getLayerOpArmTensor(ipTensor); auto currLayerIpArmTensor = 
getCurrentLayerIpArmTensor(inIdx); float* ipData = ipTensor->getData(); if 
(prevLayerOpArmTensor == nullptr) { if 
(currLayerIpArmTensor->info()->has_padding()) { 
MWACLUtils::fillBufferToTensor<float>(ipData, *currLayerIpArmTensor); } } } 
else { MWTensor<signed char>* ipTensor = static_cast<MWTensor<signed 
char>*>(ipTensorBase); auto prevLayerOpArmTensor = 
MWACLUtils::getLayerOpArmTensor(ipTensor); auto currLayerIpArmTensor = 
getCurrentLayerIpArmTensor(inIdx); signed char* ipData = ipTensor->getData(); 
if (prevLayerOpArmTensor == nullptr) { if 
(currLayerIpArmTensor->info()->has_padding()) { 
MWACLUtils::fillBufferToTensor<signed char>(ipData, *currLayerIpArmTensor); } } 
} } } void MWCNNLayerImpl::configureIpArmTensors() { int numInputs = 
getLayer()->getNumInputs(); for (int inIdx = 0; inIdx < numInputs; inIdx++) { 
MWTensorBase* ipTensor = getLayer()->getInputTensor(inIdx); if 
(ipTensor->isFloat()) { auto prevLayerOpArmTensor = 
MWACLUtils::getLayerOpArmTensor(ipTensor); if (prevLayerOpArmTensor == nullptr) 
{ getCurrentLayerIpArmTensor(inIdx)->allocator()->init(arm_compute::TensorInfo( 
arm_compute::TensorShape((long unsigned int)ipTensor->getWidth(), (long 
unsigned int)ipTensor->getHeight(), (long unsigned int)ipTensor->getChannels(), 
(long unsigned int)ipTensor->getBatchSize() * (long unsigned 
int)ipTensor->getSequenceLength()), 1, arm_compute::DataType::F32)); } }
#if defined(USE_20_02_1_LIBRARY) || defined(USE_20_11_LIBRARY)
 else { auto prevLayerOpArmTensor = MWACLUtils::getLayerOpArmTensor(ipTensor); 
if (prevLayerOpArmTensor == nullptr) { arm_compute::QuantizationInfo 
inputQuantInfo = arm_compute::QuantizationInfo( (1.0f / pow(2.0, 
-(ipTensor->getOwner()->getScalingExponent()))), 0); 
getCurrentLayerIpArmTensor(inIdx)->allocator()->init(arm_compute::TensorInfo( 
arm_compute::TensorShape((long unsigned int)ipTensor->getWidth(), (long 
unsigned int)ipTensor->getHeight(), (long unsigned int)ipTensor->getChannels(), 
(long unsigned int)ipTensor->getBatchSize() * (long unsigned 
int)ipTensor->getSequenceLength()), 1, arm_compute::DataType::QASYMM8_SIGNED, 
inputQuantInfo)); } }
#endif
 } } std::string MWCNNLayerImpl::getLinuxPath(const char* fileName) { 
std::string fileS(fileName); std::string key("\\"); std::size_t found = 0; 
while (found != std::string::npos) { found = fileS.rfind(key); if (found != 
std::string::npos) { fileS.replace(found, key.length(), "/"); } } return fileS; 
} void 
MWCNNLayerImpl::setCurrentLayerOpArmTensor(std::shared_ptr<arm_compute::Tensor> 
tensor, int index) { jHzoRQWaHafftmrmuvHO[index] = tensor; } 
arm_compute::Tensor* MWCNNLayerImpl::getCurrentLayerOpArmTensor(int index) { if 
(jHzoRQWaHafftmrmuvHO.size() >= 1) { return 
jHzoRQWaHafftmrmuvHO[index].get(); } else { return nullptr; } } 
std::shared_ptr<arm_compute::Tensor> 
MWCNNLayerImpl::getCurrentLayerOpArmTensorSharedPtr( int index) { if 
(jHzoRQWaHafftmrmuvHO.size() >= 1) { return 
jHzoRQWaHafftmrmuvHO[index]; } else { return nullptr; } } void 
MWCNNLayerImpl::setCurrentLayerIpArmTensor(std::shared_ptr<arm_compute::Tensor> 
tensor, int index) { UzOdnHgHuNHtprVxxxXl[index] = tensor; } 
arm_compute::Tensor* MWCNNLayerImpl::getCurrentLayerIpArmTensor(int index) { if 
(UzOdnHgHuNHtprVxxxXl.size() >= 1) { return 
UzOdnHgHuNHtprVxxxXl[index].get(); } else { return nullptr; } } 
std::shared_ptr<arm_compute::Tensor> 
MWCNNLayerImpl::getCurrentLayerIpArmTensorSharedPtr( int index) { if 
(UzOdnHgHuNHtprVxxxXl.size() >= 1) { return 
UzOdnHgHuNHtprVxxxXl[index]; } else { return nullptr; } } } 