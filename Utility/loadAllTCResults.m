function tcResultList = loadAllTCResults(tfobj, resultDir)
tcResultList = [];

tcobjAllList = getAllTestCases(tfobj);
for i = 1:length(tcobjAllList)
    tcobj_i = tcobjAllList(i);
    filePath = fullfile(resultDir, [strrep(tcobj_i.TestPath, ' > ', '_'), '.mldatx']);
    tmp = sltest.testmanager.importResults(filePath);
    tcResultList = [tcResultList, tmp]; % 直接代入不可
end

end