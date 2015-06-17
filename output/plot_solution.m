
figure

x_001 = load('solution_cc_16_ref_structure_slow_001');
x_01 = load('solution_cc_16_ref_structure_slow_01');
x_02 = load('solution_cc_16_ref_structure_slow_02');
load('structure_slow.mat')


angle = [-38 30];
angle = [0 90];
cm = cbrewer('div','RdBu',100,'PCHIP');

s1 = subplot(1,2,1);
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
cb = colorbar('Location','southoutside');

s2 = subplot(1,2,2);
hold on
mesh(X,Z,reshape(x_001.x,300,300)')
shading interp
plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([4 4.9]*1e10)
colormap(cm)
caxis([4.0 5.6]*1e10)
title('inverted mu model')
view(angle)
cb = colorbar('Location','southoutside');

% s3 = subplot(1,4,3);
% hold on
% mesh(X,Z,reshape(x_01.x,300,300)')
% shading interp
% plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
% grid on
% axis square
% zlim([4 4.9]*1e10)
% colormap(cm)
% caxis([4.0 5.6]*1e10)
% view(angle)
% 
% 
% s4 = subplot(1,4,4);
% hold on
% mesh(X,Z,reshape(x_02.x,300,300)')
% shading interp
% plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
% grid on
% axis square
% zlim([4 4.9]*1e10)
% colormap(cm)
% caxis([4.0 5.6]*1e10)
% view(angle)

% s1Pos = get(s1,'position');
% s2Pos = get(s2,'position');
% s3Pos = get(s3,'position');
% s2Pos(3:4) = [s1Pos(3:4)];
% set(s2,'position',s2Pos);