/* Copyright 2020-2022 The MathWorks, Inc. */

#ifndef MW_ARMNEON_OUTPUT_LAYER_IMPL
#define MW_ARMNEON_OUTPUT_LAYER_IMPL

#include "MWArmneonCNNLayerImpl.hpp"

class MWCNNLayer;
namespace MWArmneonTarget {
class MWTargetNetworkImpl;

class MWOutputLayerImpl final : public MWCNNLayerImpl {
  private:
    void propagateSize(){};
    void predict();

  public:
    MWOutputLayerImpl(MWCNNLayer*, MWTargetNetworkImpl*);
    ~MWOutputLayerImpl();
};
} // namespace MWArmneonTarget
#endif
