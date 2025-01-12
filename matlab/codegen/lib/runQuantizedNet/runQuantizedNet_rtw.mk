###########################################################################
## Makefile generated for component 'runQuantizedNet'. 
## 
## Makefile     : runQuantizedNet_rtw.mk
## Generated on : Mon Jan 13 00:37:53 2025
## Final product: .\runQuantizedNet.lib
## Product type : static-library
## 
###########################################################################

###########################################################################
## MACROS
###########################################################################

# Macro Descriptions:
# PRODUCT_NAME            Name of the system to build
# MAKEFILE                Name of this makefile
# COMPILER_COMMAND_FILE   Compiler command listing model reference header paths
# CMD_FILE                Command file
# MODELLIB                Static library target

PRODUCT_NAME              = runQuantizedNet
MAKEFILE                  = runQuantizedNet_rtw.mk
MATLAB_ROOT               = C:\PROGRA~1\MATLAB\R2023b
MATLAB_BIN                = C:\PROGRA~1\MATLAB\R2023b\bin
MATLAB_ARCH_BIN           = $(MATLAB_BIN)\win64
START_DIR                 = C:\Users\leona\Desktop\PSD\handwritten_digit_recognition\matlab
TGT_FCN_LIB               = ISO_C++11
SOLVER_OBJ                = 
CLASSIC_INTERFACE         = 0
MODEL_HAS_DYNAMICALLY_LOADED_SFCNS = 
RELATIVE_PATH_TO_ANCHOR   = ..\..\..
override START_DIR        = .
COMPILER_COMMAND_FILE     = runQuantizedNet_rtw_comp.rsp
CMD_FILE                  = runQuantizedNet_rtw.rsp
C_STANDARD_OPTS           = 
CPP_STANDARD_OPTS         = 
NODEBUG                   = 1
MODELLIB                  = runQuantizedNet.lib

###########################################################################
## TOOLCHAIN SPECIFICATIONS
###########################################################################

# Toolchain Name:          Microsoft Visual C++ 2022 v17.0 | nmake (64-bit Windows)
# Supported Version(s):    17.0
# ToolchainInfo Version:   2023b
# Specification Revision:  1.0
# 
#-------------------------------------------
# Macros assumed to be defined elsewhere
#-------------------------------------------

# NODEBUG
# cvarsdll
# cvarsmt
# conlibsmt
# ldebug
# conflags
# cflags

#-----------
# MACROS
#-----------

MW_EXTERNLIB_DIR    = $(MATLAB_ROOT)\extern\lib\win64\microsoft
MW_LIB_DIR          = $(MATLAB_ROOT)\lib\win64
CPU                 = AMD64
APPVER              = 5.02
CVARSFLAG           = $(cvarsmt)
CFLAGS_ADDITIONAL   = -D_CRT_SECURE_NO_WARNINGS
CPPFLAGS_ADDITIONAL = -EHs -D_CRT_SECURE_NO_WARNINGS /wd4251 /Zc:__cplusplus
LIBS_TOOLCHAIN      = $(conlibs)

TOOLCHAIN_SRCS = 
TOOLCHAIN_INCS = 
TOOLCHAIN_LIBS = 

#------------------------
# BUILD TOOL COMMANDS
#------------------------

# C Compiler: Microsoft Visual C Compiler
CC = cl

# Linker: Microsoft Visual C Linker
LD = link

# C++ Compiler: Microsoft Visual C++ Compiler
CPP = cl

# C++ Linker: Microsoft Visual C++ Linker
CPP_LD = link

# Archiver: Microsoft Visual C/C++ Archiver
AR = lib

# MEX Tool: MEX Tool
MEX_PATH = $(MATLAB_ARCH_BIN)
MEX = "$(MEX_PATH)\mex"

# Download: Download
DOWNLOAD =

# Execute: Execute
EXECUTE = $(PRODUCT)

# Builder: NMAKE Utility
MAKE = nmake


#-------------------------
# Directives/Utilities
#-------------------------

CDEBUG              = -Zi
C_OUTPUT_FLAG       = -Fo
LDDEBUG             = /DEBUG
OUTPUT_FLAG         = -out:
CPPDEBUG            = -Zi
CPP_OUTPUT_FLAG     = -Fo
CPPLDDEBUG          = /DEBUG
OUTPUT_FLAG         = -out:
ARDEBUG             =
STATICLIB_OUTPUT_FLAG = -out:
MEX_DEBUG           = -g
RM                  = @del
ECHO                = @echo
MV                  = @ren
RUN                 = @cmd /C

#--------------------------------------
# "Faster Runs" Build Configuration
#--------------------------------------

