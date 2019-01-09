function startup
close all; clc; warning off all;

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

% Add necessary paths
addpath(fullfile(pathstr, 'utils'));
addpath(fullfile(pathstr, 'configs'));
addpath(fullfile(pathstr, 'evals'));

% Reuse functions from base repository
addpath(fullfile(pathstr, 'tracker_benchmark_v1.0', 'util'));
addpath(fullfile(pathstr, 'tracker_benchmark_v1.0', 'rstEval'));
addpath(fullfile(pathstr, 'tracker_benchmark_v1.0', 'anno', 'att'));

% Set toolkit path
set_global_variable('toolkit_path', pathstr);

% Create caching folder
mkdir(fullfile(pathstr, 'cache'));

end

