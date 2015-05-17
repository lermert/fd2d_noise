
function inversion_dummy()
   
    % start matlabpool
    cluster = parcluster('EulerLSF');
    matlabpool(cluster,16)

    % The starting point and lower bounds.
    % x0 = reshape( ones(300,300),[],1 );
    load('initial.mat');
    x0 = reshape(x0,[],1);
    
    % Set options optimization
    options.tol                 = 1e-4;
    options.acceptable_change   = 1.0;
    options.acceptable_iter     = 10;
    options.max_iter            = 10;
    
    % The callback functions.
    funcs.objective     = @objective;
    funcs.gradient      = @gradient;
    
    % Prepare auxdata
    load('../../output/interferometry/array_16_ref.mat');
    load('../../output/interferometry/data_16_ref.mat');
    options.auxdata = { array, ref_stat, c_data };    
    
    % Run IPOPT.
    [x,info] = steepest_descent_dummy(x0,funcs,options);
    save solution.mat x info
    
    % close matlabpool
    matlabpool close   
    

    
% ----------------------------------------------------------------------
function f = objective (x, auxdata)
    
    % fprintf('Start objective function\n')
    
    path(path,genpath('../../'))
    [array, ref_stat, c_data] = deal(auxdata{:});    
    
    f = 0;
    parfor i = 1:size(ref_stat,1)

        % fprintf('reference station: %i\n',i)

        % each reference station will act as a source once
        src = ref_stat(i,:);
        rec = array( find(~ismember(array,src,'rows') ) , :);

        % calculate the correlation for each pair
        G_2 = load(['../output/interferometry/G_2_' num2str(i) '.mat']);
        indices = (i-1)*size(rec,1) + 1 : i*size(rec,1);
        
        [c_it,t] = run_forward_source_fast_mex( G_2.G_2, x, rec );
%         [f_n,~] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'log_amplitude_ratio', src, rec );
%         [f_n,~] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'cc_time_shift', src, rec );
        [f_n,~] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'amplitude_difference', src, rec );
        
        f = f + f_n;
    end
    
    % fprintf('f = %10.7f\n',f)
    % fprintf('End objective function\n\n')

    
% ----------------------------------------------------------------------
function g = gradient (x, auxdata)
    
    % fprintf('Start gradient\n')
    path(path,genpath('../../'))
    [array, ref_stat, c_data] = deal(auxdata{:});
    
    f_sample = input_interferometry();
    K_s_all = zeros(300,300,length(f_sample));
    parfor i = 1:size(ref_stat,1)
                
        % fprintf('reference station: %i\n',i)
        
        % each reference station will act as a source once
        src = ref_stat(i,:);
        rec = array( find(~ismember(array,src,'rows') ) , :);
        
        % compute sensitivity kernel for each reference station
        G_2 = load(['../../output/interferometry/G_2_' num2str(i) '.mat']);
        indices = (i-1)*size(rec,1) + 1 : i*size(rec,1);
        
        [c_it,t] = run_forward_source_fast_mex( G_2.G_2, x, rec );
%         [~,adstf] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'log_amplitude_ratio', src, rec );
        [~,adstf] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'amplitude_difference', src, rec );
%         [~,adstf] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'waveform_difference', src, rec );
%         [~,adstf] = make_adjoint_sources_inversion( c_it, c_data(indices,:), t, 'dis', 'cc_time_shift', src, rec );
        [~,~,K_s] = run_noise_source_kernel_fast_mex(G_2.G_2,adstf,rec);
        
        % sum all kernels
        K_s_all = K_s_all + K_s;
        
    end
    
    % smooth final kernel
    myfilter = fspecial('gaussian',[75 75], 30);
    K_s_all = imfilter(K_s_all, myfilter, 'symmetric');
    
    g = reshape( sum( K_s_all(:,:,8:33),3 ),[],1);
    % fprintf('End gradient\n\n')
    
    
    