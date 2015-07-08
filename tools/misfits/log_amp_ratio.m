%==========================================================================
% compute log amplitude ratio
%
% function [misfit,adstf] = log_amp_ratio(u,u_0,win_caus,t)
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


function [misfit,adstf] = log_amp_ratio(u,u_0,win_caus,t)

dt = abs(t(2)-t(1));

% check if win_caus is on the positive time axis
[~,index] = max(win_caus);
if( t(index) < 0 )
    win_acaus = win_caus;
    win_caus = fliplr(win_acaus);
else
    win_acaus = fliplr(win_caus);
end


% window observations and synthetics
u_caus = win_caus .* u;
u_acaus = win_acaus .* u;
u_0_caus = win_caus .* u_0;
u_0_acaus = win_acaus .* u_0;


% compute energy for both windows of both observed and synthetic
e_caus = trapz( u_caus.^2 ) * dt;
e_acaus = trapz( u_acaus.^2 ) * dt + eps;
e0_caus = trapz( u_0_caus.^2 ) * dt;
e0_acaus = trapz( u_0_acaus.^2 ) * dt + eps;


% compute asymmetry
A = log( e_caus/e_acaus );
A0 = log( e0_caus/e0_acaus );


% compute misfit
misfit = 0.5 * ( A - A0 )^2;
% misfit = A0;

% compute adjoint source time function
de_caus = win_caus.^2 .* u;
de_acaus = win_acaus.^2 .* u;

if ( sum(u_0==0) == length(t) )
    adstf = 2 * ( de_caus/e_caus - de_acaus/e_acaus );
else
    adstf = 2 * ( A - A0 ) * ( de_caus/e_caus - de_acaus/e_acaus );
end

adstf = fliplr(adstf);

