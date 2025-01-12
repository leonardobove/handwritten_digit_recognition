function generateCode()
% This functions generates C code from the quantized neural network

% Create a deep learning configuration object dlconfig that is configured
% for generating generic C/C++ code by using the coder
dlconfig = coder.DeepLearningConfig('arm-compute');
dlconfig.ArmArchitecture = 'armv8';
dlconfig.DataType = 'int8';
dlconfig.CalibrationResultFile = 'quantobj.mat';

cfg = coder.config('lib');
cfg.TargetLang = 'C';
cfg.DeepLearningConfig = dlconfig;

%cfg = coder.config('lib');
%cfg.TargetLang = 'C++';
%cfg.GenCodeOnly=true;
%dlcfg = coder.DeepLearningConfig('arm-compute');
%dlcfg.ArmArchitecture = 'armv8';
%dlcfg.ArmComputeVersion = '20.02.1';
%dlcfg.DataType = 'int8';
%dlcfg.CalibrationResultFile = 'quantobj.mat';
%cfg.DeepLearningConfig = dlcfg;


% Generate C code
codegen -config cfg runQuantizedNet -args {ones(196, 1, 'single')} -report

end