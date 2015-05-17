
function [x, info] = inversion_ipopt(array,ref_stat)

    % The starting point and lower bounds.
    x0 = reshape( ones(300,300),[],1 );
    options.lb = reshape( zeros(300,300),[],1 );        
   
    % Set the IPOPT options.
    options.ipopt.hessian_approximation     = 'limited-memory';
    options.ipopt.mu_strategy               = 'adaptive';
    
    options.ipopt.accept_every_trial_step   = 'yes';
    % options.ipopt.corrector_type            = 'affine';
    % options.ipopt.max_soc                   = 0;
    
    options.ipopt.tol                       = 1.0;
    options.ipopt.acceptable_tol            = 5.0;
    options.ipopt.acceptable_iter           = 2;
    options.ipopt.max_iter                  = 10;
    options.ipopt.print_level               = 6;
    
    % Derivative Checker
    % options.ipopt.derivative_test               = 'first-order';
    % options.ipopt.derivative_test_perturbation  = 1;
    % options.ipopt.derivative_test_tol           = 0.01;
    % options.ipopt.derivative_test_first_index   = 51351;
    % options.ipopt.derivative_test_print_all     = 'yes';

    % The callback functions.
    funcs.objective     = @objective;
    funcs.gradient      = @gradient;
    
    % Prepare auxdata
    load('../output/interferometry/data_sixteen_ref.mat');
    options.auxdata = { array, ref_stat, c_data };    
    
    % Run IPOPT.
    [x,info] = ipopt_auxdata(x0,funcs,options);

    
% ----------------------------------------------------------------------
function f = objective (x, auxdata)
    
    fprintf('Start objective function\n')
    path(path,genpath('../'))
    [array, ref_stat, c_data] = deal(auxdata{:});    
    
    f = 0;
    for i = 1:size(ref_stat,1)

        fprintf('reference station: %i\n',i)

        % each reference station will act as a source once
        src = ref_stat(i,:);
        rec = array( find(~ismember(array,src,'rows') ) , :);

        % calculate the correlation for each pair
        load(['../output/interferometry/G_2_' num2str(i) '.mat']);
        indices = (i-1)*size(rec,1) + 1 : i*size(rec,1);
        
        [c_it,t] = run_forward_source_inversion_mex( G_2, x, rec );
        [f_n,~] = make_adjoint_sources_3( c_it, c_data(indices,:), t, 'dis', 'log_amplitude_ratio', src, rec );
        
        f = f + f_n;
    end
    fprintf('f = %10.7f\n',f)
    fprintf('End objective function\n\n')


% ----------------------------------------------------------------------
function g = gradient (x, auxdata)
    
    fprintf('Start gradient\n')
    path(path,genpath('../'))
    [array, ref_stat, c_data] = deal(auxdata{:});
    
    f_sample = input_interferometry();
    K_s_all = zeros(300,300,length(f_sample));
    for i = 1:size(ref_stat,1)
                
        fprintf('reference station: %i\n',i)
        
        % each reference station will act as a source once
        src = ref_stat(i,:);
        rec = array( find(~ismember(array,src,'rows') ) , :);
        
        % compute sensitivity kernel for each reference station
        load(['../output/interferometry/G_2_' num2str(i) '.mat']);
        indices = (i-1)*size(rec,1) + 1 : i*size(rec,1);
        
        [c_it,t] = run_forward_source_inversion_mex( G_2, x, rec );
        [~,adstf] = make_adjoint_sources_3( c_it, c_data(indices,:), t, 'dis', 'log_amplitude_ratio', src, rec );
        [~,~,K_s] = run_noise_source_kernel_mex(G_2,adstf,rec);
        
        % sum all kernels
        K_s_all = K_s_all + K_s;
        
    end
    
    % smooth final kernel
    myfilter = fspecial('gaussian',[75 75], 30);
    K_s_all = imfilter(K_s_all, myfilter, 'symmetric');
    
    g = reshape( sum( K_s_all(:,:,8:33),3 ),[],1);
    fprintf('End gradient\n\n')
    
    
    