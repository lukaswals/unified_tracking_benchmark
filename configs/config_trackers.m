function trackers = config_trackers

% Register State-of-the-art trackers results here
register('trackers', struct('name','MDNet','namePaper','MDNet'));
register('trackers', struct('name','CCOT','namePaper','CCOT'));
register('trackers', struct('name','ECO','namePaper','ECO'));
register('trackers', struct('name','SRDCFdecon','namePaper','SRDCFdecon'));
register('trackers', struct('name','HDT','namePaper','HDT'));
register('trackers', struct('name','Staple','namePaper','Staple'));
register('trackers', struct('name','SRDCF','namePaper','SRDCF'));
register('trackers', struct('name','DeepSRDCF','namePaper','DeepSRDCF'));
register('trackers', struct('name','CNN-SVM','namePaper','CNN-SVM'));
register('trackers', struct('name','CF2','namePaper','CF2'));
register('trackers', struct('name','LCT','namePaper','LCT'));
register('trackers', struct('name','DSST','namePaper','DSST'));
register('trackers', struct('name','MEEM','namePaper','MEEM'));
register('trackers', struct('name','KCF','namePaper','KCF'));
register('trackers', struct('name','SAMF','namePaper','SAMF'));

% Register your own tracker here. 
% 'name': The identifier of your tracker
% 'namePaper': The name of tracker's repository (folder). You can put
%              multiple versions of tracker in a single repository
% 'mainFunc': The main script to execute your tracker, subject to the 
%             protocol of OTB and Temple-Color
% 'setupFunc': The script used to initialize the environment for your tracker.
%              Leave it empty if not separate script is used. 

% Here are some examples for executing some tracking algorithms
%register('trackers', struct('name','Example','namePaper','Example','mainFunc','run_Example','setupFunc',';'));
%register('trackers', struct('name','ECO','namePaper','ECO','mainFunc','OTB_DEEP_settings','setupFunc','setup_paths'));
%register('trackers', struct('name','ECO-HC','namePaper','ECO','mainFunc','OTB_HC_settings','setupFunc','setup_paths'));
%register('trackers', struct('name','MDNet','namePaper','MDNet','mainFunc','run_MDNet','setupFunc','setup_mdnet'));

trackers = register('trackers');
register('trackers', 'clear');
end
