% Copyright 2021 The MathWorks, Inc.

% RUNALLTESTSLOCALLY
% This file is used to run selected project items locally.
% All the different scripts which are run in the CI pipeline can be run
% locally by using this script

%% crs_controller
% verify
runModelAdvisor('DoorLockCntr');
runDesignErrorDetection('DoorLockCntr');

% test
runTestFile('DoorLockCntr');

% build
runBuild('DoorLockCntr');

