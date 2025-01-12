/* Copyright 2019-2022 The MathWorks, Inc. */

// SigmoidLayer
#ifndef MW_ARMNEON_SIGMOID_LAYER_IMPL
#define MW_ARMNEON_SIGMOID_LAYER_IMPL
#define ARMCOMPUTE_SIGMOID 0

#include "MWArmneonCNNLayerImpl.hpp"

#include <arm_neon.h>
#include <memory>

class MWCNNLayer;
namespace MWArmneonTarget {
class MWTargetNetworkImpl;

#if MW_SIGMOID_TAP
extern void mw_interm_tap(arm_compute::Tensor& armTensor, int size, int count);
extern void mw_interm_tap(float* memBuf, int size, int count);
extern int tap_count;
#endif

class MWSigmoidLayerImpl final : public MWCNNLayerImpl {
  private:
    std::unique_ptr<arm_compute::NEActivationLayer> m_actLayer;
    void propagateSize();
    void predict();

  public:
    MWSigmoidLayerImpl(MWCNNLayer*, MWTargetNetworkImpl*);
    ~MWSigmoidLayerImpl();
};
} // namespace MWArmneonTarget
#endif
