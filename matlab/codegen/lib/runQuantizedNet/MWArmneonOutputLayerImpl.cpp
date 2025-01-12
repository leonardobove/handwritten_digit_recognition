#include "MWArmneonOutputLayerImpl.hpp"
#include "MWArmneonCNNLayerImpl.hpp"
#include "MWTensorBase.hpp"
#include "MWTensor.hpp"
#include "MWCNNLayer.hpp"
#include "MWACLUtils.hpp"
 namespace MWArmneonTarget { class MWTargetNetworkImpl; 
MWOutputLayerImpl::MWOutputLayerImpl(MWCNNLayer* layer, MWTargetNetworkImpl* 
ntwk_impl) : MWCNNLayerImpl(layer, ntwk_impl) { aFDPITUhkPdupMfPOBnd = 
true; } MWOutputLayerImpl::~MWOutputLayerImpl() { } void 
MWOutputLayerImpl::predict() { MWCNNLayer* opLayer = getLayer(); MWTensorBase* 
ipTensorBase = opLayer->getInputTensor(0); MWTensorBase* opTensorBase = 
opLayer->getOutputTensor(0); MWTensor<float>* opTensor = 
static_cast<MWTensor<float>*>(opTensorBase); auto prevLayerarmTensor = 
MWACLUtils::getLayerOpArmTensor(ipTensorBase); if (prevLayerarmTensor && 
prevLayerarmTensor->info()->has_padding()) { 
MWACLUtils::fillTensorToBuffer(opTensor->getData(), *prevLayerarmTensor); } 
return; } } 