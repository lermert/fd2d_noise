
clear all

% type = 'source';
type = 'structure';

measurement_1 = 'wd';
measurement_2 = 'wd';

folder_0 = '~/Desktop/inversion';

% folder_1 = 'true_source';
folder_1 = 'homog_source';
folder_2 = 'source_from_log_a';


n_models = length( dir([folder_0 '/' type '/' folder_1 '/' measurement_1 '/model_*']) );
x_1 = load([folder_0 '/' type '/' folder_1 '/' measurement_1 '/model_' num2str(n_models)]);

n_models = length( dir([folder_0 '/' type '/' folder_2 '/' measurement_2 '/model_*']) );
x_2 = load([folder_0 '/' type '/' folder_2 '/' measurement_2 '/model_' num2str(n_models)]);

load('../output/interferometry/array_16_ref_big_test1.mat')

if( strcmp(type,'source') )
    load('../inversion/true_source.mat')
    array_level = 0.2;
elseif( strcmp(type,'structure') )
    load('../inversion/true_mu.mat')
    array_level = 0.2;
end

angle = [-38 30];
% angle = [0 90];



%% plotting
% figure
cm = cbrewer('div','RdBu',100,'PCHIP');
[Lx,Lz,nx,nz] = input_parameters();
[X,Z,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);


s1 = subplot(1,3,1);
hold on
if( strcmp(type,'source') )
    mesh(X,Z,reshape(source_dist - x_1.xn,nx,nz)')
    m_2 = max((abs(source_dist - x_1.xn)));
else
    mesh(X,Z,reshape(mu - 4.8e10*(1+x_1.xn),nx,nz)')
    m_1 = max((abs(mu - 4.8e10*(1+x_1.xn))));
end
shading interp
plot3(array(:,1),array(:,2),array_level*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([-m_1 m_1])
colormap(cm)
caxis([-m_1 m_1])
view(angle)
title(['true - ' folder_1 '_' measurement_1],'Interpreter','None')


s2 = subplot(1,3,2);
hold on
if( strcmp(type,'source') )
    mesh(X,Z,reshape(source_dist - x_2.xn,nx,nz)')
    m_2 = max((abs(source_dist - x_2.xn)));
else
    mesh(X,Z,reshape(mu - 4.8e10*(1+x_2.xn),nx,nz)')
    m_2 = max((abs(mu - 4.8e10*(1+x_2.xn))));
end
shading interp
plot3(array(:,1),array(:,2),array_level*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([-m_2 m_2])
colormap(cm)
caxis([-m_2 m_2])
view(angle)
title(['true - ' folder_2 '_' measurement_2],'Interpreter','None')


s3 = subplot(1,3,3);
hold on
if( strcmp(type,'source') )
    mesh(X,Z,reshape(x_1.xn-x_2.xn,nx,nz)')
    m_3 = max((abs(x_1.xn - x_2.xn)));
else
    mesh(X,Z,reshape(4.8e10*(x_1.xn-x_2.xn),nx,nz)')
    m_3 = max((abs(4.8e10*(x_1.xn-x_2.xn))));
end
shading interp
plot3(array(:,1),array(:,2),array_level*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([-m_3 m_3])
colormap(cm)
caxis([-m_3 m_3])
view(angle)
title([folder_1 '_' measurement_1 ' - ' folder_2 '_' measurement_2],'Interpreter','None')





