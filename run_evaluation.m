% Configure necessary paths for the Toolkit
startup;

% If you already downloaded the dataset, please set the paths for the 
% corresponding dataset here. 
% If not, leave it blank and the toolkit will download it automatically.
%set_global_variable('otb_path', ''); % OTB100, OTB50, OTB2013
%set_global_variable('tcolor_path', ''); % Temple Color
set_global_variable('otb_path', 'G:\Lucas\OTB-100'); % OTB100, OTB50, OTB2013
set_global_variable('tcolor_path', ''); % Temple Color

% Configure evaluation type and benchmark to use
eval_method = 'OPE';
% Available evaluation methods:
%   One-Pass Evaluation (OPE)
% Not implemented evaluation methods (yet):
%   Temporal Robustness Evaluation (TRE)
%   Spatial Robustness Evaluation (SRE)
dataset = 'OTB100';
% Available datasets:
%   OTB -> OTB2013, OTB50, OTB100
%   Temple-Color -> TCOLOR128
rankingType = 'threshold';
% Available ranking types:
%   AUC: Area under the curve
%   threshold: 0.5 for Success plot, 20 pixel distance for Precision Plot

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
% Get value for all Thresholds (for AUC ranking)
OPE_perfmat(sequences, trackers);
% Get value for specific Thresholds ()
%OPE_perfmat_noauc(sequences, trackers, eval_method);

% Draw performance plots PER sequence
%fprintf('\tDrawing Performance plots per sequence...\n');
%OPEps_drawplot(sequences, trackers, linespecs);

% Draw performance plots
fprintf('\tDrawing Performance plots...\n');
% Rank trackers according to the AUC of the plots
OPE_drawplot(sequences, trackers, linespecs);
% Rank Success plot according to threshold value at 0.5
% Rank Precision plot according to distance of 20 pixel
%OPE_drawplot_noauc(sequences, trackers, linespecs);

% OPTIONAL: uncomment following lines to draw performance plots per challenge
%fprintf('\tDrawing Performance plot for each challenging attribute...\n');
%OPEpc_perfmat(sequences, trackers, eval_method);
%OPEpc_drawplot(sequences, trackers, linespecs, eval_method);

fprintf('\tFinished Evaluation!...\n');