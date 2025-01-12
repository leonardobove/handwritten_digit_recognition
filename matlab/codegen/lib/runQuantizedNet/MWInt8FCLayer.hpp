/* Copyright 2020-2022 The MathWorks, Inc. */
#ifndef MW_INT8_FC_LAYER
#define MW_INT8_FC_LAYER

#include "MWCNNLayerImplBase.hpp"
#include "MWInt8FCLayer.hpp"
#include "MWTensorBase.hpp"
#include "MWCNNLayer.hpp"
#include "MWTargetNetworkImplBase.hpp"
#include "MWLayerImplFactory.hpp"
#include <vector>

class MWTargetNetworkImplBase;
class MWTensorBase;

// FullyConnectedLayer
template <typename T1, typename T2, typename FACTORYTYPE>
class MWInt8FCLayer : public MWCNNLayer {
  public:
    MWInt8FCLayer() {}
    ~MWInt8FCLayer() {}

    void createInt8FCLayer(MWTargetNetworkImplBase* ntwk_impl,
                           MWTensorBase* m_in,
                           int m_InputSize,
                           int m_OutputSize,
                           const char* m_weights_file,
                           const char* m_bias_file,
                           const char* m_accelerationMode,
                           int m_scalingFactorAlpha1,
                           int m_weightsScalingFactorAlpha2,
                           const char* m_outFormat,
                           int outbufIdx) {
        numOutputFeatures = m_OutputSize;

        setAccelMode(m_accelerationMode);
        setScalingExponent(m_scalingFactorAlpha1);

        setInputTensor(m_in);

        allocateOutputTensor<T2>(-1, -1, -1, -1, -1, NULL, m_outFormat);

        getOutputTensor(0)->setopBufIndex(outbufIdx);

        MWLayerImplFactory* factory = ntwk_impl->getLayerImplFactory();

        m_impl = static_cast<FACTORYTYPE*>(factory)->template createInt8FCLayerImpl<T1, T2>(
            this, ntwk_impl, m_InputSize, m_OutputSize, m_weights_file, m_bias_file,
            m_weightsScalingFactorAlpha2);
    }

    void propagateSize() {
        resizeOutputTensor(1, 1, numOutputFeatures, getInputTensor()->getBatchSize(),
                           getInputTensor()->getSequenceLength());

        m_impl->propagateSize();
    }

    void setLearnables(std::vector<float*>) {}

  private:
    int numOutputFeatures;
};

#endif
