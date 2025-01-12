/* Copyright 2018-2022 The MathWorks, Inc. */

#ifndef MW_ARMNEON_BFPSCALE_LAYER_IMPL
#define MW_ARMNEON_BFPSCALE_LAYER_IMPL

#include "MWArmneonCNNLayerImpl.hpp"

/**
 *  Codegen class for Exponential layer
 **/
class MWCNNLayer;
namespace MWArmneonTarget {
class MWTargetNetworkImpl;
class MWBfpScaleLayerImpl final : public MWCNNLayerImpl {
  public:
    MWBfpScaleLayerImpl(MWCNNLayer*, MWTargetNetworkImpl*, bool);
    ~MWBfpScaleLayerImpl();

    void propagateSize(){};
    void predict();
};


} // namespace MWArmneonTarget
#endif
