function OPE_drawplot(sequences, trackers, linespecs)
% OPE_DRAWPLOT Draw Success and Precision plots for OPE evaluation
%

dataset = get_global_variable('dataset');

toolkit_path = get_global_variable('toolkit_path');
perfmat_path = fullfile(toolkit_path, 'perfmat', 'OPE');
figure_path = fullfile(toolkit_path, 'figs', 'OPE');

nseq = length(sequences);
ntrk = length(trackers);
for id = 1:ntrk
    t = trackers{id};
    nameTrkAll{id} = t.name;
end

thresholdSetOverlap = 0:0.05:1;
thresholdSetError = 0:50;

metricTypeSet = {'error', 'overlap'};
rankingType = get_global_variable('rankingType');
% Number of trackers to show
rankNum = 10;

% Load the perfmat
perfmat_file = fullfile(perfmat_path, ['perfplot_curves_OPE_' dataset '.mat']);
load(perfmat_file); %'success_curve','precision_curve','nameTrkAll'

for i=1:length(metricTypeSet)
    metricType = metricTypeSet{i};%error,overlap
    
    switch metricType
        case 'overlap' % for Success plot
            thresholdSet = thresholdSetOverlap;
            rankIdx = 11;
            curvePlot = success_curve;
            figFn = 'success_plot';
            titleName = ['Success plots of OPE in ' dataset];
            xLabelName = 'Overlap threshold';
            yLabelName = 'Success rate';
        case 'error' % for Precision plot
            thresholdSet = thresholdSetError;
            rankIdx = 21;
            curvePlot = precision_curve;
            figFn = 'precision_plot';
            titleName = ['Precision plots of OPE in ' dataset];
            xLabelName = 'Location error threshold';
            yLabelName = 'Precision';
    end
    
    % Name of image file to save
    figName = [figFn '_OPE_' dataset '_' rankingType];
    
    % Calculate tracker result for the dataset
    switch rankingType
        case 'AUC'
            AUC = cellfun(@mean, curvePlot);
            perf = mean(AUC, 2); % the AUC of the plot of each tracker
        case 'threshold'
            thre = cellfun(@(x)x(rankIdx), curvePlot,'uni',0); % Could be replaced with a for loop
            perf = mean(cell2mat(thre), 2);
    end

    % Make the legend for the plot with the corresponding ranking type
    for idTrk = 1:ntrk
        trkLegendAll{idTrk} = [nameTrkAll{idTrk} ' [' num2str(perf(idTrk),'%.3f') ']'];
    end
    % Rank the trackers
    [~, trackersRanked] = sort(perf, 'descend');

    % cell2array
    curve = reshape(cell2mat(curvePlot), ntrk, length(thresholdSet), nseq);
    curve = squeeze(mean(curve,3));
    %{
    % Check the number of trackers to plot
    if rankNum > ntrk || rankNum <0
        rankNum = ntrk;
    end
    trackersRanked = trackersRanked(1:rankNum);
    %}
    % Draw Success/Precision plots of OPE
    h = figure; hold on;
    for idTrk = trackersRanked'
        plot(thresholdSet, curve(idTrk,:), linespecs{idTrk}); hold on;
    end

    legend(trkLegendAll(trackersRanked), 'Location', 'southwest');
    box on; % displays the box outline around the current axes
    title(titleName);
    xlabel(xLabelName);
    ylabel(yLabelName);
    saveas(h,fullfile(figure_path, figName),'png');
    
end


end

