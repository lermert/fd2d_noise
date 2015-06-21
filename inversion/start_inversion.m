
% mode = 'local';
mode = 'cluster';


% start matlabpool and set up path
if(strcmp(mode,'cluster'))
    addpath(genpath('../'))
    
    cluster = parcluster('EulerLSF8h');
    % cluster = parcluster('BrutusLSF8h');
    jobid = getenv('LSB_JOBID');
    mkdir(jobid);
    cluster.JobStorageLocation = jobid;
    cluster.SubmitArguments = '-W 8:00 -R "rusage[mem=3072]"';
    matlabpool(cluster,16)
end


% get model dimensions
[~,~,nx,nz] = input_parameters();


% run source inversion
x0 = ones(nx*nz, 1);
[x,c_final] = steepest_descent(x0,'get_obj_grad',0.5,0);


% run structure inversion
% x0 = zeros(nx*nz, 1);
% [x,c_final] = 4.8e10 * ( 1 + LBFGS(x0,'get_obj_grad',0.05,5) );
% [x,c_final] = 4.8e10 * ( 1 + steepest_descent(x0,'get_obj_grad',0.05,0) );


% save solution
save ../output/solution.mat x c_final


% close matlabpool and clean up path
if(strcmp(mode,'cluster'))
    matlabpool close
    rmpath(genpath('../'))
end

