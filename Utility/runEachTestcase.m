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

% function genAggregatedCovReport(proj, covRsltset)
% % マージされたカバレッジ結果からモデルの累積カバレッジレポートを生成する
% 
% cvdo = covRsltset.getCoverageResults;
% aggregatedCovRslt = cvdo(arrayfun(@(x) isempty(x.modelinfo.harnessModel), cvdo));
% resultDir = fullfile(proj.RootFolder, 'Test_Results');
% mdlname = aggregatedCovRslt.modelinfo.analyzedModel;
% covFilePath = fullfile(resultDir, [mdlname, '_AggregatedCoverageReport.html']);
% cvhtml(covFilePath, aggregatedCovRslt, '-sRT=0 -hTR=on');
% 
% end
% 
% function cvdoList = makeCVdataList(tcResultObjList)
% % テスト結果からカバレッジデータグループを作成する
% 
% cvdoList = [];
% for i = 1:length(tcResultObjList)
%    cvdoList = [cvdoList, tcResultObjList(i).getCoverageResults];
% end
% end
% 
% function generateMergedCoverageReport(cvdoList, proj, tcObjList)
% % 個々のレポートおよびマージされたカバレッジレポートを生成する
% 
% mdlname = getProperty(tcObjList(1), 'Model');    % 単体テストのためロードするモデルは1つ
% if(~bdIsLoaded(mdlname))
%     load_system(mdlname);
% end
% 
% % まず個々のカバレッジレポートを生成する
% %resultDir = fullfile(proj.RootFolder, 'Test_Results');
% resultDir = pwd;
% for i = 1:length(cvdoList)
%     tc_i = tcObjList(i);
%     sltest.harness.load(getProperty(tc_i, 'HarnessOwner'), getProperty(tc_i, 'HarnessName'));
%     cvhtml(fullfile(resultDir, [tc_i.Parent.Name, '_', tc_i.Name, '_covreport.html']), cvdoList(i));
%     sltest.harness.close(getProperty(tc_i, 'HarnessOwner'), getProperty(tc_i, 'HarnessName'));
% end
% 
% % サマリーレポートを生成する
% tfobj = tcObjList(1).TestFile;
% covFilePath = fullfile(resultDir, [tfobj.Name, '_CoverageReport.html']);
% cvdg = cv.cvdatagroup(cvdoList);
% cvhtml(covFilePath, cvdg);
% 
% close_system(mdlname);
% end