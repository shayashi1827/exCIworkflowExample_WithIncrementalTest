function runModelAdvisor(mdlname)
% Copyright 2021 The MathWorks, Inc.
ma = modelAdvisorAction(mdlname); 
ma.configFile = '../Utility/config_data/iso26262Checks.json';
ma =  ma.run();
ma.generateReport();