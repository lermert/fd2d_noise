
figure

mes = 'wd';
folder = '~/Desktop/inversion/source/error_in_structure/';

x_1 = load([folder mes '/model_1']);
% x_1.xn = x_1.x0;
x_2 = load([folder mes '/model_6']);
x_3 = load([folder mes '/model_9']);
load('noise_dist.mat')


% angle = [-38 30];
angle = [0 90];

% z_limits = [4 4.9]*1e10;
% c_limits = [4.0 5.6]*1e10;
z_limits = [-2.0 4.0];
c_limits = [-2.0 4.0];

array_level = 3.8;

cm = cbrewer('div','RdBu',100,'PCHIP');
[~,~,nx,nz] = input_parameters();

s1 = subplot(2,4,1);
hold on
mesh(X,Z,target')
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

s2 = subplot(2,4,2);
hold on
% mesh(X,Z,reshape(4.8e10*(1+x_1.xn),nx,nz)')
mesh(X,Z,reshape(x_1.xn,nx,nz)')
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

s3 = subplot(2,4,3);
hold on
% mesh(X,Z,reshape(4.8e10*(1+x_2.xn),nx,nz)')
mesh(X,Z,reshape(x_2.xn,nx,nz)')
shading interp
plot3(array(:,1),array(:,2),array_level*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim(z_limits)
colormap(cm)
caxis(c_limits)
view(angle)


s4 = subplot(2,4,4);
hold on
% mesh(X,Z,reshape(4.8e10*(1+x_3.xn),nx,nz)')
mesh(X,Z,reshape(x_3.xn,nx,nz)')
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





s6 = subplot(2,4,6);
hold on
mesh(X,Z,reshape(-x_1.gn,nx,nz)')
m_1 = max(max(abs(x_1.gn)));
shading interp
grid on
axis square
zlim([-m_1 m_1])
colormap(cm)
caxis([-m_1 m_1])
view(angle)

s7 = subplot(2,4,7);
hold on
mesh(X,Z,reshape(-x_2.gn,nx,nz)')
m_2 = max(max(abs(x_2.gn)));
shading interp
grid on
axis square
zlim([-m_2 m_2])
colormap(cm)
caxis([-m_2 m_2])
view(angle)

s8 = subplot(2,4,8);
hold on
mesh(X,Z,reshape(-x_3.gn,nx,nz)')
m_2 = max(max(abs(x_3.gn)));
shading interp
grid on
axis square
zlim([-m_2 m_2])
colormap(cm)
caxis([-m_2 m_2])
view(angle)





