function generateMdlWebView(modelName)
myProject       = matlab.project.currentProject;
projectRoot     = myProject.RootFolder;
load(fullfile(projectRoot.char, 'Code', 'logsPath.mat'), 'path');
parentFolder = fullfile(projectRoot.char, 'Design', modelName, 'pipeline', 'analyze');
if ~exist(fullfile(parentFolder, 'review'), 'dir')
  mkdir([parentFolder, '\review']);
end

if ~bdIsLoaded(modelName)
    load_system(modelName);
end
mdl_webview = slwebview(modelName,...
    'SearchScope','All',...
    'PackageName', modelName,...
    'PackageFolder', fullfile(parentFolder, 'review'),...
    'PackagingType', 'unzipped',...
    'ViewFile', false,...
    'ShowProgressBar', false);
end