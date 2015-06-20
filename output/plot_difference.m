
clear all

type = 'source';
% type = 'structure';

measurement = 'log_a';
% measurement = 'cc';
% measurement = 'wd';

folder_0 = '~/Desktop/inversion';

folder_1 = 'true_structure';
folder_2 = 'error_in_structure';


n_models = length( dir([folder_0 '/' type '/' folder_1 '/' measurement '/model_*']) );
x_1 = load([folder_0 '/' type '/' folder_1 '/' measurement '/model_3']);
x_2 = load([folder_0 '/' type '/' folder_1 '/' measurement '/model_' num2str(floor(n_models/2))]);
x_3 = load([folder_0 '/' type '/' folder_1 '/' measurement '/model_' num2str(n_models)]);

x_4 = load([folder_0 '/' type '/' folder_2 '/' measurement '/model_3']);
x_5 = load([folder_0 '/' type '/' folder_2 '/' measurement '/model_' num2str(floor(n_models/2))]);
x_6 = load([folder_0 '/' type '/' folder_2 '/' measurement '/model_' num2str(n_models)]);

load('../output/interferometry/array_16_ref_big_test1.mat')

if( strcmp(type,'source') )
    load('../inversion/true_source.mat')
    true = source_dist;
    
    z_limits = [-0.2 0.2];
    c_limits = [-0.2 0.2];
    array_level = 0.2;
    
elseif( strcmp(type,'structure') )
    load('../inversion/true_mu.mat')
    true = mu;
    
    z_limits = [4.1 5.5]*1e10;
    c_limits = [4.1 5.5]*1e10;
    array_level = 5.4e10;

end

% angle = [-38 30];
angle = [0 90];

place = [1, 2, 3];


%% plotting
% figure

cm = cbrewer('div','RdBu',100,'PCHIP');
[Lx,Lz,nx,nz] = input_parameters();
[X,Z,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);


s1 = subplot(1,3,place(1));
hold on
if( strcmp(type,'source') )
    mesh(X,Z,reshape(x_1.xn - x_4.xn,nx,nz)')
else
    mesh(X,Z,reshape(4.8e10*(1+x_1.xn),nx,nz)')
end
shading interp
plot3(array(:,1),array(:,2),array_level*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim(z_limits)
colormap(cm)
caxis(c_limits)
view(angle)


s2 = subplot(1,3,place(2));
hold on
if( strcmp(type,'source') )
    mesh(X,Z,reshape(x_2.xn - x_5.xn,nx,nz)')
else
    mesh(X,Z,reshape(4.8e10*(1+x_2.xn),nx,nz)')
end
shading interp
plot3(array(:,1),array(:,2),array_level*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim(z_limits)
colormap(cm)
caxis(c_limits)
view(angle)


s3 = subplot(1,3,place(3));
hold on
if( strcmp(type,'source') )
    mesh(X,Z,reshape(x_3.xn - x_6.xn,nx,nz)')
else
    mesh(X,Z,reshape(4.8e10*(1+x_3.xn),nx,nz)')
end
shading interp
plot3(array(:,1),array(:,2),array_level*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim(z_limits)
colormap(cm)
caxis(c_limits)
view(angle)






