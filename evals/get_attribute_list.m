function [attribute_names, att_names_long] = get_attribute_list
% GET_ATTRIBUTE_LIST Returns a list of attributes short and long names to
% use when plotting per attribute results
%

dataset = get_global_variable('dataset');

switch dataset
    case {'OTB2013', 'OTB50', 'OTB100', 'TCOLOR128'}
        att_names_long = {'Illumination Variation' 'Out-of-Plane Rotation'	'Scale Variation'	...
            'Occlusion'	'Deformation'	'Motion Blur'	'Fast Motion'	'In-Plane Rotation'	...
            'Out of View'	'Background Clutter' 'Low Resolution'};
        attribute_names = {'IV' 'OPR' 'SV' 'OCC' 'DEF' 'MB' 'FM' 'IPR' 'OV' 'BC' 'LR'};        
end

end