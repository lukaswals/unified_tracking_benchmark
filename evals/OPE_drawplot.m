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

[attribute_names, att_names_long] = get_attribute_list;
attributes=[];
% get attribute data from the sequence's file
for idxSeq = 1:nseq
    s = sequences{idxSeq}; 
    attributes(idxSeq,:) = s.attributes;
end
natt = size(attributes,2);

metricTypeSet = {'error', 'overlap'};
rankingType = get_global_variable('rankingType');
% Number of trackers to show. Currently not used.
rankNum = 10;

% Load the perfmat
perfmat_file = fullfile(perfmat_path, ['perfplot_curves_OPE_' dataset '.mat']);
load(perfmat_file); %'success_curve','precision_curve','nameTrkAll'

for i=1:length(metricTypeSet)
    metricType = metricTypeSet{i};%error,overlap
    
    % Don't rank center location error using AUC
    if strcmp(metricType,'error') && strcmp(rankingType,'AUC')
        continue;
    end
    
    switch metricType
        case 'overlap' % Parameters for Success plot
            thresholdSet = thresholdSetOverlap;
            rankIdx = 11;
            curvePlot = success_curve;
            figFn = 'success_plot';
            titleName = ['Success plots of OPE in ' dataset];
            xLabelName = 'Overlap threshold';
            yLabelName = 'Success rate';
        case 'error' % Parameters for Precision plot
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
            % Could be replaced with a for loop for better performance
            thre = cellfun(@(x)x(rankIdx), curvePlot,'uni',0); 
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
    % Draw Success/Precision plots of OPE over the whole dataset
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

if strcmp(rankingType, 'AUC') == 1
    fprintf('\tDrawing Performance plots per Attribute...\n');
    % Draw Success plots of OPE for a specific challenging attribute
    for attIdx = 1:natt   
        %challType = ['OPE_' attribute_names{attIdx}];
        idxSeqSet = find(attributes(:,attIdx)>0);
        nseqatt = length(idxSeqSet);
        % for attribute name for figure title
        challTitle = [att_names_long{attIdx} ' (' num2str(nseqatt) ')'];
        % Get results of all sequences tagged with this attribute
        success_curve_chall = success_curve(:,idxSeqSet);

        % Success Plot parameters
        thresholdSet = thresholdSetOverlap;
        rankIdx = 11;
        curvePlot = success_curve_chall;
        figFn = 'success_plot';
        titleName = ['Success plots of OPE in ' dataset ' - ' challTitle];
        xLabelName = 'Overlap threshold';
        yLabelName = 'Success rate';

        % Name of image file to save
        figName = [figFn '_OPE_' dataset '_' attribute_names{attIdx}];

        % For now, the per attribute plots only rank by AUC, haven't seen
        % any paper presenting this plot results with Threshold ranking,
        % but the option is easy to add by uncommenting the lines below
        switch rankingType
            case 'AUC'
                AUC = cellfun(@mean, curvePlot);
                perf = mean(AUC, 2); % the AUC of the plot of each tracker
            %{    
            case 'threshold'
                % Could be replaced with a for loop for better performance
                thre = cellfun(@(x)x(rankIdx), curvePlot,'uni',0); 
                perf = mean(cell2mat(thre), 2);
            %}
        end

        % Make the legend for the plot with the corresponding ranking type
        for idTrk = 1:ntrk
            trkLegendAll{idTrk} = [nameTrkAll{idTrk} ' [' num2str(perf(idTrk),'%.3f') ']'];
        end
        % Rank the trackers
        [~, trackersRanked] = sort(perf, 'descend');

        % cell2array
        curve = reshape(cell2mat(curvePlot), ntrk, length(thresholdSet), nseqatt);
        curve = squeeze(mean(curve,3));

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
end %if end

end

