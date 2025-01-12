#include "MWLayerImplFactory.hpp"
#include "MWArmneonLayerImplFactory.hpp"
#include "MWCNNLayerImplBase.hpp"
#include "MWArmneonCNNLayerImpl.hpp"
#include "MWArmneonTargetNetworkImpl.hpp"
 class MWCNNLayer;
#ifndef CREATE_INPUT_LAYER_IMPL_DEFINITION
#define CREATE_INPUT_LAYER_IMPL_DEFINITION

#include "MWArmneonInputLayerImpl.hpp"
MWCNNLayerImplBase* MWArmneonLayerImplFactory::createInputLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2) {
return new MWArmneonTarget::MWInputLayerImpl(arg1,
static_cast<MWArmneonTarget::MWTargetNetworkImpl*>(arg2));
}

#endif

#ifndef CREATE_BFPSCALE_LAYER_IMPL_DEFINITION
#define CREATE_BFPSCALE_LAYER_IMPL_DEFINITION

#include "MWArmneonBfpScaleLayerImpl.hpp"
MWCNNLayerImplBase* MWArmneonLayerImplFactory::createBfpScaleLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2,
bool arg3) {
return new MWArmneonTarget::MWBfpScaleLayerImpl(arg1,
static_cast<MWArmneonTarget::MWTargetNetworkImpl*>(arg2),
arg3);
}

#endif

#ifndef CREATE_INT8FC_LAYER_IMPL_DEFINITION
#define CREATE_INT8FC_LAYER_IMPL_DEFINITION

#include "MWArmneonInt8FCLayerImpl.hpp"
template <typename T1,typename T2>
MWCNNLayerImplBase* MWArmneonLayerImplFactory::createInt8FCLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2,
int arg3,
int arg4,
const char* arg5,
const char* arg6,
int arg7) {
return new MWArmneonTarget::MWInt8FCLayerImpl<T1,T2>(arg1,
static_cast<MWArmneonTarget::MWTargetNetworkImpl*>(arg2),
arg3,
arg4,
arg5,
arg6,
arg7);
}

template MWCNNLayerImplBase* MWArmneonLayerImplFactory::createInt8FCLayerImpl<signed char,float>(MWCNNLayer*,
MWTargetNetworkImplBase*,
int,
int,
const char*,
const char*,
int);
template MWCNNLayerImplBase* MWArmneonLayerImplFactory::createInt8FCLayerImpl<signed char,signed char>(MWCNNLayer*,
MWTargetNetworkImplBase*,
int,
int,
const char*,
const char*,
int);


#endif

#ifndef CREATE_BFPRESCALE_LAYER_IMPL_DEFINITION
#define CREATE_BFPRESCALE_LAYER_IMPL_DEFINITION

#include "MWArmneonBfpRescaleLayerImpl.hpp"
MWCNNLayerImplBase* MWArmneonLayerImplFactory::createBfpRescaleLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2) {
return new MWArmneonTarget::MWBfpRescaleLayerImpl(arg1,
static_cast<MWArmneonTarget::MWTargetNetworkImpl*>(arg2));
}

#endif

#ifndef CREATE_SIGMOID_LAYER_IMPL_DEFINITION
#define CREATE_SIGMOID_LAYER_IMPL_DEFINITION

#include "MWArmneonSigmoidLayerImpl.hpp"
MWCNNLayerImplBase* MWArmneonLayerImplFactory::createSigmoidLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2) {
return new MWArmneonTarget::MWSigmoidLayerImpl(arg1,
static_cast<MWArmneonTarget::MWTargetNetworkImpl*>(arg2));
}

#endif

#ifndef CREATE_OUTPUT_LAYER_IMPL_DEFINITION
#define CREATE_OUTPUT_LAYER_IMPL_DEFINITION

#include "MWArmneonOutputLayerImpl.hpp"
MWCNNLayerImplBase* MWArmneonLayerImplFactory::createOutputLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2) {
return new MWArmneonTarget::MWOutputLayerImpl(arg1,
static_cast<MWArmneonTarget::MWTargetNetworkImpl*>(arg2));
}

#endif
