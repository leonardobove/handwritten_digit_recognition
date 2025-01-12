/* Copyright 2017-2022 The MathWorks, Inc. */
#ifndef MW_ARMNEON_CNN_TARGET_NTWK_IMPL
#define MW_ARMNEON_CNN_TARGET_NTWK_IMPL

#include "MWTargetNetworkImplBase.hpp"

#include <cstdio>
#include <cstdlib>
#include <vector>
#include <memory>

class MWCNNLayer;
class MWTensorBase;

namespace MWArmneonTarget {
#define MW_ALLOCATE_MEMORY_BUFFER()                           \
    {                                                         \
        uint8_t* memPtr;                                      \
        memPtr = (uint8_t*)calloc(maxBufSize, sizeof(float)); \
        memBuffer.push_back(memPtr);                          \
    }
#define MW_FREE_MEMORY_BUFFER()         \
    {                                   \
        uint8_t* memPtr = memBuffer[i]; \
        free(memPtr);                   \
    }

#define MW_FREE_BUFFER_MEMORY(mem_Ptr) \
    {                                  \
        if (mem_Ptr) {                 \
            free(mem_Ptr);             \
            mem_Ptr = nullptr;         \
        }                              \
    }
#define MW_GET_BUFFER(mem_ptr) mem_ptr
#define MW_CREATE_BUFFER(size) (float*)malloc(size * sizeof(float))
#define MW_CREATE_BUFFER_INT8(size) (signed char*)malloc(size * sizeof(signed char))
#define MW_CREATE_BUFFER_INT32(size) (signed int*)malloc(size * sizeof(signed int))

class MWTargetNetworkImpl final : public MWTargetNetworkImplBase {
  public:
    MWTargetNetworkImpl();
    ~MWTargetNetworkImpl() {
    }
    void allocate(int, MWCNNLayer* layers[], int numLayers, int maxCustomLayerBufSize);
    void deallocate() override;
    void preSetup() override {
    }
    void postSetup() {
    }

    void setWorkSpaceSize(size_t); // Set the workspace size of this layer and previous layers
    size_t* getWorkSpaceSize();    // Get the workspace size of this layer and previous layers
    float* getWorkSpace();         // Get the workspace buffer in GPU memory
    void cleanup() override {
    }
    void createWorkSpace(float**); // Create the workspace needed for this layer
    float* getLayerOutput(MWCNNLayer* layers[], int layerIndex, int portIndex);
    float* getLayerActivation(MWTensorBase*);
    size_t maxBufSize;

    std::vector<uint8_t*> memBuffer;

    float* getPermuteBuffer(int index); // Get the buffer for custom layers' data layout permutation
    void allocatePermuteBuffers(int,
                                int); // allocate buffer for custom layers' data layout permutation

  private:
    std::vector<float*> npaEYSaGsfCvAUhwdtLe;
};
} // namespace MWArmneonTarget
#endif
