function runTestAndExportResults(mdlname, resultDir, diffTCobjList, tfobj)

%% ----- テストケース実行 ----- %%
tcResultObjList = [];
for i = 1:length(diffTCobjList)
    tmp = diffTCobjList(i).run;
    tcResultObjList = [tcResultObjList, tmp];   % 直接代入不可
end

%% ----- 結果の統合 ----- %%

% 既存結果をオーバーライドしてエクスポート
exportTCResults(diffTCobjList, tcResultObjList, resultDir);

% 既存結果も含めてすべてロードする
sltest.testmanager.clearResults;    % 一旦すべてクリア
allTCResultList = loadAllTCResults(tfobj, resultDir);

% テスト結果をマージしてレポート作成する
genIntegratedReports(allTCResultList, mdlname, resultDir, tfobj.Name);

end