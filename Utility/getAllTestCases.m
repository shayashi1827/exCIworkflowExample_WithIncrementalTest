function tcobjList = getAllTestCases(tfobj)
tcobjList = [];

% ----- テストケースを1つずつチェックして該当するテストケースを洗い出す -----
% 本サンプルでは簡単化のためにTestSuiteは1階層のみという前提を設けた処理とする
tslist = tfobj.getTestSuites;
for i = 1:length(tslist)
    ts_i = tslist(i);

    % 全テストケースに対してチェック
    tclist = ts_i.getTestCases;
    tcobjList = [tcobjList, tclist];
end
end