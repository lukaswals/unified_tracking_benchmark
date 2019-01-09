function OPE_evaluate(sequences, trackers)
%OPE_EVALUATE(SEQUENCES, TRACKERS)
%
    for iseq = 1:length(sequences)
        for itrk = 1:length(trackers)
            fprintf('%5d_%-12s,%3d_%-20s\n',iseq,sequences{iseq}.name,itrk,trackers{itrk}.name);
            OPE(sequences{iseq}, trackers{itrk});
        end
    end
end

function OPE(s, t)
%OPE(SEQUENCE, TRACKER)
%
% One pass evaluation (OPE). Run the TRACKER on the whole SEQUENCE once.
% Then save the results.
%
    % fprintf('%-12s - %-12s\n', s.name, t.name);
    % Pre-settings
    dataset = get_global_variable('dataset');
    switch dataset
        case {'OTB2013', 'OTB50', 'OTB100'}
            dataset = 'OTB';
    end
    toolkit_path = get_global_variable('toolkit_path');
    evaluation = ['OPE_' dataset];
    tmp_path = fullfile(toolkit_path, 'tmp', evaluation);
    final_path = fullfile(toolkit_path, 'results', evaluation);
    result_file = fullfile(final_path, [s.name '_' t.name '.mat']);
    rp = [tmp_path s.name '_' t.name '_' num2str(1) '/'];
    bSaveImage = false;
    
    % Split sequence
    numSeg = 1;
    rect_anno = s.annos;
    [subSeqs, subAnno]=splitSeqTRE(s,numSeg,rect_anno);
    subS = subSeqs{1};            
    subSeqs = [];
    subSeqs{1} = subS;
    subA = subAnno{1};
    subAnno = [];
    subAnno{1} = subA;
    
    % Check existance of results
    if exist(result_file, 'file')
        results = [];
        load(result_file);
        bfail = checkResult(results, subAnno);
        if ~isempty(results), return; end
        %if ~bfail
        %    return; % exit now
        %end
    end

    % Set the tracker's path
    tracker_path = fullfile(toolkit_path, 'trackers', t.namePaper);
    if ~exist(tracker_path, 'dir')
        error(['Fail to find tracker repository: ' tracker_path]);
    end

    % Set the main function to execute
    func = ['res = ' t.mainFunc '(subS, rp, bSaveImage);'];

    results = [];
    try
        % Setup before excution
        old_path = path; % Save search path state
        cd(tracker_path);
        eval(t.setupFunc);

        % Execute tracking algorithm
        eval(func);

        % Cleanup after excution
        path(old_path); % Restore search path state
        cd(toolkit_path);
    catch err
        disp(getReport(err));
        % Save err;
        err.sname = s.name;
        err.tname = t.name;
        register('errors', err);
        % Cleanup after error
        rmpath(genpath('./'));
        cd(toolkit_path);
        % continue;
    end
    res.len = subS.len;
    res.annoBegin = subS.annoBegin;
    res.startFrame = subS.startFrame;
    results{1} = res;

    save(result_file, 'results');
end

