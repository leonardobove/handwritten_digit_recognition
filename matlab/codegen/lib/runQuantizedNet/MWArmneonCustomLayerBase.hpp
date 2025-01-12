/* Copyright 2019-2022 The MathWorks, Inc. */

// ARMNEON specific header for Custom Layer Base Class
#ifndef MW_ARMNEON_CUSTOM_LAYER_BASE
#define MW_ARMNEON_CUSTOM_LAYER_BASE

#include "MWCNNLayer.hpp"
#include <map>

namespace MWArmneonTarget {
class MWTargetNetworkImpl;
}
class MWTensorBase;

class MWArmneonCustomLayerBase : public MWCNNLayer {

  public:
    MWArmneonCustomLayerBase();
    ~MWArmneonCustomLayerBase();

    MWArmneonTarget::MWTargetNetworkImpl* m_ntwkImpl;

    void allocate();
    void deallocate();
    void cleanup();

  protected:
    void setupLayer(MWArmneonTarget::MWTargetNetworkImpl*);

    // reorder data to between SNCHW <--> SNCWH or SNCHW <--> SNHWC
    void reorderData(MWTensorBase* aTensor,
                     int bufIndex,
                     MWTensorBase::DIMSLABEL sourceLayout[],
                     MWTensorBase::DIMSLABEL targetLayout[],
                     bool isInputReorder);

    void prepareUnpaddedIpData();

    virtual void cleanupLayer(){};

    void setUnpaddedIpData(MWTensorBase* aTensor, float* bufPtr);
    float* getUnpaddedIpData(MWTensorBase* aTensor);
    void allocateOutputData(int);
    void allocateInputData(int);

    bool isSharedIpArmTensorData(MWTensorBase* aTensor);

  private:
    std::map<MWTensorBase*, float*> YMNbgnUYZspjMLjwcIOS;
};

#endif
