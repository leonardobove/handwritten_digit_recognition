#include "MWArmneonBfpRescaleLayerImpl.hpp"
#include "MWArmneonTargetNetworkImpl.hpp"
#include "MWACLUtils.hpp"
#include <cassert>
#include <cstring>
#include <cstdio>
 namespace MWArmneonTarget { 
MWBfpRescaleLayerImpl::MWBfpRescaleLayerImpl(MWCNNLayer* layer, 
MWTargetNetworkImpl* ntwk_impl) : MWCNNLayerImpl(layer, ntwk_impl) { 
aFDPITUhkPdupMfPOBnd = true; } 
MWBfpRescaleLayerImpl::~MWBfpRescaleLayerImpl() { } void 
MWBfpRescaleLayerImpl::predict() { MWCNNLayer* bfpRescaleLayer = getLayer(); 
MWTensorBase* ipTensorBase = bfpRescaleLayer->getInputTensor(); MWTensorBase* 
opTensorBase = bfpRescaleLayer->getOutputTensor(); MWTensor<float>* opTensor = 
static_cast<MWTensor<float>*>(opTensorBase); signed char* VenwEUlYwOBrwLVUhgUH = 
static_cast<signed char*>(getUnpaddedIpData(ipTensorBase)); float* 
jLmklYtHcmTxayQTpmRw = (float*)opTensor->getData(); auto prevLayerarmTensor = 
MWACLUtils::getLayerOpArmTensor(ipTensorBase); if (prevLayerarmTensor && 
prevLayerarmTensor->info()->has_padding()) { 
MWACLUtils::fillTensorToBuffer<signed char>(VenwEUlYwOBrwLVUhgUH, 
*prevLayerarmTensor); }
#pragma omp parallel for
 for (int i = 0; i < opTensor->getNumElements(); i++) { jLmklYtHcmTxayQTpmRw[i] 
= ldexpf(static_cast<signed char>(VenwEUlYwOBrwLVUhgUH[i]), 
bfpRescaleLayer->getScalingExponent()); }
#if MW_BFPRESCALE_TAP
 mw_interm_tap((float*)opTensor->getData(), opTensorBase->getNumElements(), tap_count++);
#endif
 } } 