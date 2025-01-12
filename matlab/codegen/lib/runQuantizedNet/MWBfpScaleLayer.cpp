/* Copyright 2018-2022 The MathWorks, Inc. */

#include "MWBfpScaleLayer.hpp"
#include "MWCNNLayerImplBase.hpp"
#include "MWTensorBase.hpp"
#include "MWCNNLayer.hpp"
#include "MWTargetNetworkImplBase.hpp"
#include "MWLayerImplFactory.hpp"

void MWBfpScaleLayer::createBfpScaleLayer(MWTargetNetworkImplBase* ntwk_impl,
                                          MWTensorBase* dataInput,
                                          int scalingExponent,
                                          bool roundingMode,
                                          const char* outFormat,
                                          int outbufIdx) {
    setInputTensor(dataInput);
    allocateOutputTensor<signed char>(-1, -1, -1, -1, -1, NULL, outFormat);

    getOutputTensor(0)->setopBufIndex(outbufIdx);
    setScalingExponent(scalingExponent);

    MWLayerImplFactory* factory = ntwk_impl->getLayerImplFactory();
    m_impl = factory->createBfpScaleLayerImpl(this, ntwk_impl, roundingMode);
}

void MWBfpScaleLayer::propagateSize() {
    resizeOutputTensor(getInputTensor()->getHeight(), getInputTensor()->getWidth(),
                       getInputTensor()->getChannels(), getInputTensor()->getBatchSize(),
                       getInputTensor()->getSequenceLength());

    m_impl->propagateSize();
}
