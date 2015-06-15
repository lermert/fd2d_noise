
function [f,g] = get_obj_grad(x)
    
    verbose = 'no';
    
    path(path,genpath('../'))
    load('../output/interferometry/array_1_ref.mat');
    load('../output/interferometry/data_1_ref.mat');
    
    if( strcmp(verbose,'yes') )
        fprintf('Start gradient\n')
    end
    
    f = 0;
    f_sample = input_interferometry();
    K_s_all = zeros(300,300,length(f_sample));
    for i = 1:size(ref_stat,1)
        
        if( strcmp(verbose,'yes') )
            fprintf('reference station: %i\n',i)
        end
        
        % each reference station will act as a source once
        src = ref_stat(i,:);
        rec = array( find(~ismember(array,src,'rows') ) , :);
        
        % compute sensitivity kernel for each reference station
        G_2 = load(['../output/interferometry/G_2_' num2str(i) '.mat']);
        indices = (i-1)*size(rec,1) + 1 : i*size(rec,1);
        
        [c_it,t] = run_forward_source_fast( G_2.G_2, x, rec );
        % [f_n,adstf] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'log_amplitude_ratio', src, rec );
        % [f_n,adstf] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'amplitude_difference', src, rec );
        % [f_n,adstf] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'waveform_difference', src, rec );
        [f_n,adstf] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'cc_time_shift', src, rec );
        [~,~,K_s] = run_noise_source_kernel_fast(G_2.G_2,adstf,rec);
        
        % sum all kernels
        K_s_all = K_s_all + K_s;
        
        % sum up misfits
        f = f + f_n;
        fprintf('misfit: %f\n',f)
        
    end
    
    % smooth final kernel
    % myfilter = fspecial('gaussian',[75 75], 30);
    myfilter = fspecial('gaussian',[40 40], 20);
    K_s_all = imfilter(K_s_all, myfilter, 'symmetric');
    g = reshape( sum( K_s_all(:,:,8:33),3 ),[],1);
    
    if( strcmp(verbose,'yes') )
        fprintf('End gradient\n\n')
    end
    
end
