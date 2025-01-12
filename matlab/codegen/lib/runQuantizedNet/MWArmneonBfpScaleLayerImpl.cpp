#include "MWArmneonBfpScaleLayerImpl.hpp"
#include "MWArmneonTargetNetworkImpl.hpp"
#include "MWACLUtils.hpp"
#include <cassert>
#include <cstring>
#include <cstdio>
 namespace MWArmneonTarget { 
MWBfpScaleLayerImpl::MWBfpScaleLayerImpl(MWCNNLayer* layer, 
MWTargetNetworkImpl* ntwk_impl, bool) : MWCNNLayerImpl(layer, ntwk_impl) { 
aFDPITUhkPdupMfPOBnd = true; } 
MWBfpScaleLayerImpl::~MWBfpScaleLayerImpl() { } void 
MWBfpScaleLayerImpl::predict() { MWCNNLayer* bfpScaleLayer = getLayer(); 
MWTensorBase* ipTensorBase = bfpScaleLayer->getInputTensor(); MWTensorBase* 
opTensorBase = bfpScaleLayer->getOutputTensor(); MWTensor<float>* opTensor = 
static_cast<MWTensor<float>*>(opTensorBase); float* VenwEUlYwOBrwLVUhgUH = 
static_cast<float*>(getUnpaddedIpData(ipTensorBase)); signed char* 
jLmklYtHcmTxayQTpmRw = (signed char*)opTensor->getData(); auto 
prevLayerarmTensor = MWACLUtils::getLayerOpArmTensor(ipTensorBase); if 
(prevLayerarmTensor && prevLayerarmTensor->info()->has_padding()) { 
MWACLUtils::fillTensorToBuffer<float>(VenwEUlYwOBrwLVUhgUH, 
*prevLayerarmTensor); } for (int i = 0; i < opTensor->getNumElements(); i++) { 
float scaledData = ldexpf(VenwEUlYwOBrwLVUhgUH[i], -1 * 
bfpScaleLayer->getScalingExponent()); if (scaledData > 127) { scaledData = 127; 
} else if (scaledData < -128) { scaledData = -128; } jLmklYtHcmTxayQTpmRw[i] = 
static_cast<signed char>(round(scaledData)); }
#if MW_BFPSCALE_TAP
 mw_interm_tap((signed char*)opTensor->getData(), 
opTensorBase->getNumElements(), tap_count++);
#endif
 } } 