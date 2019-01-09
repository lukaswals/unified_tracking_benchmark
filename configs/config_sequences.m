function sequences = config_sequences
%CONFIG_SEQUENCES Configure corresponding dataset for evaluation
%
%   CONFIG_SEQUENCES configures the DATASET and cache the information of 
%   the sequences in a mat file. If the DATASET was not downloaded, 
%   this script will download all the sequences automatically
%
%   DATASET variable is set in "run_evaluation.m" file
%
    dataset = get_global_variable('dataset');
    switch dataset
        case {'OTB2013', 'OTB50', 'OTB100'}
            seqspath = get_global_variable('otb_path');
        case 'TCOLOR128'
            seqspath = get_global_variable('tcolor_path');
        otherwise
            error('Dataset option ''%s'' not supported. Please check again the available datasets.', dataset);
    end
    
    % Check if sequences were pre-downloaded
    if isempty(seqspath)
        switch dataset
            case {'OTB2013', 'OTB50', 'OTB100'}
                dataset_folder = 'OTB';
            otherwise
                dataset_folder = dataset;
        end
        seqspath = fullfile(get_global_variable('toolkit_path'), 'sequences', dataset_folder);
    end
    
    seqs_file = fullfile(get_global_variable('toolkit_path'), 'sequences', [dataset '_SEQUENCES']);
    % Cache file contains all information about the sequence
    cache_file = fullfile(get_global_variable('toolkit_path'), 'cache', [dataset '_sequences_cache.mat']);
    % Lite cache file contains only name of sequence and ground truth data
    lite_cache_file = fullfile(get_global_variable('toolkit_path'), 'cache', [dataset '_sequences_lite_cache.mat']);

    if exist(cache_file, 'file')
        fprintf('Load cache file %s\n', cache_file);
        load(cache_file);
        return;
    else
        fprintf('Cache file not found, configuring dataset...\n');
    end

    % If no cache file was found, create one for later use
    fid = fopen(seqs_file, 'r');
    while true
        sequence_name = fgetl(fid);
        if (sequence_name == -1), break; end
        
        switch sequence_name
            % In OTB, the following sequence has 2 objects, so we need to
            % download sequence only one time
            case {'Human4-2', 'Jogging-1', 'Jogging-2', 'Skating2-1', 'Skating2-2'}
                splitted = strsplit(sequence_name, '-');
                download_name = splitted{1};
            otherwise
                download_name = sequence_name;
        end
        % Download sequence if we don't have it
        if ~exist(fullfile(seqspath, download_name), 'dir')
            download_if_needed(seqspath, download_name);
        end
        register('sequences', get_otb_sequence(seqspath, sequence_name));
    end
    fclose(fid);

    % Save Cache file
    sequences = register('sequences');
    save(cache_file, 'sequences');

    for i = 1:length(sequences)
        register('sequences_lite', struct('name', sequences{i}.name, 'annos', sequences{i}.annos));
    end

    % Save Cache Lite file
    sequences_lite = register('sequences_lite');
    save(lite_cache_file, 'sequences_lite');

    register('sequences', 'clear');
    register('sequences_lite', 'clear');
end

function download_if_needed(seqspath, sequence)
    dataset = get_global_variable('dataset');
    fprintf('Downloading sequence ''%s'', This may take a while...\n', sequence);
    zipname = fullfile(seqspath, [sequence '.zip']);
    zipurl = ['http://cvlab.hanyang.ac.kr/tracker_benchmark/seq/' sequence '.zip'];
    try
        urlwrite(zipurl, zipname);
        unzip(zipname, seqspath);
    catch
        fprintf('Download fails. Please try to download the bundle manually from %s and uncompress it to %s\n', zipurl, seqspath);
    end
    %{
    if length(splitted) == 2
        system(['ln -sr ' fullfile(seqspath, splitted{1}) ' ' fullfile(seqspath, splitted{1}) '-1']);
        system(['ln -sr ' fullfile(seqspath, splitted{1}) ' ' fullfile(seqspath, splitted{1}) '-2']);
    end
    %}
end