ARFLAGS              = /nologo
CFLAGS               = $(cflags) $(CVARSFLAG) $(CFLAGS_ADDITIONAL) \
                       /O2 /Oy-
CPPFLAGS             = /TP $(cflags) $(CVARSFLAG) $(CPPFLAGS_ADDITIONAL) \
                       /O2 /Oy-
CPP_LDFLAGS          = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN)
CPP_SHAREDLIB_LDFLAGS  = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN) \
                         -dll -def:$(DEF_FILE)
DOWNLOAD_FLAGS       =
EXECUTE_FLAGS        =
LDFLAGS              = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN)
MEX_CPPFLAGS         =
MEX_CPPLDFLAGS       =
MEX_CFLAGS           =
MEX_LDFLAGS          =
MAKE_FLAGS           = -f $(MAKEFILE)
SHAREDLIB_LDFLAGS    = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN) \
                       -dll -def:$(DEF_FILE)



###########################################################################
## OUTPUT INFO
###########################################################################

PRODUCT = .\runQuantizedNet.lib
PRODUCT_TYPE = "static-library"
BUILD_TYPE = "Static Library"

###########################################################################
## INCLUDE PATHS
###########################################################################

INCLUDES_BUILDINFO = 

INCLUDES = $(INCLUDES_BUILDINFO)

###########################################################################
## DEFINES
###########################################################################

DEFINES_ = -DUSE_20_02_1_LIBRARY
DEFINES_CUSTOM = 
DEFINES_STANDARD = -DMODEL=runQuantizedNet

DEFINES = $(DEFINES_) $(DEFINES_CUSTOM) $(DEFINES_STANDARD)

###########################################################################
## SOURCE FILES
###########################################################################

