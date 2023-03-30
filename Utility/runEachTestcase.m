function runEachTestcase(mdlname)
% RUNEACHTESTCASE テストファイル中の個々のテストケースを実行し、結果を保存します
% 現在の状態にかかわらず個々のテストケースを実行して結果を個々に保存します
% またマージされた結果を保存します

proj = matlab.project.currentProject;

% 初期化
bdclose all;
sltest.testmanager.clear;
sltest.testmanager.clearResults;

% 全テストケースオブジェクトを取得
testfileName = ['Test_', mdlname];      % テストファイル名："Test_モデル名"
tfobj = sltest.testmanager.load(testfileName);
tcobjList = getAllTestCases(tfobj);

%% ----- テストケース実行及びレポート生成 ----- %%
resultDir = fullfile(proj.RootFolder, 'Test_Results');
if ~exist(resultDir, 'dir')
    mkdir(resultDir);
end
runTestAndExportResults(mdlname, resultDir, tcobjList, tfobj)
 
end
