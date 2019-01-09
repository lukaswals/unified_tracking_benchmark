function OPE_perfmat(sequences, trackers)

dataset = get_global_variable('dataset');
switch dataset
    case {'OTB2013', 'OTB50', 'OTB100'}
        data_folder = 'OTB';
    otherwise
        data_folder = dataset;
end

toolkit_path = get_global_variable('toolkit_path');
results_path = fullfile(toolkit_path, 'results', ['OPE_' data_folder]);
perfmat_path = fullfile(toolkit_path, 'perfmat', 'OPE');

nseq = length(sequences);
ntrk = length(trackers);

% Names of all the trackers evaluated
nameTrkAll = {};
for i = 1:ntrk
    nameTrkAll{end+1} = trackers{i}.name;
end

success_curve = cell(ntrk, nseq);
precision_curve = cell(ntrk, nseq);
frames_per_second = cell(ntrk, nseq);

for iseq = 1:nseq % for each sequence
    for itrk = 1:ntrk % for each tracker
        fprintf('%5d_%-12s,%3d_%-20s\n',iseq,sequences{iseq}.name,itrk,trackers{itrk}.name);
        %if iseq == 96
        %    disp("pause here =D");
        %end
        [success, precision, fps] = perf(sequences{iseq}, trackers{itrk}, results_path);
        success_curve{itrk, iseq} = success;
        precision_curve{itrk, iseq} = precision;
        frames_per_second{itrk, iseq} = fps;
    end
end

% save result file
perfmat_file = fullfile(perfmat_path, ['perfplot_curves_OPE_' dataset '.mat']);
save(perfmat_file,'success_curve','precision_curve','frames_per_second','nameTrkAll');

end % function OPE_perfmat

function [success, precision, fps] = perf(s, t, results_path)
    % Threshold sampled in the plots
    thresholdSetOverlap = 0:0.05:1;
    thresholdSetError = 0:50;

    % Load results
    results_file = fullfile(results_path, [s.name '_' t.name '.mat']);
    load(results_file);

    anno = s.annos;

    % Preparing evaluation
    aveCoverageAll=[];
    aveErrCenterAll=[];
    errCvgAccAvgAll = 0;
    errCntAccAvgAll = 0;
    errCoverageAll = 0;
    errCenterAll = 0;
    
    successNumOverlap = zeros(1,length(thresholdSetOverlap));
    successNumErr = zeros(1,length(thresholdSetError));
    idx = 1;
    res = results{idx};
    len = size(anno,1);
    
    if isempty(res.res)
        error('DEBUG ENTER 1');
        return;
    end
    
    if ~isfield(res,'type')&&isfield(res,'transformType')
        error('DEBUG ENTER 2');
        res.type = res.transformType;
        res.res = res.res';
    end
    
    %[aveCoverage, aveErrCenter, errCoverage, errCenter] = calcSeqErrRobust(res, anno);
    [aveCoverage, aveErrCenter, errCoverage, errCenter] = calcSeqErrRobust(res, anno);
    
    for tIdx=1:length(thresholdSetOverlap)
        successNumOverlap(idx,tIdx) = sum(errCoverage > thresholdSetOverlap(tIdx));
    end
    
    for tIdx=1:length(thresholdSetError)
        successNumErr(idx,tIdx) = sum(errCenter <= thresholdSetError(tIdx));
    end

    success = successNumOverlap/(len+eps);
    precision = successNumErr/(len+eps);
    if isfield(results{idx}, 'fps')
        fps = results{idx}.fps;
    else
        fps = 0;
    end
    
end % function perf

