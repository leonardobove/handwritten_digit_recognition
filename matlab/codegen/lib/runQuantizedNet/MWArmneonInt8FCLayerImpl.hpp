/* Copyright 2020-2022 The MathWorks, Inc. */

#ifndef MW_ARMNEON_INT8_FC_LAYER_IMPL
#define MW_ARMNEON_INT8_FC_LAYER_IMPL

#include "MWArmneonCNNLayerImpl.hpp"

#include <arm_neon.h>
#include <memory>
#include <vector>

class MWCNNLayer;
namespace MWArmneonTarget {
class MWTargetNetworkImpl;

// INT8FullyConnectedLayer
template <typename T1, typename T2>
class MWInt8FCLayerImpl final : public MWCNNLayerImpl {
  private:
    std::unique_ptr<arm_compute::NEFullyConnectedLayer> m_fcLayer;
    std::unique_ptr<arm_compute::NEReshapeLayer> mReshapeLayer;
    arm_compute::Tensor m_fcLayerWgtTensor;
    arm_compute::Tensor m_fcLayerBiasTensor;
    arm_compute::Tensor mFcLayerIntermOpTensor;
    signed char* unSXtdjDjpysqxmbIiPv;
    signed int* KHjdvykTFbUxdfZTFbqy;
    bool isWgtsPadded = false;
    bool isBiasPadded = false;

    void loadWeights(const char*, int);
    void loadBias(const char*, int);
    void prepareWeights(signed char*);
    void propagateSize();
    void predict();
    void cleanup();
    void allocate();
    void deallocate();

  public:
    MWInt8FCLayerImpl(MWCNNLayer*, MWTargetNetworkImpl*, int, int, const char*, const char*, int);
    ~MWInt8FCLayerImpl();
};
} // namespace MWArmneonTarget
#endif
