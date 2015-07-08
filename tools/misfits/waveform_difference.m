%==========================================================================
% compute waveform difference
%
% function [misfit,adstf] = waveform_difference(u,u_0,t)
%
% input:
%--------
% u: synthetic displacement seismogram
% u_0: observed displacement seismogram
% t: time axis
%
% output:
%--------
% misfit
% adstf: adjoint source time function
%
%==========================================================================


function [misfit,adstf] = waveform_difference(u,u_0,t)

    adstf = fliplr( u - u_0 );
    misfit = sum(adstf.*adstf) * (t(2)-t(1));

end