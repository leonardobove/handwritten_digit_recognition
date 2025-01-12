/* Copyright 2018-2022 The MathWorks, Inc. */

#ifndef MW_BFP_RESCALE_LAYER
#define MW_BFP_RESCALE_LAYER

#include "MWCNNLayer.hpp"

#include "shared_layers_export_macros.hpp"

class MWTargetNetworkImplBase;
class MWTensorBase;

/**
 *  Converts tensor data from int8 to fp32
 **/
class DLCODER_EXPORT_CLASS MWBfpRescaleLayer : public MWCNNLayer {
  public:
    MWBfpRescaleLayer() {}
    ~MWBfpRescaleLayer() {}

    void createBfpRescaleLayer(MWTargetNetworkImplBase*, MWTensorBase*, int, const char*, int);
    void propagateSize();
};

#endif
