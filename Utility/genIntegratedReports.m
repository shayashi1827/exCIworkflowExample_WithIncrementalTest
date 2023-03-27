function genIntegratedReports(tcRsltList, mdlname, resultDir, testfileName)

% カバレッジ計測結果をマージして結果をエクスポート
    covRsltset = sltest.testmanager.mergeCoverage(tcRsltList);  % get merged coverage result set@g2772840
    covRsltPath = fullfile(resultDir, [testfileName, '_IntegratedCoverageResults.mldatx']);
    sltest.testmanager.exportResults(covRsltset, covRsltPath);

    % マージされたカバレッジ結果からモデルの累積カバレッジレポートを生成する
    cvdo = covRsltset.getCoverageResults;
    aggregatedCovRslt = cvdo(arrayfun(@(x) isempty(x.modelinfo.harnessModel), cvdo));   % モデル全体に対する結果が累積カバレッジと判定
    covFilePath = fullfile(resultDir, [mdlname, '_AggregatedCoverageReport.html']);
    cvhtml(covFilePath, aggregatedCovRslt, '-sRT=0 -hTR=on');

    % テスト結果をマージしてレポート作成する
    reportFilePath = fullfile(resultDir, [testfileName, '_IntegratedReport.pdf']);
    if(exist(reportFilePath, 'file') == 2)
        delete(reportFilePath);
    end
    sltest.testmanager.report(tcRsltList, reportFilePath,...
        'Title', ['単体テストレポート「', testfileName, '」'],...
        'IncludeMLVersion',true,...
        'IncludeTestResults',int32(0),...
        'IncludeTestRequirement', true,...
        'IncludeSimulationSignalPlots',true,...
        'NumPlotRowsPerPage',2,...
        'NumPlotColumnsPerPage',2,...
        'IncludeErrorMessages',true,...
        'LaunchReport',false,...
        'IncludeCoverageResult', false);
    
end