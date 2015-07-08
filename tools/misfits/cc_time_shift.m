%==========================================================================
% compute cross correlation time shift
%
% function [misfit,adstf] = cc_time_shift(u,u_0,t)
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

function [misfit,adstf] = cc_time_shift(u,u_0,t)

    
%- compute time shift -----------------------------------------------------

if sum(u_0==0) == length(t)
    T = 1.0;
else
    [cc,t_cc] = cross_correlation_td(u,u_0,t);
    [~,i_max] = max(cc);
    T = t_cc(i_max);
    if(abs(T)>3.5)
        T=0;
    end
end


%- compute adjoint source time function -----------------------------------

dt = t(2)-t(1);
nt = length(t);

v = zeros(1,nt);
% v_0 = zeros(1,nt);

v(1:nt-1) = diff(u)/dt;
% v_0(1:nt-1) = diff(u_0)/dt;

% if sum(u_0==0) == length(t)   
    adstf = T * fliplr(v) / (sum(v.*v)*dt) / (2*pi);
% else
%     v_0_shifted = zeros(1,nt);
%     if( T > 0 )
%         v_0_shifted( 1:(nt-abs(T)/dt) ) = v_0( (abs(T)/dt+1):nt );
%     else
%         v_0_shifted( abs(T)/dt+1:nt ) = v_0( 1:(nt-abs(T)/dt) );
%     end
%     
%     adstf = T * fliplr(v_0_shifted) / ( sum(v_0_shifted .* v)*dt );
% end


%- compute misfit ---------------------------------------------------------

misfit = T^2/2.0;
