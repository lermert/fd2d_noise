

% type = 'source';
type = 'structure';

measurement = 'cc';
% measurement = 'wd';

folder_0 = '~/Desktop/inversion';
% folder_1 = 'true_structure';
% folder_1 = 'error_in_structure';
folder_1 = 'source_from_log_a_inversion';

x_1 = load([folder_0 '/' type '/' folder_1 '/' measurement '/model_1']);
% x_1.xn = x_1.x0;
x_2 = load([folder_0 '/' type '/' folder_1 '/' measurement '/model_3']);
x_3 = load([folder_0 '/' type '/' folder_1 '/' measurement '/model_6']);

load('../output/interferometry/array_16_ref_big_test1.mat')

if( strcmp(type,'source') )
    load('../inversion/true_source.mat')
    true = source_dist;
    
    z_limits = [-2.0 4.0];
    c_limits = [-2.0 4.0];
    array_level = 3.8;
    
elseif( strcmp(type,'structure') )
    load('../inversion/true_mu.mat')
    true = mu;
    
    z_limits = [4.1 5.5]*1e10;
    c_limits = [4.1 5.5]*1e10;
    array_level = 5.4e10;

end

% angle = [-38 30];
angle = [0 90];

place = [2, 3, 4];
% place = [6, 7, 8];

%% plotting
% figure

cm = cbrewer('div','RdBu',100,'PCHIP');
[Lx,Lz,nx,nz] = input_parameters();
[X,Z,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);

s1 = subplot(2,4,1);
hold on
mesh(X,Z,reshape(true,nx,nz)')
shading interp
plot3(array(:,1),array(:,2),array_level*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim(z_limits)
colormap(cm)
caxis(c_limits)
title('true mu model')
view(angle)
% cb = colorbar('Location','southoutside');

s2 = subplot(2,4,place(1));
hold on
if( strcmp(type,'source') )
    mesh(X,Z,reshape(x_1.xn,nx,nz)')
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
% title('inverted mu model')
view(angle)
% cb = colorbar('Location','southoutside');

s3 = subplot(2,4,place(2));
hold on
if( strcmp(type,'source') )
    mesh(X,Z,reshape(x_2.xn,nx,nz)')
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


s4 = subplot(2,4,place(3));
hold on
if( strcmp(type,'source') )
    mesh(X,Z,reshape(x_3.xn,nx,nz)')
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

% s1Pos = get(s1,'position');
% s2Pos = get(s2,'position');
% s3Pos = get(s3,'position');
% s2Pos(3:4) = [s1Pos(3:4)];
% set(s2,'position',s2Pos);




%% plot gradients
% s6 = subplot(2,4,6);
% hold on
% mesh(X,Z,reshape(-x_1.gn,nx,nz)')
% m_1 = max(max(abs(x_1.gn)));
% shading interp
% grid on
% axis square
% zlim([-m_1 m_1])
% colormap(cm)
% caxis([-m_1 m_1])
% view(angle)
% colorbar('Location','SouthOutside')
% 
% s7 = subplot(2,4,7);
% hold on
% mesh(X,Z,reshape(-x_2.gn,nx,nz)')
% m_2 = max(max(abs(x_2.gn)));
% shading interp
% grid on
% axis square
% zlim([-m_2 m_2])
% colormap(cm)
% caxis([-m_2 m_2])
% view(angle)
% colorbar('Location','SouthOutside')
% 
% s8 = subplot(2,4,8);
% hold on
% mesh(X,Z,reshape(-x_3.gn,nx,nz)')
% m_2 = max(max(abs(x_3.gn)));
% shading interp
% grid on
% axis square
% zlim([-m_2 m_2])
% colormap(cm)
% caxis([-m_2 m_2])
% view(angle)
% colorbar('Location','SouthOutside')





