% Configure necessary paths for the Toolkit
startup;

%% CONFIGURABLE PARAMETERS HERE
% If you already downloaded the dataset, please set the paths for the 
% corresponding dataset here. 
% If not, leave it blank and the toolkit will download it automatically.
set_global_variable('otb_path', ''); % OTB100, OTB50, OTB2013
set_global_variable('tcolor_path', ''); % Temple Color

% Configure evaluation type and benchmark to use
eval_method = 'OPE';
% Available evaluation methods:
%   One-Pass Evaluation (OPE)
% Not implemented evaluation methods (yet):
%   Temporal Robustness Evaluation (TRE)
%   Spatial Robustness Evaluation (SRE)
dataset = 'TCOLOR128';
% Available datasets:
%   BenchkmarName -> Dataset1, Dataset2, ...
%   OTB -> OTB2013, OTB50, OTB100
%   Temple-Color -> TCOLOR128
rankingType = 'AUC';
% Available ranking types:
%   AUC: Area under the curve
%   threshold: 0.5 for Success plot, 20 pixel distance for Precision Plot

%% EVALUATION STARTS HERE...
set_global_variable('dataset', dataset);
set_global_variable('rankingType', rankingType);

% Configure sequences according to the dataset
sequences = config_sequences;
% Select which Trackers to evaluate/compare to
trackers = config_trackers;
% Configure color/line types of the plot
linespecs = config_linespecs;

% Perform OPE evaluation on the whole benchmark
fprintf('\tRunning evaluation on dataset ''%s'' with selected Trackers...\n', dataset);
OPE_evaluate(sequences, trackers);

% Evaluate the results and save to a .mat file
fprintf('\tEvaluating obtained results...\n');
% Create performance mat file for all Thresholds. Later used to plot results
OPE_perfmat(sequences, trackers);

% Draw performance plots
fprintf('\tDrawing Performance plots...\n');
% Rank trackers according to the AUC of the plots
OPE_drawplot(sequences, trackers, linespecs);
% TODO: Draw performance plots per challenge of the 

fprintf('\tFinished Evaluation!...\n');