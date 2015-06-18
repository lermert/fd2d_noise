
figure

x_1 = load('~/Desktop/model_1');
x_2 = load('~/Desktop/model_2');
load('structure_slow.mat')


angle = [-38 30];
% angle = [0 90];
cm = cbrewer('div','RdBu',100,'PCHIP');


s1 = subplot(2,4,1);
hold on
mesh(X,Z,mu')
shading interp
plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([4 4.9]*1e10)
colormap(cm)
caxis([4.0 5.6]*1e10)
title('true mu model')
view(angle)
% cb = colorbar('Location','southoutside');

s2 = subplot(2,4,2);
hold on
mesh(X,Z,reshape(4.8e10*(1+x_1.xn),300,300)')
shading interp
plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([4 4.9]*1e10)
colormap(cm)
caxis([4.0 5.6]*1e10)
% title('inverted mu model')
view(angle)
% cb = colorbar('Location','southoutside');

s3 = subplot(2,4,3);
hold on
mesh(X,Z,reshape(4.8e10*(1+x_2.xn),300,300)')
shading interp
plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([4 4.9]*1e10)
colormap(cm)
caxis([4.0 5.6]*1e10)
view(angle)


s4 = subplot(2,4,4);
hold on
mesh(X,Z,4.8e10*(1+reshape(x_2.xn-32*x_2.gn,300,300)))
shading interp
plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([4 4.9]*1e10)
colormap(cm)
caxis([4.0 5.6]*1e10)
view(angle)

% s1Pos = get(s1,'position');
% s2Pos = get(s2,'position');
% s3Pos = get(s3,'position');
% s2Pos(3:4) = [s1Pos(3:4)];
% set(s2,'position',s2Pos);





s6 = subplot(2,4,6);
hold on
mesh(X,Z,reshape(-x_1.gn,300,300)')
m_1 = max(max(abs(x_1.gn)));
shading interp
grid on
axis square
zlim([-m_1 m_1])
colormap(cm)
caxis([-m_1 m_1])
% title('inverted mu model')
view(angle)

s7 = subplot(2,4,7);
hold on
mesh(X,Z,reshape(-x_2.gn,300,300)')
m_2 = max(max(abs(x_2.gn)));
shading interp
grid on
axis square
zlim([-m_2 m_2])
colormap(cm)
caxis([-m_2 m_2])
view(angle)





