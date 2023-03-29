function tcobjList = findTestcaseTiedSubsystem(tfobj, subsystempath)
    % 引数で指定されたサブシステムに対するテストハーネスをテスト対象とするテストケースを抽出する
    % またカバレッジ累積用のモデル全体テストケースは常に実行する必要があるため、これも追加する
    % 本サンプルでは簡単化のためにTestSuiteは1階層のみという前提を設けた処理とする
    
    tcobjList = [];
    % ----- テストケースを1つずつチェックして該当するテストケースを洗い出す -----
    % 全テストスイートに対してチェック    
    tslist = tfobj.getTestSuites;
    for i = 1:length(tslist)
        ts_i = tslist(i);
        
        % 全テストケースに対してチェック
        tclist = ts_i.getTestCases;
        for j = 1:length(tclist)
            tc_j = tclist(j);
            
            % テスト対象ハーネスのオーナーと一致した場合
            % またはテスト対象ハーネスがない（モデル全体のテスト）の場合
            harnessOwner = tc_j.getProperty('HarnessOwner');
            if(isempty(harnessOwner) || strcmp(harnessOwner, subsystempath))
                tcobjList = [tcobjList, tc_j];
            end
        end        
    end
    
end