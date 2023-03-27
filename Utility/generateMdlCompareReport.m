function generateMdlCompareReport(modelName_src, modelName_dest)
myProject       = matlab.project.currentProject;
projectRoot     = myProject.RootFolder;
load(fullfile(projectRoot.char, 'Code', 'logsPath.mat'), 'path');
parentFolder = fullfile(projectRoot.char, 'Design', modelName_src, 'pipeline', 'analyze');
if ~exist(fullfile(parentFolder, 'review'), 'dir')
  mkdir([parentFolder, '\review']);
end

comp = visdiff(modelName_src, modelName_dest);
filter(comp, 'default');
opt = struct(...
    'Format', 'html',...
    'Name', [modelName_src, '_Compare'],...
    'outputFolder', fullfile(parentFolder, 'review'));
file = publish(comp, opt);
end