function exportTCResults(tcobjList, tcResultObjList, resultDir)

for i = 1:length(tcResultObjList)
    tcrslt_i = tcResultObjList(i);
    tcobj_i = tcobjList(i);
    
    filePath = fullfile(resultDir, [strrep(tcobj_i.TestPath, ' > ', '_'), '.mldatx']);
    sltest.testmanager.exportResults(tcrslt_i, filePath);
end

end