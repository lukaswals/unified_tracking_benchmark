function s = get_tcolor_sequence(seqspath, sequence)
% GET_TCOLOR_SEQUENCE Configures information of a sequence from
% Temple-Color dataset into a struct variable
%

    fprintf('Getting sequence ''%s'' data...\n', sequence);
    s = struct();
    % NAME (identifier)
    s.name = sequence;
    % SEQUENCE PATH (the dir containing the sequence's files)
    s.path = fullfile(seqspath, sequence);
    % ANNO_FILE (containing GT information)
    anno_filename = [sequence '_gt.txt'];
    s.anno_file = fullfile(s.path, anno_filename);
    % ANNOS (GT Annotations)
    s.annos = dlmread(s.anno_file);
    % ATTR_FILE (which challenging attributes has this sequence)
    attr_filename = [sequence '_att.txt'];
    s.attr_file = fullfile(s.path, attr_filename);
    % ATTRIBUTES (challenging attributes tagged)
    [attribute_names, ~] = get_attribute_list;
    %attributes = zeros(1,length(attribute_names)); % Array that holds tags
    fid = fopen(s.attr_file);
    list = textscan(fid,'%s');
    attr = list{1}';
    fclose(fid);
    s.attributes = double(ismember(attribute_names, attr)); % Convert to number array
    % NZ (num of zeros)
    s.nz = 4;
    % EXT
    s.ext = 'jpg';
    % FRAMES_FILE (Containing information of start/end frame)
    frames_filename = [sequence '_frames.txt'];
    s.frames_file = fullfile(s.path, frames_filename);
    frames_data = dlmread(s.frames_file);
    % STARTFRAME
    s.startFrame = frames_data(1);
    % ENDFRAME
    s.endFrame = frames_data(2);
%    fprintf('\tFrame data > %d - %d...\n', s.startFrame, s.endFrame);
    % NO SPECIAL_CASES in this dataset
    % LEN (length)
    s.len = s.endFrame - s.startFrame + 1;
    % S_FRAMES (sequence frames)
    s.s_frames = cell(s.len,1);
    fmtstr = ['%0' num2str(s.nz) 'd.' s.ext];
    for i = 1:s.len
        img_name = sprintf(fmtstr, s.startFrame + i - 1);
        s.s_frames{i} = fullfile(s.path,'img',img_name);
    end
end