/* Copyright 2021-2022 The MathWorks, Inc. */

#ifndef MW_ARMNEON_LAYER_IMPL_FACTORY
#define MW_ARMNEON_LAYER_IMPL_FACTORY

#include "MWLayerImplFactory.hpp"

class MWCNNLayerImplBase;

class MWArmneonLayerImplFactory : public MWLayerImplFactory {

  public:
    MWArmneonLayerImplFactory() {
    }
    virtual ~MWArmneonLayerImplFactory() {
    }

    // auto-emit createLayerImpl declarations here

#ifndef CREATE_INPUT_LAYER_IMPL_DECLARATION
#define CREATE_INPUT_LAYER_IMPL_DECLARATION

MWCNNLayerImplBase* createInputLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2);


#endif

#ifndef CREATE_BFPSCALE_LAYER_IMPL_DECLARATION
#define CREATE_BFPSCALE_LAYER_IMPL_DECLARATION

MWCNNLayerImplBase* createBfpScaleLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2,
bool arg3);


#endif

#ifndef CREATE_INT8FC_LAYER_IMPL_DECLARATION
#define CREATE_INT8FC_LAYER_IMPL_DECLARATION
template <typename T1,typename T2>
MWCNNLayerImplBase* createInt8FCLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2,
int arg3,
int arg4,
const char* arg5,
const char* arg6,
int arg7);


#endif

#ifndef CREATE_BFPRESCALE_LAYER_IMPL_DECLARATION
#define CREATE_BFPRESCALE_LAYER_IMPL_DECLARATION

MWCNNLayerImplBase* createBfpRescaleLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2);


#endif

#ifndef CREATE_SIGMOID_LAYER_IMPL_DECLARATION
#define CREATE_SIGMOID_LAYER_IMPL_DECLARATION

MWCNNLayerImplBase* createSigmoidLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2);


#endif

#ifndef CREATE_OUTPUT_LAYER_IMPL_DECLARATION
#define CREATE_OUTPUT_LAYER_IMPL_DECLARATION

MWCNNLayerImplBase* createOutputLayerImpl(MWCNNLayer* arg1,
MWTargetNetworkImplBase* arg2);


#endif
};
#endif