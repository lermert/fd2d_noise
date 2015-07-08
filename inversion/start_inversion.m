
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mode = 'local'
mode = 'monch';
% mode = 'euler';
% mode = 'brutus';

type = 'source';
% type = 'source_constrained';
% type = 'structure';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% running the inversion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% start matlabpool and set up path
if( strcmp(mode,'monch') )
    addpath(genpath('../'))
    
    jobid = getenv('SLURM_JOB_ID');
    mkdir(jobid);
    cluster = parallel.cluster.Generic('JobStorageLocation', jobid);
    set(cluster, 'HasSharedFilesystem', true);
    set(cluster, 'ClusterMatlabRoot', '/apps/common/matlab/r2015a/');
    set(cluster, 'OperatingSystem', 'unix');
    set(cluster, 'IndependentSubmitFcn', @independentSubmitFcn);
    set(cluster, 'CommunicatingSubmitFcn', @communicatingSubmitFcn);
    set(cluster, 'GetJobStateFcn', @getJobStateFcn);
    set(cluster, 'DeleteJobFcn', @deleteJobFcn);

    parobj = parpool(cluster,16);
    
elseif( strcmp(mode,'euler') || strcmp(mode,'brutus') )
    addpath(genpath('../'))
    if( strcmp(mode,'euler') )
        cluster = parcluster('EulerLSF8h');
    elseif( strcmp(mode,'brutus') )
        cluster = parcluster('BrutusLSF8h');
    end
        
    jobid = getenv('LSB_JOBID');
    mkdir(jobid);
    cluster.JobStorageLocation = jobid;
    cluster.SubmitArguments = '-W 12:00 -R "rusage[mem=3072]"';
    parobj = parpool(cluster,16);
    
end


% get model dimensions
[~,~,nx,nz] = input_parameters();


% run source inversion
if( strcmp(type,'source') )
    x0 = ones(nx*nz, 1);
    [x,c_final] = steepest_descent(x0,'get_obj_grad',0.05,0);

% run source inversion with lower and upper bounds
elseif( strcmp(type,'source_constrained') )
    x0 = ones(nx*nz, 1);
    xl = zeros(nx*nz, 1);
    xu = inf(nx*nz, 1);
    [x,c_final] = projected_steepest_descent(x0,xl,xu,'get_obj_grad',0.05,0);

% run structure inversion
elseif( strcmp(type,'source') )
    x0 = zeros(nx*nz, 1);
    % [x] = LBFGS(x0,'get_obj_grad',0.05,5);
    [x,c_final] = steepest_descent(x0,'get_obj_grad',0.05,0);
    x = 4.8e10 * ( 1 + x );
end


% save solution
save('../output/solution.mat', 'x', 'c_final')


% close matlabpool and clean up path
if( ~strcmp(mode,'local') )
    delete(parobj)
    rmpath(genpath('../'))
end

