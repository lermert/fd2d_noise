
close all

tic


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type = 'source';
% type = 'structure';

measurement = 4;
% 1 = 'log_amplitude_ratio';
% 2 = 'amplitude_difference';
% 3 = 'waveform_difference';
% 4 = 'cc_time_shift';

% load receiver array
load('../output/interferometry/array_1_ref_big_off_center.mat')

data_independent = 'yes';
% if 'no', specify .mat file with data
% load('../output/interferometry/data_1_ref_structure_slow_uniform_blob.mat')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('../'))
[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
[width,absorb_left,absorb_right,absorb_top,absorb_bottom] = absorb_specs();
output_specs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate "initial" correlation and misfit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

misfit = 0;
nr = size(array,1)-1;
fprintf('\n')

flip_sr = 'no';
for i = 1:size(ref_stat,1)
    
    if( strcmp(verbose,'yes') )
        fprintf('reference station: %i\n',i)
    end
    
    % each reference station will act as a source once
    src = ref_stat(i,:);
    rec = array( find(~ismember(array,src,'rows') ) , :);
    
    % calculate the correlation for each pair
    fprintf('calculate green function\n')
    [~,~] = run_forward('forward_green',src,rec,i,flip_sr);
    fprintf('calculate correlation\n')
    [c_uniform( (i-1)*nr + 1 : i*nr , :),t] = run_forward('correlation',src,rec,i,flip_sr);
    
    % make measurement and adjoint source time function
    if( strcmp(data_independent,'yes') )
        c_data = 0.0 * c_uniform;
    end

    switch measurement
        case 1
            misfit = misfit + make_adjoint_sources(c_uniform( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'log_amplitude_ratio', src, rec, i, flip_sr);
        case 2
            misfit = misfit + make_adjoint_sources(c_uniform( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'amplitude_difference', src, rec, i, flip_sr);
        case 3
            misfit = misfit + make_adjoint_sources(c_uniform( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'waveform_difference', src, rec, i, flip_sr);
        case 4
            misfit = misfit + make_adjoint_sources(c_uniform( (i-1)*nr+1 : i*nr , :), c_data( (i-1)*nr+1 : i*nr , :), t, 'dis', 'cc_time_shift', src, rec, i, flip_sr);
        otherwise
            error('\nspecify correct measurement!\n\n')
    end
    
end


% plot data and synthetics
if (strcmp(make_plots,'yes'))
    figure
    hold on
    if( strcmp(data_independent,'yes') )
        h(1,:) = plot_recordings_all(c_uniform,t,'vel','r-',0);
        legend(h,'uniform')
    else
        h(1,:) = plot_recordings_all(c_data,t,'vel','k-',0);
        h(2,:) = plot_recordings_all(c_uniform,t,'vel','r-',0);
        legend(h,'data','uniform')
    end
    drawnow
end


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
        
        % compute sensitivity kernel for each reference station
        fprintf('calculate source kernel\n')
        [X,Z,K_s(:,:,:,i)] = run_noise_source_kernel('noise_source_kernel',i);
        
        % sum all kernels
        K_s_all = K_s_all + K_s(:,:,:,i);
        
    end
    
    plot_noise_source_kernels(X,Z,K_s_all,src,rec)

    
% -------------------------------------------------------------------------
% structure inversion
% -------------------------------------------------------------------------
elseif( strcmp(type,'structure') )
    
    K_rho_1 = zeros(nx,nz,size(array,1));
    K_rho_2 = zeros(nx,nz,size(array,1));
    K_mu_1 = zeros(nx,nz,size(array,1));
    K_mu_2 = zeros(nx,nz,size(array,1));
    K_rho_all = zeros(nx,nz);
    K_mu_all = zeros(nx,nz);
    
    fprintf('\n')
    for i = 1:size(ref_stat,1)
        
        if( strcmp(verbose,'yes') )
            fprintf('reference station: %i\n',i)
        end
                        
        % each reference station will act as a source once
        src = ref_stat(i,:);
        rec = array( find(~ismember(array,src,'rows') ) , :);
        
        % calculate first part of structure kernel
        flip_sr = 'no';
        fprintf('calculate first structure kernel\n')
        [~,~,K_rho_1(:,:,i),K_mu_1(:,:,i)] = run_noise_structure_kernel('noise_structure_kernel',i,flip_sr);
        
        % calculate second part of structure kernel
        flip_sr = 'yes';
        % fprintf('calculate green function\n')
        % [~,~] = run_forward('forward_green',src,rec,i,flip_sr);
        fprintf('calculate correlation\n')
        [c_uniform_2( (i-1)*nr + 1 : i*nr , :),t] = run_forward('correlation',src,rec,i,flip_sr);
                
        % make measurement and adjoint source time function
        if( strcmp(data_independent,'yes') )
            c_data = 0.0 * c_uniform_2;
        end
    
        switch measurement
            case 1
                misfit = misfit + make_adjoint_sources(c_uniform_2( (i-1)*nr+1 : i*nr , :), fliplr(c_data( (i-1)*nr+1 : i*nr , :)), t, 'dis', 'log_amplitude_ratio', src, rec, i, flip_sr);
            case 2
                misfit = misfit + make_adjoint_sources(c_uniform_2( (i-1)*nr+1 : i*nr , :), fliplr(c_data( (i-1)*nr+1 : i*nr , :)), t, 'dis', 'amplitude_difference', src, rec, i, flip_sr);
            case 3
                misfit = misfit + make_adjoint_sources(c_uniform_2( (i-1)*nr+1 : i*nr , :), fliplr(c_data( (i-1)*nr+1 : i*nr , :)), t, 'dis', 'waveform_difference', src, rec, i, flip_sr);
            case 4
                misfit = misfit + make_adjoint_sources(c_uniform_2( (i-1)*nr+1 : i*nr , :), fliplr(c_data( (i-1)*nr+1 : i*nr , :)), t, 'dis', 'cc_time_shift', src, rec, i, flip_sr);
            otherwise
                error('\nspecify correct measurement!\n\n')
        end
        
        % calculate second structure kernel
        fprintf('calculate second structure kernel\n')
        [X,Z,K_rho_2(:,:,i),K_mu_2(:,:,i)] = run_noise_structure_kernel('noise_structure_kernel',i,flip_sr);        
        
        % sum kernels
        K_rho_all = K_rho_all + K_rho_1(:,:,i) + K_rho_2(:,:,i);        
        K_mu_all = K_mu_all + K_mu_1(:,:,i) + K_mu_2(:,:,i);        
        
        % plot kernels        
        plot_noise_structure_kernels_test
        % plot_noise_structure_kernels(X,Z,K_rho_all)
        
    end
    
end


% clean up
rmpath(genpath('../'))
toc
