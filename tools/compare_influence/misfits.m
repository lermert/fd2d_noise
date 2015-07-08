%==========================================================================
% compute adjoint sources
%
% function [misfit_n,adstf] = misfits(u,u_0,t,veldis,measurement,src,rec)
%
% input:
%-------
% u: synthetic displacement seismograms
% u_0: "observed" displacement seismograms
% t: time axis
% veldis: 'dis' for displacements, 'vel' for velocities
% measurement:  'log_amplitude_ratio'
%               'amplitude_difference'
%               'waveform_difference' 
%               'cc_time_shift'
% src: source position
% rec: receiver positions
% i_ref: number of reference station
% flip_sr: flip source and receiver, important for structure kernel
%
% output:
%-------
% misfit_n: misfit of each receivers
% adstf: adjoint source time functions for each receiver
%
%
% When u_0, i.e. the observed displacement seismograms, are set to zero, 
% the code performs data-independent measurements. 
% 
%==========================================================================


function [misfit_n,adstf] = misfits(u,u_0,t,veldis,measurement,src,rec)

%==========================================================================
%- initialisations --------------------------------------------------------
%==========================================================================

nt = length(t);
dt = t(2) - t(1);
n_receivers = size(rec,1);

%- convert to velocity if wanted ------------------------------------------
if strcmp(veldis,'vel')
    
    v = zeros(n_receivers,nt);
    v_0 = zeros(n_receivers,nt);
    
    for k=1:n_receivers
        v(k,1:nt-1) = diff(u(k,:))/(t(2)-t(1));
        v_0(k,1:nt-1) = diff(u_0(k,:))/(t(2)-t(1));
    end
   
    u = v;
    u_0 = v_0;
    
end


%==========================================================================
%- march through the various recodings ------------------------------------
%==========================================================================

misfit_n = zeros(n_receivers,1);
adstf = zeros(n_receivers,nt);
for n=1:n_receivers
   
    %- select time windows and taper seismograms --------------------------   
    % disp('select left window');
    % [left,~] = ginput(1)
    % disp('select_right_window');
    % [right,~] = ginput(1)

    if strcmp(measurement,'waveform_difference')
        left = t(1);
        right = t(end);
    
    else        
        distance = sqrt( (src(1,1) - rec(n,1)).^2 + (src(1,2) - rec(n,2)).^2 );
        left = distance/4000.0 - 27.0;
        right = distance/4000.0 + 27.0;
        
        if( left < 0 )
            index = find( t==0 );
            left = t(index+1);
        end
        
        if( right > t(end) )
            right = t(end);
        end
        
    end


    width = t(end)/10;
    u_sel = taper(u(n,:),t,left,right,width);
    u_0_sel = taper(u_0(n,:),t,left,right,width);
    
    
    %- compute misfit and adjoint source time function --------------------    
    if strcmp(measurement,'waveform_difference')
        [misfit_n(n,:),adstf(n,:)] = waveform_difference(u_sel,u_0_sel,t);
        
    elseif strcmp(measurement,'cc_time_shift')       
        [misfit_n_caus,adstf_caus(1,:)] = cc_time_shift(u_sel,u_0_sel,t);
        
        tmp = left;
        left = -right;
        right = -tmp;
        clear tmp;
        
        u_sel = taper(u(n,:),t,left,right,width);
        u_0_sel = taper(u_0(n,:),t,left,right,width);
        
        [misfit_n_acaus,adstf_acaus(1,:)] = cc_time_shift(u_sel,u_0_sel,t);
        
        misfit_n(n,:) = misfit_n_caus + misfit_n_acaus;
        adstf(n,:) = adstf_caus + adstf_acaus;
        
    elseif strcmp(measurement,'amplitude_difference')        
        [misfit_n_caus,adstf_caus(1,:)] = amp_diff(u_sel,u_0_sel,t);
        
        tmp = left;
        left = -right;
        right = -tmp;
        clear tmp;
        
        u_sel = taper(u(n,:),t,left,right,width);
        u_0_sel = taper(u_0(n,:),t,left,right,width);
        
        [misfit_n_acaus,adstf_acaus(1,:)] = amp_diff(u_sel,u_0_sel,t);
        
        misfit_n(n,:) = misfit_n_caus + misfit_n_acaus;
        adstf(n,:) = adstf_caus + adstf_acaus;
        
    elseif strcmp(measurement,'log_amplitude_ratio')    
        win = get_window(t,left,right,'hann');
        [misfit_n(n,:),adstf(n,:)] = log_amp_ratio(u(n,:),u_0(n,:),win,t);
        
    end
    
    
    %- correct adjoint source time function for velocity measurement ------    
    if strcmp(veldis,'vel')
        adstf(n,1:nt-1) = -diff(adstf(n,:))/dt;
    end      

    
end


