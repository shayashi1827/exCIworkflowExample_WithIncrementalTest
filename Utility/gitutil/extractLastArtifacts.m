function compMdlName = extractLastArtifacts(branch, mdlname, opRemote)
% safe directory追加（gitの仕様変更に伴う対応)
myProject       = matlab.project.currentProject;
projectRoot     = myProject.RootFolder;
cmd = ['git config --global --add safe.directory ', projectRoot.char]
[st, log] = system(cmd);

% 直近のcomit id取得
if(opRemote)
    strBranch = ['origin/', branch];
else
    strBranch = branch;
end
cmd = ['git log ', strBranch, ' -n 1']     
[~, log_txt] = system(cmd);
log_txt = strsplit(log_txt,{' ', '\n'});     % 空白と改行で文字列を区切る
commit_id = log_txt{2};                       %２番目の要素がコミットID

% モデルファイルパス
baseMdlName     = [mdlname, '.slx'];

mdlFullPath     = which([mdlname, '.slx']);
mdlRelPath      = strrep(mdlFullPath, [projectRoot.char,'\'], '');   % 絶対パス to 相対パス
[mdlpath, ~, ~] = fileparts(mdlRelPath);
baseMdlRelPath  = [mdlpath, '/', baseMdlName];                                      % コミット：ファイル相対パス
compMdlName = [mdlname, '_comp.slx'];
compMdlRelPath  = fullfile(projectRoot.char, mdlpath, compMdlName);     % コピー先は絶対パス

% 該当コミットIDのモデルファイルを別名で同じフォルダに保存
cmd = ['git show ', commit_id, ':', baseMdlRelPath, ' > ', compMdlRelPath]
system(cmd);

% リターンからは拡張子を削除
compMdlName = strrep(compMdlName, '.slx', '');
end