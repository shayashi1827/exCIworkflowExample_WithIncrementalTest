function [dissSubsystemList,Edits_data] = DetectUpdatedSubsystems(BaseModel,DiffModel)
%[Table_data,Edits_data]= DetectUpdatedSubsystems(BaseModel,DiffModel)
%BasetModel��DiffModel���r���āA�ύX���������T�u�V�X�e�����𒊏o����B
%
%�����F
%   BaseModelName:����f����
%   DiffModelName�F��r�Ώۃ��f����
%�߂�l:
%   Table_data:�ύX���������T�u�V�X�e�����̃��X�g Table�^
%   DEdits_data:Simulink���f���̔�r���|�[�g�p�@�ҏW�����f�[�^�@xmlcomp.Edits�^
%   xmlcomp.Edits�^�ɂ��Ă͉��L�y�[�W�����Q�Ƃ��������B
%   https://jp.mathworks.com/help/simulink/ug/exporting-printing-and-saving-xml-comparison-results.html#bsxwbwi-1

    %��r�f�[�^��Node�f�[�^�`���Ŏ擾
    Edits_data = slxmlcomp.compare(BaseModel,DiffModel);
    if isempty(Edits_data)
        dissSubsystemList = {};
        return
    end
    
    %LefRoot,RightRoot�����ɑ΂��čX�V���ꂽ�m�[�h��T��
    Lnode_list = getUpdatedNode(Edits_data.LeftRoot);
    Rnode_list = getUpdatedNode(Edits_data.RightRoot);
    
    %���E�ōX�V���ꂽ�m�[�h���P�̕ϐ��ɏW��
    node_list = horzcat(Lnode_list,Rnode_list);
    
    %�m�[�h�������荞��Cell��錾
    len = length(node_list);
    UpdatedSubsystems = cell(len,1);

    %�m�[�h���X�g�̏�����荞��
    for i = 1:length(node_list)
       UpdatedSubsystems{i} = getNodePath(node_list{i});%�ύX�T�u�V�X�e���ւ̃p�X���擾
       %Node���ɂ�Model�����܂܂�Ă��Ȃ��̂�getNodePath�Ŋ��S�ȃt���p�X�𐶐��ł��܂���B
       %���̏�����Path�̐擪Mode����ǉ����܂��B
       UpdatedSubsystems{i} = strcat(BaseModel,UpdatedSubsystems{i});%�t���p�X�̐擪�Ƀ��f������ǉ�
    end
    
    %���j�[�N�ȃf�[�^�̂ݒ��o
    dissSubsystemList = unique(UpdatedSubsystems);
end


function node_list = getUpdatedNode(node)
%�X�V���s��ꂽ�T�u�V�X�e���m�[�h���擾����
    
    %��̃m�[�h���X�g��錾
    this_node_list = {};
    
    %�Y���m�[�h���X�V����Ă��� 
    if  node.Edited
       
       %�Y���m�[�h��Branch�i�M�����̐߁j���Ȃ킿�Y���m�[�h���̐擪��"Branch"���܂ނ��𔻒�
       if strncmp(node.Name,'Branch',6)
            %Branch(�M�����̐߁j�̐e�͕K���M�����Ȃ̂ŁA�e�̐e���X�V���ꂽ�T�u�V�X�e���ƂȂ�
            %�ύX���������m�[�h�̐e�̐e�����X�g�ɒǉ�
            this_node_list{end+1} = node.Parent.Parent; 
            
            %Branch�i�M�����̐߁j�̎q��Subsystem�͑��݂��Ȃ��̂ŁA�q���ɑ΂��ĒT�����Ȃ��B
            %���̎��_�Ŏ��W�����m�[�h���Ăяo�����Ƀ��^�[������
            node_list = this_node_list;
            return
       else
            %�Y���m�[�h��Branch�i�M�����̐߁j�ȊO�̏ꍇ
            %�ύX���������m�[�h�̐e���T�u�V�X�e���Ȃ̂ŁA�e�m�[�h�����X�g�ɒǉ�
             this_node_list{end+1} = node.Parent;
       end
       
    end
    
    %�Y���m�[�h�̊K�w�Ɏq�������邩����
    if ~isempty(node.Children)
        
        %������m�[�h�̎q���̐����擾
        child_num = length(node.Children);
        
        %�q�m�[�h�ɂ�������getUpdateNode���Ă�
        for i = 1:child_num
            %�q�m�[�h�Ō������X�V�m�[�h��this_node_list�ɐ�����������
            this_node_list = horzcat(this_node_list,getUpdatedNode(node.Children(i)));
        end    
    end

    %���W�����m�[�h���Ăяo�����Ƀ��^�[������
    node_list = this_node_list;
end


function subsystem_path = getNodePath(node)
%�Ώۃm�[�h�ɑΉ�����Simulink�u���b�N���烂�f���ŏ�ʂ܂ł̃p�X���擾����
   
    %������K�w��Pass���m�ۂ���ϐ���錾
    this_path =char(0);
        
    %������m�[�h�̖��O���`�F�b�N
    %��r�f�[�^�ł̓��f���̍ŏ�ʊK�w�͕K��System�Ƃ������O�ł��B
    %�m�[�h����System�łȂ����艺�L�̏��������s���܂��B
    if ~strcmp(node.Name,'Simulink')
        %���̃m�[�h�Ɛe�̃m�[�h�̖��O������łȂ��Ȃ�
        if ~strcmp(node.Name,node.Parent.Name)
            %Path_list�ɖ��O��ǉ�
            this_path = ['/' node.Name];       
        end

        %������m�[�h�̐e�̐����擾
        parent_num = length(node.Parent);
        %�e�m�[�h��T��
        for i = 1:parent_num
            %�e�m�[�h�̃p�X�ƌ��݂̊K�w�̃p�X����������
            this_path = strcat(getNodePath(node.Parent(i)),this_path);
        end
    end

    %���W�����p�X���Ăяo�����Ƀ��^�[������
    subsystem_path = this_path;
    
end


