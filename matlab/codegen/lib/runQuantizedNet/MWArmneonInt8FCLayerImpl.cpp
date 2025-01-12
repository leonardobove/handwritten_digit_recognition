#include "MWArmneonInt8FCLayerImpl.hpp"
#include "MWArmneonCNNLayerImpl.hpp"
#include "MWCNNLayer.hpp"
#include "MWTensorBase.hpp"
#include "MWArmneonTargetNetworkImpl.hpp"
#include "MWACLUtils.hpp"
#include <arm_neon.h>
#include <memory>
#include <vector>
 namespace MWArmneonTarget { template class MWInt8FCLayerImpl<signed char, 
float>; template class MWInt8FCLayerImpl<signed char, signed char>; template 
<typename T1, typename T2> MWInt8FCLayerImpl<T1, 
T2>::MWInt8FCLayerImpl(MWCNNLayer* layer, MWTargetNetworkImpl* ntwk_impl, int 
m_NumInputFeatures, int m_NumOutputFeatures, const char* m_weights_file, const 
char* m_bias_file, int yPBlKhIGljihkXaXbYpB) : MWCNNLayerImpl(layer, 
ntwk_impl) { setupIpArmTensors(); 
setCurrentLayerOpArmTensor(std::make_shared<arm_compute::Tensor>()); int 
dAGMlbhOYuZqhuDGCqih = m_NumInputFeatures * m_NumOutputFeatures;  
arm_compute::QuantizationInfo weightsQuantInfo = 
arm_compute::QuantizationInfo(std::pow(2, yPBlKhIGljihkXaXbYpB), 0); 
m_fcLayerWgtTensor.allocator()->init( 
arm_compute::TensorInfo(arm_compute::TensorShape((long unsigned 
int)(m_NumInputFeatures), (long unsigned int)(m_NumOutputFeatures)), 1, 
arm_compute::DataType::QASYMM8_SIGNED, weightsQuantInfo)); 
m_fcLayerBiasTensor.allocator()->init( 
arm_compute::TensorInfo(arm_compute::TensorShape((long unsigned 
int)(m_NumOutputFeatures)), 1, arm_compute::DataType::S32)); unSXtdjDjpysqxmbIiPv = 
MW_CREATE_BUFFER_INT8(dAGMlbhOYuZqhuDGCqih); KHjdvykTFbUxdfZTFbqy = 
MW_CREATE_BUFFER_INT32(m_NumOutputFeatures); loadWeights(m_weights_file, 
dAGMlbhOYuZqhuDGCqih); loadBias(m_bias_file, m_NumOutputFeatures); } template 
<typename T1, typename T2> MWInt8FCLayerImpl<T1, T2>::~MWInt8FCLayerImpl() { } 
template <typename T1, typename T2> void MWInt8FCLayerImpl<T1, 
T2>::propagateSize() { MWCNNLayer* fcLayer = getLayer(); MWTensorBase* opTensor 
= fcLayer->getOutputTensor(0); configureIpArmTensors(); arm_compute::Tensor* 
prevLayerarmTensor = getCurrentLayerIpArmTensor(); int 
rlQsibXJSWJVnUVpdNeL = fcLayer->getScalingExponent(); 
arm_compute::QuantizationInfo outputQuantInfo = 
arm_compute::QuantizationInfo(std::pow(2, rlQsibXJSWJVnUVpdNeL), 0); 
m_fcLayer = std::unique_ptr<arm_compute::NEFullyConnectedLayer>(new 
arm_compute::NEFullyConnectedLayer); if (opTensor->getDataFormat() == "CBT" || 
opTensor->getDataFormat() == "CT") { 
getCurrentLayerOpArmTensor()->allocator()->init(arm_compute::TensorInfo( 
arm_compute::TensorShape( (long unsigned int)(opTensor->getWidth() * 
opTensor->getHeight() * opTensor->getChannels()), (long unsigned 
int)(opTensor->getBatchSize() * opTensor->getSequenceLength())), 1, 
arm_compute::DataType::QASYMM8_SIGNED, outputQuantInfo)); 
m_fcLayer->configure(prevLayerarmTensor, &m_fcLayerWgtTensor, 
&m_fcLayerBiasTensor, getCurrentLayerOpArmTensor()); } else { 
mFcLayerIntermOpTensor.allocator()->init(arm_compute::TensorInfo( 
arm_compute::TensorShape( (long unsigned int)(opTensor->getWidth() * 
opTensor->getHeight() * opTensor->getChannels()), (long unsigned 
int)(opTensor->getBatchSize() * opTensor->getSequenceLength())), 1, 
arm_compute::DataType::QASYMM8_SIGNED, outputQuantInfo)); 
getCurrentLayerOpArmTensor()->allocator()->init(arm_compute::TensorInfo( 
arm_compute::TensorShape( (long unsigned int)(opTensor->getWidth()), (long 
unsigned int)(opTensor->getHeight()), (long unsigned 
int)(opTensor->getChannels()), (long unsigned int)(opTensor->getBatchSize() * 
opTensor->getSequenceLength())), 1, arm_compute::DataType::QASYMM8_SIGNED, 
outputQuantInfo)); mReshapeLayer = 
std::unique_ptr<arm_compute::NEReshapeLayer>(new arm_compute::NEReshapeLayer); 
m_fcLayer->configure(prevLayerarmTensor, &m_fcLayerWgtTensor, 
&m_fcLayerBiasTensor, &mFcLayerIntermOpTensor); 
mReshapeLayer->configure(&mFcLayerIntermOpTensor, 
getCurrentLayerOpArmTensor()); } prepareWeights(unSXtdjDjpysqxmbIiPv); } template 
<typename T1, typename T2> void MWInt8FCLayerImpl<T1, T2>::allocate() { 
MWACLUtils::allocateAndFillTensor<signed char>(m_fcLayerWgtTensor, 
unSXtdjDjpysqxmbIiPv, isWgtsPadded); MWACLUtils::allocateAndFillTensor<signed 
int>(m_fcLayerBiasTensor, (signed int*)KHjdvykTFbUxdfZTFbqy, isBiasPadded); 
MWTensorBase* opTensor = getLayer()->getOutputTensor(); if 
(opTensor->getDataFormat() != "CBT" && opTensor->getDataFormat() != "CT") { 
mFcLayerIntermOpTensor.allocator()->allocate(); } return; } template <typename 
T1, typename T2> void MWInt8FCLayerImpl<T1, T2>::loadWeights(const char* 
PQjbchiGbyJfmpiqPpOC, int dAGMlbhOYuZqhuDGCqih) { signed char* uznbYLhhKtdvhPWaHJnR = 
MW_GET_BUFFER(unSXtdjDjpysqxmbIiPv); std::string fileString = 
getLinuxPath(PQjbchiGbyJfmpiqPpOC); FILE* PtRNGuserCxHAQfyEjFc = 
MWCNNLayer::openBinaryFile(fileString.c_str()); 
MWCNNLayer::call_fread(uznbYLhhKtdvhPWaHJnR, sizeof(signed char), dAGMlbhOYuZqhuDGCqih, 
PtRNGuserCxHAQfyEjFc, PQjbchiGbyJfmpiqPpOC); fclose(PtRNGuserCxHAQfyEjFc); } template 
<typename T1, typename T2> void MWInt8FCLayerImpl<T1, 
T2>::prepareWeights(signed char* xcusoQxPPodcHwVviCWI) { signed char* 
wXLECKaOWaQNZlVHfnNP = MW_GET_BUFFER(xcusoQxPPodcHwVviCWI); MWCNNLayer* fcLayer = 
getLayer(); MWTensorBase* ipTensor = fcLayer->getInputTensor(); MWTensorBase* 
opTensor = fcLayer->getOutputTensor(); int CTCbzQMDaLxINPbODdng = 
ipTensor->getChannels() * ipTensor->getWidth() * ipTensor->getHeight(); int 
DCdZnqpcBnvXVgEsLBnz = opTensor->getChannels(); int dAGMlbhOYuZqhuDGCqih = 
CTCbzQMDaLxINPbODdng * DCdZnqpcBnvXVgEsLBnz;  if 
(ipTensor->getHeight() != 1 && ipTensor->getWidth() != 1) { signed char* 
uznbYLhhKtdvhPWaHJnR = (signed char*)malloc(sizeof(char) * ipTensor->getHeight() * 
ipTensor->getWidth()); for (int k = 0; k < dAGMlbhOYuZqhuDGCqih / 
ipTensor->getHeight() / ipTensor->getWidth(); k++) { for (int i = 0; i < 
ipTensor->getHeight() * ipTensor->getWidth(); i++) uznbYLhhKtdvhPWaHJnR[i] = 
wXLECKaOWaQNZlVHfnNP[k * ipTensor->getHeight() * ipTensor->getWidth() + i]; for (int j 
= 0; j < ipTensor->getHeight(); j++) for (int i = 0; i < ipTensor->getWidth(); 
i++) wXLECKaOWaQNZlVHfnNP[k * ipTensor->getHeight() * ipTensor->getWidth() + j * 
ipTensor->getWidth() + i] = uznbYLhhKtdvhPWaHJnR[j + i * ipTensor->getHeight()]; } 
free(uznbYLhhKtdvhPWaHJnR); } return; } template <typename T1, typename T2> void 
MWInt8FCLayerImpl<T1, T2>::loadBias(const char* PQjbchiGbyJfmpiqPpOC, int 
DCdZnqpcBnvXVgEsLBnz) { signed int* KZWeXiYFmdpQdsgidKeG = 
MW_GET_BUFFER(KHjdvykTFbUxdfZTFbqy); std::string fileString = 
getLinuxPath(PQjbchiGbyJfmpiqPpOC); FILE* PtRNGuserCxHAQfyEjFc = 
MWCNNLayer::openBinaryFile(fileString.c_str()); 
MWCNNLayer::call_fread(KZWeXiYFmdpQdsgidKeG, sizeof(signed int), 
DCdZnqpcBnvXVgEsLBnz, PtRNGuserCxHAQfyEjFc, PQjbchiGbyJfmpiqPpOC); 
fclose(PtRNGuserCxHAQfyEjFc); return; } template <typename T1, typename T2> void 
MWInt8FCLayerImpl<T1, T2>::predict() { prepareIpArmTensorsForPredict(); 
m_fcLayer->run(); MWTensorBase* opTensor = getLayer()->getOutputTensor(); if 
(opTensor->getDataFormat() != "CBT" && opTensor->getDataFormat() != "CT") { 
mReshapeLayer->run(); }
#if MW_FC_TAP
 MWTensorBase* opTensorBase = getLayer()->getOutputTensor(); 
MWACLUtils::mw_interm_tap_INT8(*getCurrentLayerOpArmTensor(), 
opTensorBase->getNumElements(), MWACLUtils::tap_count++);
#endif
 return; } template <typename T1, typename T2> void MWInt8FCLayerImpl<T1, 
T2>::deallocate() { if (isWgtsPadded) { m_fcLayerWgtTensor.allocator()->free(); 
isWgtsPadded = false; } if (isBiasPadded) { 
m_fcLayerBiasTensor.allocator()->free(); isWgtsPadded = false; } return; } 
template <typename T1, typename T2> void MWInt8FCLayerImpl<T1, T2>::cleanup() { 
MW_FREE_BUFFER_MEMORY(unSXtdjDjpysqxmbIiPv); MW_FREE_BUFFER_MEMORY(KHjdvykTFbUxdfZTFbqy); 
return; } } 