/* Copyright 2018-2022 The MathWorks, Inc. */

#ifndef MW_ARMNEON_BFPRESCALE_LAYER_IMPL
#define MW_ARMNEON_BFPRESCALE_LAYER_IMPL

#include "MWArmneonCNNLayerImpl.hpp"

/**
 *  Codegen class for Exponential layer
 **/
class MWCNNLayer;
namespace MWArmneonTarget {
class MWTargetNetworkImpl;
class MWBfpRescaleLayerImpl final : public MWCNNLayerImpl {
  public:
    MWBfpRescaleLayerImpl(MWCNNLayer*, MWTargetNetworkImpl*);
    ~MWBfpRescaleLayerImpl();

    void propagateSize(){};
    void predict();
};

} // namespace MWArmneonTarget

#endif
