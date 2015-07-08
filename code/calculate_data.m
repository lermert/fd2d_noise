
clear all
close all


% mode = 'local'
mode = 'monch';
% mode = 'euler';
% mode = 'brutus';

%huhu

%% define model
addpath(genpath('../'))
output_specs

[Lx,Lz,nx,nz,dt,nt,order,model_type,source_type] = input_parameters();
[X,Z,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);
[mu,rho] = define_material_parameters(nx,nz,model_type); 
[~,source_dist] = make_noise_source(source_type,make_plots);
[width] = absorb_specs();

if(strcmp(mode,'cluster'))
    make_plots = 'no';
end


%% define receiver array
nr_x = 4;
nr_z = 4;
array = zeros(nr_x*nr_z,2);
for i = 1:nr_x
    for j = 1:nr_z        
        array( (i-1)*nr_x + j, 1 ) = 0.9e6 + ( i-1 )*0.25e6;
        array( (i-1)*nr_z + j, 2 ) = 0.6e6 + ( j-1 )*0.25e6;
    end
end


%% select receivers that will be reference stations
ref_stat = array;


%% plot configuration
if( strcmp(make_plots,'yes') )
    figure
    hold on
    plot(array(:,1),array(:,2),'o')
    plot(ref_stat(:,1),ref_stat(:,2),'x')
    xlim([0 Lx])
    ylim([0 Lz])
    drawnow

    plot_model
end


%% start matlabpool and set up path
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


%% calculate correlations
n_ref = size(ref_stat,1);
n_rec = size(array,1)-1;
t = -(nt-1)*dt:dt:(nt-1)*dt;
c_it = zeros(n_ref,n_rec,length(t));

fprintf('\n')
flip_sr = 'no';
parfor i = 1:n_ref
    
    if( strcmp(verbose,'yes') )
        fprintf('reference station: %i\n',i)
    end
    
    % each reference station will act as a source once
    src = ref_stat(i,:);
    rec = array( find(~ismember(array,src,'rows') ) , :);
    
    % calculate the correlation for each pair
    [~,~] = run_forward('forward_green',src,rec,i,flip_sr);
    [c_it(i,:,:),~] = run_forward('correlation',src,rec,i,flip_sr);
    
    % use mex-functions
%     [G_2] = run_forward_green_fast_mex(mu, src);
%     [c_it(i,:,:), ~] = run_forward_correlation_fast_mex(G_2, source_dist, mu, rec, 0);
    
end


% reorganize correlation vector
c_data = zeros(n_ref*n_rec,length(t));
for i = 1:n_ref
    c_data( (i-1)*n_rec + 1 : i*n_rec, :) = c_it(i,:,:);
end


%% plot data
if( strcmp(make_plots,'yes') )
    figure
    plot_recordings_all(c_data,t,'vel','k-',0);
    legend('data')
end


%% save array and data for inversion
save( sprintf('../output/interferometry/array_%i_ref.mat',n_ref), 'array', 'ref_stat')
save( sprintf('../output/interferometry/data_%i_ref.mat',n_ref), 'c_data', 't')


%% close matlabpool and clean up path
if( ~strcmp(mode,'local') )
    delete(parobj)
    rmpath(genpath('../'))
end

