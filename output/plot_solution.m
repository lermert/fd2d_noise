
figure
clf

angle = [0 90];
cm = cbrewer('div','RdBu',100,'PCHIP');

s1 = subplot(1,3,1);
hold on
mesh(X,Z,mu')
shading interp
plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([4 4.9]*1e10)
colormap(cm)
caxis([4.0 5.6]*1e10)
view(angle)

s2 = subplot(1,3,2);
hold on
mesh(X,Z,reshape(x_01,300,300)')
shading interp
plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([4 4.9]*1e10)
colormap(cm)
caxis([4.0 5.6]*1e10)
view(angle)

cb = colorbar('Location','southoutside');

s3 = subplot(1,3,3);
hold on
mesh(X,Z,reshape(x_02,300,300)')
shading interp
plot3(array(:,1),array(:,2),4.9e10*ones(size(array,1),1),'k*','MarkerSize',2)
grid on
axis square
zlim([4 4.9]*1e10)
colormap(cm)
caxis([4.0 5.6]*1e10)
view(angle)


s1Pos = get(s1,'position');
s2Pos = get(s2,'position');
s3Pos = get(s3,'position');
s2Pos(3:4) = [s1Pos(3:4)];
set(s2,'position',s2Pos);