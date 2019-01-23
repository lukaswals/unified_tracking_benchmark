function s = get_otb_sequence(seqspath, sequence)
% GET_OTB_SEQUENCE Configures information of a sequence from OTB Dataset
% into a struct variable
%
    toolkit_path = get_global_variable('toolkit_path');
    att_path = fullfile(toolkit_path, 'tracker_benchmark_v1.0', 'anno', 'att');

    fprintf('Getting sequence ''%s'' data...\n', sequence);
    s = struct();
    % NAME (identifier)
    s.name = sequence;
    switch sequence
        % In OTB, the following sequence has 2 objects, so there will be 2
        % groundtruth files
        case {'Human4-2', 'Jogging-1', 'Jogging-2', 'Skating2-1', 'Skating2-2'}
            splitted = strsplit(sequence, '-');
            folder_name = splitted{1};
            ground_truth = ['groundtruth_rect.' splitted{2} '.txt'];
        otherwise
            folder_name = sequence;
            ground_truth = 'groundtruth_rect.txt';
    end
    % SEQUENCE PATH (the dir containing the sequence's files)
    s.path = fullfile(seqspath, folder_name);
    % ANNO_FILE
    anno_filename = ground_truth;
    s.anno_file = fullfile(s.path, anno_filename);
    % ANNOS (annotations)
    s.annos = dlmread(s.anno_file);
    % ATTR_FILE (which challenging attributes has this sequence)
    attr_file = [att_path '/' lower(s.name) '.txt'];
    % ATTRIBUTES (challenging attributes tagged)
    s.attributes = load(attr_file);
    % NZ (num of zeros)
    s.nz = 4;
    % EXT
    s.ext = 'jpg';
    % STARTFRAME
    s.startFrame = 1;
    % ENDFRAME
    s.endFrame = size(s.annos, 1);
    % SPECIAL_CASES
    if (strcmp(sequence, 'Board')), s.nz = 5; end
    if (strcmp(sequence, 'David')), s.startFrame = 300; s.endFrame = 770; end
    if (strcmp(sequence, 'Football1')), s.endFrame = 74; end
    if (strcmp(sequence, 'Freeman3')), s.endFrame = 460; end
    if (strcmp(sequence, 'Freeman4')), s.endFrame = 283; end
    if (strcmp(sequence, 'BlurCar1')), s.startFrame = 247; s.endFrame = 988; end
    if (strcmp(sequence, 'BlurCar3')), s.startFrame = 3; s.endFrame = 359; end
    if (strcmp(sequence, 'BlurCar4')), s.startFrame = 18; s.endFrame = 397; end
    if (strcmp(sequence, 'Tiger1')), s.startFrame = 6; s.endFrame = 354; s.annos = s.annos(s.startFrame:s.endFrame,:); end
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