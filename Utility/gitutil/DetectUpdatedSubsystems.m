function [dissSubsystemList,Edits_data] = DetectUpdatedSubsystems(BaseModel,DiffModel)
%[Table_data,Edits_data]= DetectUpdatedSubsystems(BaseModel,DiffModel)
%BasetModelとDiffModelを比較して、変更があったサブシステム名を抽出する。
%
%引数：
%   BaseModelName:基準モデル名
%   DiffModelName：比較対象モデル名
%戻り値:
%   Table_data:変更があったサブシステム名のリスト Table型
%   DEdits_data:Simulinkモデルの比較レポート用　編集差分データ　xmlcomp.Edits型
%   xmlcomp.Edits型については下記ページをご参照ください。
%   https://jp.mathworks.com/help/simulink/ug/exporting-printing-and-saving-xml-comparison-results.html#bsxwbwi-1

    %比較データをNodeデータ形式で取得
    Edits_data = slxmlcomp.compare(BaseModel,DiffModel);
    if isempty(Edits_data)
        dissSubsystemList = {};
        return
    end
    
    %LefRoot,RightRoot両方に対して更新されたノードを探す
    Lnode_list = getUpdatedNode(Edits_data.LeftRoot);
    Rnode_list = getUpdatedNode(Edits_data.RightRoot);
    
    %左右で更新されたノードを１つの変数に集約
    node_list = horzcat(Lnode_list,Rnode_list);
    
    %ノードから情報取り込むCellを宣言
    len = length(node_list);
    UpdatedSubsystems = cell(len,1);

    %ノードリストの情報を取り込む
    for i = 1:length(node_list)
       UpdatedSubsystems{i} = getNodePath(node_list{i});%変更サブシステムへのパスを取得
       %Node情報にはModel名が含まれていないのでgetNodePathで完全なフルパスを生成できません。
       %この処理でPathの先頭Mode名を追加します。
       UpdatedSubsystems{i} = strcat(BaseModel,UpdatedSubsystems{i});%フルパスの先頭にモデル名を追加
    end
    
    %ユニークなデータのみ抽出
    dissSubsystemList = unique(UpdatedSubsystems);
end


function node_list = getUpdatedNode(node)
%更新が行われたサブシステムノードを取得する
    
    %空のノードリストを宣言
    this_node_list = {};
    
    %該当ノードが更新されている 
    if  node.Edited
       
       %該当ノードがBranch（信号線の節）すなわち該当ノード名の先頭に"Branch"を含むかを判定
       if strncmp(node.Name,'Branch',6)
            %Branch(信号線の節）の親は必ず信号線なので、親の親が更新されたサブシステムとなる
            %変更があったノードの親の親をリストに追加
            this_node_list{end+1} = node.Parent.Parent; 
            
            %Branch（信号線の節）の子にSubsystemは存在しないので、子供に対して探索しない。
            %この時点で収集したノードを呼び出し元にリターンする
            node_list = this_node_list;
            return
       else
            %該当ノードがBranch（信号線の節）以外の場合
            %変更があったノードの親がサブシステムなので、親ノードをリストに追加
             this_node_list{end+1} = node.Parent;
       end
       
    end
    
    %該当ノードの階層に子供がいるか判定
    if ~isempty(node.Children)
        
        %今いるノードの子供の数を取得
        child_num = length(node.Children);
        
        %子ノードにたいしてgetUpdateNodeを呼ぶ
        for i = 1:child_num
            %子ノードで見つけた更新ノードをthis_node_listに水平結合する
            this_node_list = horzcat(this_node_list,getUpdatedNode(node.Children(i)));
        end    
    end

    %収集したノードを呼び出し元にリターンする
    node_list = this_node_list;
end


function subsystem_path = getNodePath(node)
%対象ノードに対応するSimulinkブロックからモデル最上位までのパスを取得する
   
    %今いる階層のPassを確保する変数を宣言
    this_path =char(0);
        
    %今いるノードの名前をチェック
    %比較データではモデルの最上位階層は必ずSystemという名前です。
    %ノード名がSystemでない限り下記の処理を実行します。
    if ~strcmp(node.Name,'Simulink')
        %今のノードと親のノードの名前が同一でないなら
        if ~strcmp(node.Name,node.Parent.Name)
            %Path_listに名前を追加
            this_path = ['/' node.Name];       
        end

        %今いるノードの親の数を取得
        parent_num = length(node.Parent);
        %親ノードを探索
        for i = 1:parent_num
            %親ノードのパスと現在の階層のパスを結合する
            this_path = strcat(getNodePath(node.Parent(i)),this_path);
        end
    end

    %収集したパスを呼び出し元にリターンする
    subsystem_path = this_path;
    
end


