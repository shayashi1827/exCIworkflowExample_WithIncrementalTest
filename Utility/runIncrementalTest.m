function runIncrementalTest(mdlname)
% プロジェクト取得
proj = matlab.project.currentProject;

% 初期化
bdclose all;
sltest.testmanager.clear;
sltest.testmanager.clearResults;

%% ----- テストケースの絞り込み ----- %%    
% 前回コミット時の成果物取得
[~, cBranch] = system('git branch --show-current');
comMdlName = extractLastArtifacts(strtrim(cBranch), mdlname, false);

% モデルの差分取得
[diffSSList,~]= DetectUpdatedSubsystems(comMdlName, mdlname);
if(isempty(diffSSList))
    disp('更新が見つかりませんでした');
else
    % 要件の差分取得(option)

    % 差分が合致するテストケースの特定
    testfileName = ['Test_', mdlname];      % テストファイル名："Test_モデル名"
    tfobj = sltest.testmanager.load(testfileName);
    tcobjList = getDiffTestcases(tfobj, diffSSList);

    %% ----- テストケース実行及びレポート生成 ----- %%
    resultDir = fullfile(proj.RootFolder, 'Test_Results');
    runTestAndExportResults(mdlname, resultDir, tcobjList, tfobj)
end    
end