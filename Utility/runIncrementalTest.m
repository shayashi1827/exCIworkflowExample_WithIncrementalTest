function runIncrementalTest(mdlname)
% 前回コミットとのモデル差分を抽出し、対応するテストケースのみ用いた差分テストを実行する
% ローカル用

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
    % 差分が合致するテストケースの特定
    testfileName = ['Test_', mdlname];      % テストファイル名："Test_モデル名"
    tfobj = sltest.testmanager.load(testfileName);
    tcobjList = getDiffTestcases(tfobj, diffSSList);
     if(isempty(tcobjList))
         disp('差分に対応するテストケースが見つかりませんでした');
     else
        %% ----- テストケース実行及びレポート生成 ----- %%
        resultDir = fullfile(proj.RootFolder, 'Test_Results');
        if ~exist(resultDir, 'dir')
            mkdir(resultDir);
        end
        runTestAndExportResults(mdlname, resultDir, tcobjList, tfobj);
     end 
end

% 過去のモデルを削除
delete(which(comMdlName));

end

