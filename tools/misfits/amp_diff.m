%- compute relative amplitude difference ----------------------------------
%
% function [misfit,adsrc] = amp_diff(u,u_0,t)
%
% u: synthetic displacement seismogram
% u_0: observed displacement seismogram
% t: time axis

function [misfit,adstf] = amp_diff(u,u_0,t)

%- compute adjoint source time function and misfit ------------------------

dt = t(2)-t(1);

if sum(u_0==0) == length(t)
    
    % not sure about that    
    misfit = 1.0;
    adstf = fliplr(u) / ( sum(u.^2)*dt ) / pi;
    
else
    
    measurement = ( sum( u.^2 ) - sum( u_0.^2 ) ) / sum( u_0.^2 );
    
    % take L2 norm as misfit
    misfit = measurement^2 / 2 ;
    
    adstf = measurement * fliplr(u) / ( sum(u_0.^2)*dt ) / pi;
    
end