SRCS = $(START_DIR)\codegen\lib\runQuantizedNet\MWBfpRescaleLayer.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWBfpScaleLayer.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWCNNLayer.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWInputLayer.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWOutputLayer.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWSigmoidLayer.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWTensorBase.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonBfpRescaleLayerImpl.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonBfpScaleLayerImpl.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonInputLayerImpl.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonInt8FCLayerImpl.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonOutputLayerImpl.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonSigmoidLayerImpl.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonCNNLayerImpl.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonTargetNetworkImpl.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonLayerImplFactory.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWACLUtils.cpp $(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonCustomLayerBase.cpp $(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet_data.cpp $(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet_initialize.cpp $(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet_terminate.cpp $(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet.cpp $(START_DIR)\codegen\lib\runQuantizedNet\dlnetwork.cpp $(START_DIR)\codegen\lib\runQuantizedNet\predict.cpp

ALL_SRCS = $(SRCS)

###########################################################################
## OBJECTS
###########################################################################

OBJS = MWBfpRescaleLayer.obj MWBfpScaleLayer.obj MWCNNLayer.obj MWInputLayer.obj MWOutputLayer.obj MWSigmoidLayer.obj MWTensorBase.obj MWArmneonBfpRescaleLayerImpl.obj MWArmneonBfpScaleLayerImpl.obj MWArmneonInputLayerImpl.obj MWArmneonInt8FCLayerImpl.obj MWArmneonOutputLayerImpl.obj MWArmneonSigmoidLayerImpl.obj MWArmneonCNNLayerImpl.obj MWArmneonTargetNetworkImpl.obj MWArmneonLayerImplFactory.obj MWACLUtils.obj MWArmneonCustomLayerBase.obj runQuantizedNet_data.obj runQuantizedNet_initialize.obj runQuantizedNet_terminate.obj runQuantizedNet.obj dlnetwork.obj predict.obj

ALL_OBJS = $(OBJS)

###########################################################################
## PREBUILT OBJECT FILES
###########################################################################

PREBUILT_OBJS = 

###########################################################################
## LIBRARIES
###########################################################################

LIBS = 

###########################################################################
## SYSTEM LIBRARIES
###########################################################################

SYSTEM_LIBS = 

###########################################################################
## ADDITIONAL TOOLCHAIN FLAGS
###########################################################################

#---------------
# C Compiler
#---------------

CFLAGS_ =  -std=c++11  -fopenmp /source-charset:utf-8
CFLAGS_BASIC = $(DEFINES) @$(COMPILER_COMMAND_FILE)

CFLAGS = $(CFLAGS) $(CFLAGS_) $(CFLAGS_BASIC)

#-----------------
# C++ Compiler
#-----------------

CPPFLAGS_ =  -std=c++11  -fopenmp /source-charset:utf-8
CPPFLAGS_BASIC = $(DEFINES) @$(COMPILER_COMMAND_FILE)

CPPFLAGS = $(CPPFLAGS) $(CPPFLAGS_) $(CPPFLAGS_BASIC)

#---------------
# C++ Linker
#---------------

CPP_LDFLAGS_ = -L"$(ARM_COMPUTELIB)/lib" -rdynamic -larm_compute -larm_compute_core -Wl,-rpath,"$(ARM_COMPUTELIB)/lib":-L"$(ARM_COMPUTELIB)/lib"  -fopenmp

CPP_LDFLAGS = $(CPP_LDFLAGS) $(CPP_LDFLAGS_)

#------------------------------
# C++ Shared Library Linker
#------------------------------

CPP_SHAREDLIB_LDFLAGS_ = -L"$(ARM_COMPUTELIB)/lib" -rdynamic -larm_compute -larm_compute_core -Wl,-rpath,"$(ARM_COMPUTELIB)/lib":-L"$(ARM_COMPUTELIB)/lib"  -fopenmp

CPP_SHAREDLIB_LDFLAGS = $(CPP_SHAREDLIB_LDFLAGS) $(CPP_SHAREDLIB_LDFLAGS_)

#-----------
# Linker
#-----------

LDFLAGS_ = -L"$(ARM_COMPUTELIB)/lib" -rdynamic -larm_compute -larm_compute_core -Wl,-rpath,"$(ARM_COMPUTELIB)/lib":-L"$(ARM_COMPUTELIB)/lib"  -fopenmp

LDFLAGS = $(LDFLAGS) $(LDFLAGS_)

#--------------------------
# Shared Library Linker
#--------------------------

SHAREDLIB_LDFLAGS_ = -L"$(ARM_COMPUTELIB)/lib" -rdynamic -larm_compute -larm_compute_core -Wl,-rpath,"$(ARM_COMPUTELIB)/lib":-L"$(ARM_COMPUTELIB)/lib"  -fopenmp

SHAREDLIB_LDFLAGS = $(SHAREDLIB_LDFLAGS) $(SHAREDLIB_LDFLAGS_)

###########################################################################
## INLINED COMMANDS
###########################################################################


!include $(MATLAB_ROOT)\rtw\c\tools\vcdefs.mak


###########################################################################
## PHONY TARGETS
###########################################################################

.PHONY : all build clean info prebuild download execute set_environment_variables


all : build
	@cmd /C "@echo ### Successfully generated all binary outputs."


build : set_environment_variables prebuild $(PRODUCT)


prebuild : 


download : $(PRODUCT)


execute : download


set_environment_variables : 
	@set INCLUDE=$(INCLUDES);$(INCLUDE)
	@set LIB=$(LIB)


###########################################################################
## FINAL TARGET
###########################################################################

#---------------------------------
# Create a static library         
#---------------------------------

$(PRODUCT) : $(OBJS) $(PREBUILT_OBJS)
	@cmd /C "@echo ### Creating static library "$(PRODUCT)" ..."
	$(AR) $(ARFLAGS) -out:$(PRODUCT) @$(CMD_FILE)
	@cmd /C "@echo ### Created: $(PRODUCT)"


###########################################################################
## INTERMEDIATE TARGETS
###########################################################################

#---------------------
# SOURCE-TO-OBJECT
#---------------------

.c.obj :
	$(CC) $(CFLAGS) -Fo"$@" "$<"


.cpp.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


.cc.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


.cxx.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.c.obj :
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.cpp.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.cc.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.cxx.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)\codegen\lib\runQuantizedNet}.c.obj :
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(START_DIR)\codegen\lib\runQuantizedNet}.cpp.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)\codegen\lib\runQuantizedNet}.cc.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)\codegen\lib\runQuantizedNet}.cxx.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.c.obj :
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.cpp.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.cc.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.cxx.obj :
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


MWBfpRescaleLayer.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWBfpRescaleLayer.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWBfpRescaleLayer.cpp"


MWBfpScaleLayer.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWBfpScaleLayer.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWBfpScaleLayer.cpp"


MWCNNLayer.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWCNNLayer.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWCNNLayer.cpp"


MWInputLayer.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWInputLayer.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWInputLayer.cpp"


MWOutputLayer.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWOutputLayer.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWOutputLayer.cpp"


MWSigmoidLayer.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWSigmoidLayer.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWSigmoidLayer.cpp"


MWTensorBase.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWTensorBase.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWTensorBase.cpp"


MWArmneonBfpRescaleLayerImpl.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonBfpRescaleLayerImpl.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonBfpRescaleLayerImpl.cpp"


MWArmneonBfpScaleLayerImpl.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonBfpScaleLayerImpl.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonBfpScaleLayerImpl.cpp"


