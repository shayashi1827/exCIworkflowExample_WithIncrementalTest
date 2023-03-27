classdef modelDEDAction
    % MODELADVISORACTION performs Model Advisor checks on the model.
    % If Model Advisor configuration file is available it has to be set
    % before calling the run() method else Model Advisor will run checks
    % described in the 'checks' member variable of the class.
    % If report configuration object is available it has to be set before calling
    % the generateReport() method.
    
    % Copyright 2021 The MathWorks, Inc.
    properties
        modelName;
        prj;
        prjRootFolder;
        rptPath;
        mdlPath;
        sldvOpts;
        status;
        resultFilePath;
        rptCfg;
    end
    
    methods(Access = public)
        function obj = modelDEDAction(modelName)
            % If no model name is supplied
            if nargin == 0
                error('Please provide a model name');
            end
            
            % If provided model name is empty
            if isempty(modelName)
                ME = MException('Model name is empty');
                throw(ME);
            end
            
            % Set some member variables of the object.
            obj.modelName = char(modelName);
            obj.prj = matlab.project.currentProject;
            obj.prjRootFolder = char(obj.prj.RootFolder);
            
            obj.mdlPath = fullfile(obj.prjRootFolder, 'Design', obj.modelName, 'specification');
            %creates specific subfolder for report
            parentFolder = fullfile(obj.prjRootFolder, 'Design', obj.modelName, 'pipeline', 'analyze');
            if ~exist(fullfile(parentFolder, 'verify', 'designerrordetection'), 'dir')
                mkdir([parentFolder, '\verify', '\designerrordetection']);
            end
            obj.rptPath = fullfile(obj.prjRootFolder, 'Design', obj.modelName, 'pipeline', 'analyze', 'verify', 'designerrordetection');
            
            % SLDV解析オプション設定
            obj.sldvOpts = sldvoptions;
            
            % 設計エラー解析項目選択
            % 本サンプルでは「デッドロジック」のみ解析実行
            obj.sldvOpts.Mode = 'DesignErrorDetection';
            obj.sldvOpts.DesignMinMaxCheck = 'off';                     % 指定された最小値と最大値の違反
            obj.sldvOpts.DetectDeadLogic = 'on';                          % デッドロジック（一部）
            obj.sldvOpts.DetectActiveLogic = 'on';                         % 網羅的解析を実行（デッドロジックのオプション）
            obj.sldvOpts.DetectBlockInputRangeViolations = 'off';  % 指定したブロック入力範囲違反
            obj.sldvOpts.DetectDivisionByZero = 'off';                   % ゼロ除算
            obj.sldvOpts.DetectDSMAccessViolations = 'off';           % データ ストアのアクセス違反
            obj.sldvOpts.DetectIntegerOverflow = 'off';                 % 整数のオーバーフロー
            obj.sldvOpts.DetectOutOfBounds = 'off';                     % 配列の範囲外へのアクセス
            obj.sldvOpts.DetectSubnormal = 'off';                          % 非正規浮動小数点値
            obj.sldvOpts.DetectInfNaN = 'off';                              % 非有限で NaN の浮動小数点値
            obj.sldvOpts.MaxProcessTime = 120;                          % 最大解析時間
            obj.sldvOpts.SaveReport = 'on';                                 % レポート作成
            obj.sldvOpts.DisplayReport = 'off';                               % レポート表示
            obj.sldvOpts.ReportFileName =...                                % レポートファイル生成場所
                fullfile(obj.rptPath, [obj.modelName 'DesignErrorDetectionReport.html']);            
            
            % Perform cleanup before performing design error detection
            obj.preChecks();
        end
        
        function obj = run(obj)
            % run analysis
            [obj.status, obj.resultFilePath] = sldvrun(obj.modelName, obj.sldvOpts,false,[]);
            assert(obj.status ~= 0, 'Simulink Design Verifier analysis failed (status = 0)');       % エラーの場合はアサート、タイムアウトは続行
            %Close any open models
            bdclose('all');
        end
        
        function obj = dispResults(obj)           
            % Setup result struct to summarize results
            dedResults = load(obj.resultFilePath.DataFile);
            allDedObjTypes = {dedResults.sldvData.Objectives.type};
            numRangeObjectives = sum(ismember(allDedObjTypes, 'Range'));
            numDedObjectives = length(dedResults.sldvData.Objectives) - numRangeObjectives;
            allDedObjStatus = {dedResults.sldvData.Objectives.status};
            activeLogicCnt = sum(ismember(allDedObjStatus, 'Active Logic'));
            
            fprintf('\n DesignErrorDetection(DeadLogic) Analysis Results\n');
            fprintf('\tNumActiveLogic/numAllObjectives = %d/%d\n', activeLogicCnt, numDedObjectives);
        end
    end
    
    methods(Access = private)
                
        function preChecks(obj)
            bdclose('all');
            % Delete old report if it exists
            pdfFile = fullfile(obj.rptPath, [obj.modelName 'DEDReport.pdf']);
            if exist(pdfFile, 'file')
                delete(pdfFile);
            end
            
            htmlFile = fullfile(obj.rptPath, [obj.modelName 'DEDReport.html']);
            if exist(htmlFile, 'file')
                delete(htmlFile);
            end
            
            % Check if model exists.
            if ~isfile(fullfile(obj.mdlPath, [obj.modelName '.slx']))
                error("Model does not exist");
            end
            load_system(obj.modelName); % needed to suppress warning to remove report
        end
    end
end