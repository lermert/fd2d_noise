
clear all

folder = '~/Desktop/data/';

u1 = load([folder 'data_16_ref_uniform.mat']);
u2 = load([folder 'data_16_ref_uniform_structure_2.mat']);
u3 = load([folder 'data_16_ref_uniform_structure_3.mat']);

uh = load([folder 'data_16_ref_uniform_homog_structure.mat']);
t = u1.t;

b3 = load([folder 'data_16_ref_blob3.mat']);
b3h = load([folder 'data_16_ref_blob3_homog_structure.mat']);

ub3 = load([folder 'data_16_ref_uniform_blob3.mat']);
ub3h = load([folder 'data_16_ref_uniform_blob3_homog_structure.mat']);

ub20 = load([folder 'data_16_ref_uniform_blob20.mat']);
ub20h = load([folder 'data_16_ref_uniform_blob20_homog_structure.mat']);

ub100 = load([folder 'data_16_ref_uniform_blob100.mat']);
u2b100 = load([folder 'data_16_ref_uniform_blob100_structure_2.mat']);
ub100h = load([folder 'data_16_ref_uniform_blob100_homog_structure.mat']);
ub100p = load([folder 'data_16_ref_uniform_blob100_picture_structure.mat']);

ub1000 = load([folder 'data_16_ref_uniform_blob1000.mat']);
ub1000h = load([folder 'data_16_ref_uniform_blob1000_homog_structure']);


load([folder 'array_16_ref.mat'])
n_ref = size(ref_stat,1);
n_rec = size(array,1)-1;
distances = zeros(n_ref*n_rec,1);
for i = 1:n_ref
       
    % each reference station will act as a source once
    src = ref_stat(i,:);
    rec = array( find(~ismember(array,src,'rows') ) , :);
    
    % calculate distance vector
    distances( (i-1)*n_rec + 1 : i*n_rec , 1 ) = sqrt( (src(1,1) - rec(:,1)).^2 + (src(1,2) - rec(:,2)).^2 );
    
    % calculate misfit
%     [misfit( (i-1)*n_rec + 1 : i*n_rec, :),~] = make_adjoint_sources_influence(ub100h.c_data( (i-1)*n_rec + 1 : i*n_rec , : ), ub100p.c_data( (i-1)*n_rec + 1 : i*n_rec , : ), t, 'vel', 'log_amplitude_ratio', src, rec);
%     [misfit( (i-1)*n_rec + 1 : i*n_rec, :),~] = make_adjoint_sources_influence(uh.c_data( (i-1)*n_rec + 1 : i*n_rec , : ), ub1000h.c_data( (i-1)*n_rec + 1 : i*n_rec , : ), t, 'vel', 'amplitude_difference', src, rec);
    [misfit( (i-1)*n_rec + 1 : i*n_rec, :),~] = make_adjoint_sources_influence(uh.c_data( (i-1)*n_rec + 1 : i*n_rec , : ), u2.c_data( (i-1)*n_rec + 1 : i*n_rec , : ), t, 'vel', 'cc_time_shift', src, rec);
    
end

left = distances/4000.0 - 30.0;
right = distances/4000.0 + 30.0;

if( left < 0 )
    index = find( t==0 );
    left = t(index+1);
end

if( right > t(end) )
    right = t(end);
end


sum(misfit,1)

% index = 1;
% index = 1:n_ref*n_rec;
% plot_recordings_all_windows(uh.c_data(index,:),t,'vel','k',0,left(index),right(index))
% plot_recordings_all_windows(uh.c_data(index,:),t,'vel','r',0,left(index),right(index))
% plot_recordings_all(u3.c_data(index,:),t,'vel','r',0)


