/* Copyright 2020-2022 The MathWorks, Inc. */

#ifndef MW_ARMNEON_INPUT_LAYER_IMPL
#define MW_ARMNEON_INPUT_LAYER_IMPL

#include "MWArmneonCNNLayerImpl.hpp"

class MWCNNLayer;
namespace MWArmneonTarget {
class MWTargetNetworkImpl;

class MWInputLayerImpl final : public MWCNNLayerImpl {

  private:
    void predict();
    void propagateSize(){};

    void cleanup() {
    }

  public:
    MWInputLayerImpl(MWCNNLayer* layer, MWTargetNetworkImpl* ntwk_impl);
    ~MWInputLayerImpl() {
    }
};
} // namespace MWArmneonTarget
#endif
