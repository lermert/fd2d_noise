%- compute cross correlation function in time domain ----------------------
%
% function [cc,t_cc] = cross_correlation_td(f,g,t)
%
% cc_i = sum_j f^*(j) g(j+i)

function [cc,t_cc] = cross_correlation_td(f,g,t)

%- initialisations --------------------------------------------------------

n = length(f);
dt = t(2)-t(1);
t_cc = -(n-1)*dt:dt:(n-1)*dt;

%- compute brute-force correlation function -------------------------------

cc = xcorr(g,f);