MWArmneonInputLayerImpl.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonInputLayerImpl.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonInputLayerImpl.cpp"


MWArmneonInt8FCLayerImpl.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonInt8FCLayerImpl.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonInt8FCLayerImpl.cpp"


MWArmneonOutputLayerImpl.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonOutputLayerImpl.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonOutputLayerImpl.cpp"


MWArmneonSigmoidLayerImpl.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonSigmoidLayerImpl.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonSigmoidLayerImpl.cpp"


MWArmneonCNNLayerImpl.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonCNNLayerImpl.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonCNNLayerImpl.cpp"


MWArmneonTargetNetworkImpl.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonTargetNetworkImpl.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonTargetNetworkImpl.cpp"


MWArmneonLayerImplFactory.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonLayerImplFactory.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonLayerImplFactory.cpp"


MWACLUtils.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWACLUtils.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWACLUtils.cpp"


MWArmneonCustomLayerBase.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonCustomLayerBase.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\MWArmneonCustomLayerBase.cpp"


runQuantizedNet_data.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet_data.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet_data.cpp"


runQuantizedNet_initialize.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet_initialize.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet_initialize.cpp"


runQuantizedNet_terminate.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet_terminate.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet_terminate.cpp"


runQuantizedNet.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\runQuantizedNet.cpp"


dlnetwork.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\dlnetwork.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\dlnetwork.cpp"


predict.obj : "$(START_DIR)\codegen\lib\runQuantizedNet\predict.cpp"
	$(CPP) $(CPPFLAGS) -Fo"$@" "$(START_DIR)\codegen\lib\runQuantizedNet\predict.cpp"


###########################################################################
## DEPENDENCIES
###########################################################################

$(ALL_OBJS) : rtw_proj.tmw $(COMPILER_COMMAND_FILE) $(MAKEFILE)


###########################################################################
## MISCELLANEOUS TARGETS
###########################################################################

info : 
	@cmd /C "@echo ### PRODUCT = $(PRODUCT)"
	@cmd /C "@echo ### PRODUCT_TYPE = $(PRODUCT_TYPE)"
	@cmd /C "@echo ### BUILD_TYPE = $(BUILD_TYPE)"
	@cmd /C "@echo ### INCLUDES = $(INCLUDES)"
	@cmd /C "@echo ### DEFINES = $(DEFINES)"
	@cmd /C "@echo ### ALL_SRCS = $(ALL_SRCS)"
	@cmd /C "@echo ### ALL_OBJS = $(ALL_OBJS)"
	@cmd /C "@echo ### LIBS = $(LIBS)"
	@cmd /C "@echo ### MODELREF_LIBS = $(MODELREF_LIBS)"
	@cmd /C "@echo ### SYSTEM_LIBS = $(SYSTEM_LIBS)"
	@cmd /C "@echo ### TOOLCHAIN_LIBS = $(TOOLCHAIN_LIBS)"
	@cmd /C "@echo ### CFLAGS = $(CFLAGS)"
	@cmd /C "@echo ### LDFLAGS = $(LDFLAGS)"
	@cmd /C "@echo ### SHAREDLIB_LDFLAGS = $(SHAREDLIB_LDFLAGS)"
	@cmd /C "@echo ### CPPFLAGS = $(CPPFLAGS)"
	@cmd /C "@echo ### CPP_LDFLAGS = $(CPP_LDFLAGS)"
	@cmd /C "@echo ### CPP_SHAREDLIB_LDFLAGS = $(CPP_SHAREDLIB_LDFLAGS)"
	@cmd /C "@echo ### ARFLAGS = $(ARFLAGS)"
	@cmd /C "@echo ### MEX_CFLAGS = $(MEX_CFLAGS)"
	@cmd /C "@echo ### MEX_CPPFLAGS = $(MEX_CPPFLAGS)"
	@cmd /C "@echo ### MEX_LDFLAGS = $(MEX_LDFLAGS)"
	@cmd /C "@echo ### MEX_CPPLDFLAGS = $(MEX_CPPLDFLAGS)"
	@cmd /C "@echo ### DOWNLOAD_FLAGS = $(DOWNLOAD_FLAGS)"
	@cmd /C "@echo ### EXECUTE_FLAGS = $(EXECUTE_FLAGS)"
	@cmd /C "@echo ### MAKE_FLAGS = $(MAKE_FLAGS)"


clean : 
	$(ECHO) "### Deleting all derived files ..."
	@if exist $(PRODUCT) $(RM) $(PRODUCT)
	$(RM) $(ALL_OBJS)
	$(ECHO) "### Deleted all derived files."


