

path(path,genpath('../'))
folder = '~/Desktop/tests/inversion/16_ref_center/';

load([folder 'array_16_ref.mat']);
load([folder 'data_16_ref.mat']);
load([folder 'noise_dist.mat']);
load([folder 'solution_16_ref.mat'])


x0 = reshape( ones(300,300),[],1 );
for i = 1:size(ref_stat,1)
    
    fprintf('reference station: %i\n',i)
    
    % each reference station will act as a source once
    src = ref_stat(i,:);
    rec = array( find(~ismember(array,src,'rows') ) , :);
    
    % calculate the correlation for each pair
    load([folder 'green/G_2_' num2str(i) '.mat']);
    indices = (i-1)*size(rec,1) + 1 : i*size(rec,1);
    
    [c_start(indices,:),~] = run_forward_source_fast_mex( G_2, x0, rec );
    [c_final(indices,:),t] = run_forward_source_fast_mex( G_2, x, rec );
    
end


% plot correlations
figure
hold on
h(1,:) = plot_recordings_all(c_data,t,'vel','k-',0);
h(2,:) = plot_recordings_all(c_start,t,'vel','r-',0);
h(3,:) = plot_recordings_all(c_final,t,'vel','b-',0);
legend(h,'data','start (uniform)','final')


% plot noise source distributions
load propagation/cm_psd.mat

figure
subplot(2,1,1)
mesh(10*reshape(x,300,300))
axis equal
xlim([0 300])
ylim([0 300])
zlim([0 110])
% shading interp
colormap(cm_psd)
% colorbar
caxis([0 110])

subplot(2,1,2)
mesh(10*noise_source_distribution)
axis equal
xlim([0 300])
ylim([0 300])
zlim([0 110])
% shading interp
colormap(cm_psd)
% colorbar
caxis([0 110])

