
clear all
close all

tic

path(path,genpath('../'))

% type = 'source';
type = 'structure';

load('../output/interferometry/array_1_ref.mat')
load('../output/interferometry/data_1_ref.mat')

[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
[width,absorb_left,absorb_right,absorb_top,absorb_bottom] = absorb_specs();
output_specs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate "initial" correlation and misfit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

misfit = 0;
nr = size(array,1)-1;
flip_sr = 'no';
fprintf('\n')
for i = 1:size(ref_stat,1)
    
    if( strcmp(verbose,'yes') )
        fprintf('reference station: %i\n',i)
    end
    
    % each reference station will act as a source once
    src = ref_stat(i,:);
    rec = array( find(~ismember(array,src,'rows') ) , :);
    
    % calculate the correlation for each pair
    [~,~] = run_forward('forward_green',src,rec,i,flip_sr);
    [c_uniform( (i-1)*nr + 1 : i*nr , :),t] = run_forward('correlation',src,rec,i,flip_sr);
  
%     misfit = misfit + make_adjoint_sources(c_uniform( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'log_amplitude_ratio', src, rec, i, flip_sr);
%     misfit = misfit + make_adjoint_sources(c_uniform( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'amplitude_difference', src, rec, i, flip_sr);
%     misfit = misfit + make_adjoint_sources(c_uniform( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'waveform_difference', src, rec, i, flip_sr);
    misfit = misfit + make_adjoint_sources(c_uniform( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'cc_time_shift', src, rec, i, flip_sr);
    
end


% plot data and synthetics
figure
hold on
h(1,:) = plot_recordings_all(c_data,t,'vel','k-',0);
h(2,:) = plot_recordings_all(c_uniform,t,'vel','r-',0);
legend(h,'data','uniform')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate kernels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------------------------------------------------------------
% source inversion
% -------------------------------------------------------------------------
if( strcmp(type,'source') )
    
    f_sample = input_interferometry();
    K_s = zeros(nx,nz,length(f_sample),size(array,1));
    K_s_all = zeros(nx,nz,length(f_sample));
    fprintf('\n')
    for i = 1:size(ref_stat,1)
        
        if( strcmp(verbose,'yes') )
            fprintf('reference station: %i\n',i)
        end
        
        % each reference station will act as a source once
        src = ref_stat(i,:);
        rec = array( find(~ismember(array,src,'rows') ) , :);
        
        % compute sensitivity kernel for each reference station
        [X,Z,K_s(:,:,:,i)] = run_noise_source_kernel('noise_source_kernel',i);
        
        % sum all kernels
        K_s_all = K_s_all + K_s(:,:,:,i);
        
    end
    
    plot_noise_source_kernels(X,Z,K_s_all,src,rec)

    
    
% -------------------------------------------------------------------------
% structure inversion
% -------------------------------------------------------------------------
elseif( strcmp(type,'structure') )
    
    fprintf('\n')
    for i = 1:size(ref_stat,1)
        
        [~,~,K_rho_1,K_mu_1] = run_noise_structure_kernel('noise_structure_kernel',i,flip_sr);
        
        flip_sr = 'yes';
        [~,~] = run_forward('forward_green',src,rec,i,flip_sr);
        [c_uniform_2,tc] = run_forward('correlation',src,rec,i,flip_sr);
        
        % misfit = misfit + make_adjoint_sources(c_uniform_2( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'waveform_difference', src, rec, i, flip_sr);
        misfit = misfit + make_adjoint_sources(c_uniform_2( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'cc_time_shift', src, rec, i, flip_sr);
        
        [X,Z,K_rho_2,K_mu_2] = run_noise_structure_kernel('noise_structure_kernel',i,flip_sr);
        
        K_rho_uniform = K_rho_1 + K_rho_2;
        plot_noise_structure_kernels(X,Z,K_rho_uniform)
        
    end
    
end


toc
