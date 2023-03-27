function runBuild(mdlname)
% Copyright 2021 The MathWorks, Inc.
mb = modelBuildAction(mdlname); 
mb.build();