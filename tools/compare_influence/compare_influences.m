
clear all

addpath(genpath('../../'))

folder = '~/Desktop/runs/inversion/data/';

u_h = load([folder 'data_16_ref_uniform_homog_structure.mat']);
u_1 = load([folder 'data_16_ref_uniform_structure_1.mat']);
u_2 = load([folder 'data_16_ref_uniform_structure_2.mat']);
u_3 = load([folder 'data_16_ref_uniform_structure_3.mat']);

b3_1 = load([folder 'data_16_ref_blob3_structure_1.mat']);
b3_h = load([folder 'data_16_ref_blob3_homog_structure.mat']);

ub3_1 = load([folder 'data_16_ref_uniform_blob3_structure_1.mat']);
ub3_h = load([folder 'data_16_ref_uniform_blob3_homog_structure.mat']);

ub20_1 = load([folder 'data_16_ref_uniform_blob20_structure_1.mat']);
ub20_h = load([folder 'data_16_ref_uniform_blob20_homog_structure.mat']);

ub100_1 = load([folder 'data_16_ref_uniform_blob100_structure_1.mat']);
ub100_2 = load([folder 'data_16_ref_uniform_blob100_structure_2.mat']);
ub100_3 = load([folder 'data_16_ref_uniform_blob100_structure_3.mat']);
ub100_h = load([folder 'data_16_ref_uniform_blob100_homog_structure.mat']);
ub100_p2 = load([folder 'data_16_ref_uniform_blob100_picture_rand_2.mat']);
ub100_p3 = load([folder 'data_16_ref_uniform_blob100_picture_rand_3.mat']);

ub1000_1 = load([folder 'data_16_ref_uniform_blob1000_structure_1.mat']);
ub1000_h = load([folder 'data_16_ref_uniform_blob1000_homog_structure']);

ub10000_1 = load([folder 'data_16_ref_uniform_blob10000_structure_1.mat']);


load([folder 'array_16_ref.mat'])
n_ref = size(ref_stat,1);
n_rec = size(array,1)-1;
t = u_h.t;
distances = zeros(n_ref*n_rec,1);
first = zeros(n_ref*n_rec,length(t));
second = zeros(n_ref*n_rec,length(t));
for i = 1:n_ref
       
    % each reference station will act as a source once
    src = ref_stat(i,:);
    rec = array( find(~ismember(array,src,'rows') ) , :);
    
    % calculate distance vector
    distances( (i-1)*n_rec + 1 : i*n_rec , 1 ) = sqrt( (src(1,1) - rec(:,1)).^2 + (src(1,2) - rec(:,2)).^2 );
    
    % calculate misfit
    indices = (i-1)*n_rec + 1 : i*n_rec;
    
%     veldis = 'vel';
    veldis = 'dis';
    first(indices,:) = u_h.c_data( indices , : );
    second(indices,:) = ub3_h.c_data( indices , : );
    
    [misfit( (i-1)*n_rec + 1 : i*n_rec, :),~] = misfits(first(indices,:), second(indices,:), t, veldis, 'log_amplitude_ratio', src, rec);
%     [misfit( (i-1)*n_rec + 1 : i*n_rec, :),~] = misfits(first(indices,:), second(indices,:), t, veldis, 'amplitude_difference', src, rec);
%     [misfit( (i-1)*n_rec + 1 : i*n_rec, :),~] = misfits(first(indices,:), second(indices,:), t, veldis, 'cc_time_shift', src, rec);
%     [misfit( (i-1)*n_rec + 1 : i*n_rec, :),~] = misfits(first(indices,:), second(indices,:), t, veldis, 'waveform_difference', src, rec);
    
end

left = distances/4000.0 - 27.0;
right = distances/4000.0 + 27.0;

if( left < 0 )
    index = find( t==0 );
    left = t(index+1);
end

if( right > t(end) )
    right = t(end);
end


sum(abs(misfit),1)
max(abs(misfit))


% % index = 165:180;
% index = 1:n_ref*n_rec;
% plot_recordings_all_windows(first(index,:),t,'vel','k',0,left(index),right(index));
% % % plot_recordings_all_windows(second(index,:),t,'dis','r',0,left(index),right(index));
% plot_recordings_all(second(index,:),t,'vel','r',0);


rmpath(genpath('../../'))
run ../startup.m
