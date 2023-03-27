function compMdlName = extractLastArtifacts(branch, mdlname)
% ローカルの直近のcomit id取得
cmd = ['git log ', branch, ' -n 1'];     
[~, log_txt] = system(cmd);
log_txt = strsplit(log_txt,{' ', '\n'});     % 空白と改行で文字列を区切る
commit_id = log_txt{2};                       %２番目の要素がコミットID

% モデルファイルパス
baseMdlName     = [mdlname, '.slx'];
myProject       = matlab.project.currentProject;
projectRoot     = myProject.RootFolder;
mdlFullPath     = which([mdlname, '.slx']);
mdlRelPath      = strrep(mdlFullPath, [projectRoot.char,'\'], '');   % 絶対パス to 相対パス
[mdlpath, ~, ~] = fileparts(mdlRelPath);
baseMdlRelPath  = [mdlpath, '/', baseMdlName];                                      % コミット：ファイル相対パス
compMdlName = [mdlname, '_comp.slx'];
compMdlRelPath  = fullfile(projectRoot.char, mdlpath, compMdlName);     % コピー先は絶対パス

% 該当コミットIDのモデルファイルを別名で同じフォルダに保存
cmd = ['git show ', commit_id, ':', baseMdlRelPath, ' > ', compMdlRelPath];
system(cmd);

% リターンからは拡張子を削除
compMdlName = strrep(compMdlName, '.slx', '');
end