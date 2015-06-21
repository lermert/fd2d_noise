
function [f_sample] = input_interferometry()

%==========================================================================
% input parameters for interferometry
%==========================================================================

%- frequency sampling in Hz -----------------------------------------------
%- The sampling should be evenly spaced for the inverse F transform.-------
%- The sampling must also be sufficiently dense in order to avoid artefacts
%- on the positive time axis in the time-domain source function. This can 
%- be checked with "/tools/check_correlation_source_function".

%- It is sufficient to consider the positive frequency axis. 

% f_sample=0.05:0.004:0.2;

f_sample=0.05:0.002:0.2;