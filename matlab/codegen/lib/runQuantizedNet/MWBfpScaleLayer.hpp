/* Copyright 2018-2022 The MathWorks, Inc. */

#ifndef MW_BFP_SCALE_LAYER
#define MW_BFP_SCALE_LAYER

#include "MWCNNLayer.hpp"

#include "shared_layers_export_macros.hpp"

class MWTargetNetworkImplBase;
class MWTensorBase;

/**
 *  Converts tensor data from fp32 to int8
 **/
class DLCODER_EXPORT_CLASS MWBfpScaleLayer : public MWCNNLayer {
  public:
    MWBfpScaleLayer() {}
    ~MWBfpScaleLayer() {}

    void createBfpScaleLayer(MWTargetNetworkImplBase*, MWTensorBase*, int, bool, const char*, int);
    void propagateSize();
};

#endif
