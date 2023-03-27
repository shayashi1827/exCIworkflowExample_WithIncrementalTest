function runDesignErrorDetection(mdlname)
% Copyright 2021 The MathWorks, Inc.
ded = modelDEDAction(mdlname); 
ded =  ded.run();
ded.dispResults();