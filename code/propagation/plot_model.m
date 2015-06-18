
load 'propagation/cm_model.mat';

figure
set(gca,'FontSize',14)

subplot(2,2,1)
pcolor(X,Z,mu');
colormap(cm_model);
axis image
shading flat
title('mu [N/m^2]','FontSize',14)
xlabel('x [m]','FontSize',14);
ylabel('z [m]','FontSize',14);
colorbar
    
subplot(2,2,2)
pcolor(X,Z,rho');
colormap(cm_model);
axis image
shading flat
title('rho [kg/m^3]','FontSize',14)
xlabel('x [m]','FontSize',14);
ylabel('z [m]','FontSize',14);
colorbar

subplot(2,2,3:4)
pcolor(X,Z,sqrt( (mu./rho)' ));
colormap(cm_model);
axis image
shading flat
title('velocity [km/s]','FontSize',14)
xlabel('x [m]','FontSize',14);
ylabel('z [m]','FontSize',14);
colorbar