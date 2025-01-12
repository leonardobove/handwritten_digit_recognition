/* Copyright 2018-2022 The MathWorks, Inc. */

#include "MWBfpRescaleLayer.hpp"
#include "MWCNNLayerImplBase.hpp"
#include "MWTensorBase.hpp"
#include "MWCNNLayer.hpp"
#include "MWTargetNetworkImplBase.hpp"
#include "MWLayerImplFactory.hpp"

void MWBfpRescaleLayer::createBfpRescaleLayer(MWTargetNetworkImplBase* ntwk_impl,
                                              MWTensorBase* dataInput,
                                              int scalingExponent,
                                              const char* outFormat,
                                              int outbufIdx) {
    setInputTensor(dataInput);
    allocateOutputTensor<float>(-1, -1, -1, -1, -1, NULL, outFormat);

    getOutputTensor(0)->setopBufIndex(outbufIdx);

    setScalingExponent(scalingExponent);

    MWLayerImplFactory* factory = ntwk_impl->getLayerImplFactory();
    m_impl = factory->createBfpRescaleLayerImpl(this, ntwk_impl);
}

void MWBfpRescaleLayer::propagateSize() {
    resizeOutputTensor(getInputTensor()->getHeight(), getInputTensor()->getWidth(),
                       getInputTensor()->getChannels(), getInputTensor()->getBatchSize(),
                       getInputTensor()->getSequenceLength());

    m_impl->propagateSize();
}
