function tcobjList = findTestcaseTiedSubsystem(tfobj, subsystempath)
    % 引数で指定されたサブシステムに対するテストハーネスをテスト対象とするテストケースを抽出する
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
            
            % テスト対象ハーネスのオーナーと一致した場合対象のテストケース
            harnessOwner = tc_j.getProperty('HarnessOwner');
            if(strcmp(harnessOwner, subsystempath))
                tcobjList = [tcobjList, tc_j];
            end
        end        
    end
    
end