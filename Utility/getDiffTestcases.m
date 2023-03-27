function tcobjList = getDiffTestcases(tfobj, subsystemList)
tcobjList = [];
for i = 1:length(subsystemList)
    subsystemPath_i = subsystemList{i};
    % 比較で得られたサブシステムパスは別名モデルに変換しているため、元のモデル名に修正する
    subsystemPath_i = strrep(subsystemPath_i, '_comp', '');
    
    tcobjList_i = findTestcaseTiedSubsystem(tfobj, subsystemPath_i);
    tcobjList = [tcobjList, tcobjList_i];
end

end