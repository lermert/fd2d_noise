
clear all
close all


% mode = 'local';
mode = 'cluster';


% define model
addpath(genpath('../'))
[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
[X,Z,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);
[mu,rho] = define_material_parameters(nx,nz,model_type); 
[width] = absorb_specs();
output_specs
if(strcmp(mode,'cluster'))
    make_plots = 'no';
end

% define receiver array
nr_x = 4;
nr_z = 4;
array = zeros(nr_x*nr_z,2);
for i = 1:nr_x
    for j = 1:nr_z
        % array( (i-1)*nr_x + j, 1 ) = 4*width + ( i-1 )*(Lx-8*width)/(nr_x-1);
        % array( (i-1)*nr_z + j, 2 ) = 4*width + ( j-1 )*(Lz-8*width)/(nr_z-1);
        
        array( (i-1)*nr_x + j, 1 ) = 0.9e6 + ( i-1 )*0.25e6;
        array( (i-1)*nr_z + j, 2 ) = 0.6e6 + ( j-1 )*0.25e6;
    end
end

% nr_x = 2;
% nr_z = 1;
% array = zeros(nr_x*nr_z,2);
% for i = 1:nr_x
%         array( i, 1 ) = Lx/2 + (-1)^i * 0.15*Lx;
%         % array( i, 1 ) = Lx/2 + (-1)^i * 0.08*Lx - Lx/5;
%         array( i, 2 ) = Lz/2;
% end



% select receivers that will be reference stations
% ref_stat = array(1,:);
ref_stat = array;


% plot configuration
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


% start matlabpool
if(strcmp(mode,'cluster'))
    cluster = parcluster('EulerLSF');
    % cluster = parcluster('BrutusLSF');
    jobid = getenv('LSB_JOBID');
    mkdir(jobid);
    cluster.JobStorageLocation = jobid;
    cluster.SubmitArguments = '-W 8:00 -R "rusage[mem=3072]"';
    matlabpool(cluster,16)
end


% calculate correlations
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
    
end


% reorganize correlation vector
c_data = zeros(n_ref*n_rec,length(t));
for i = 1:n_ref
    c_data(i*n_rec,:) = c_it(i,:,:);
end


% plot data
if( strcmp(make_plots,'yes') )
    figure
    plot_recordings_all(c_data,t,'vel','k-',0);
    legend('data')
end


% save array and data for inversion
save( sprintf('../output/interferometry/array_%i_ref_big_test1.mat',n_ref), 'array', 'ref_stat')
save( sprintf('../output/interferometry/data_%i_ref_big_test1.mat',n_ref), 'c_data', 't')


% close matlabpool
if(strcmp(mode,'cluster'))
    matlabpool close
end


% clean up
rmpath(genpath('../'))

