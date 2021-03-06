
close all

[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();


% figure

% %% MU KERNELS
c = 0.1;
% m = max(max(abs(K_mu_1'+K_mu_2')));
myfilter = fspecial('gaussian',[15 15], 5);
% 
% subplot(3,2,1)
% pcolor(K_mu_1')
% shading interp
% cm = cbrewer('div','RdBu',100,'PCHIP');
% colormap(cm)
% colorbar
% caxis([-c*m c*m])
% axis equal
% title('mu_1')
% xlim([0 nx])
% ylim([0 nz])
% 
% 
% subplot(3,2,3)
% pcolor(K_mu_2')
% shading interp
% cm = cbrewer('div','RdBu',100,'PCHIP');
% colormap(cm)
% colorbar
% caxis([-c*m c*m])
% axis equal
% title('mu_2')
% xlim([0 nx])
% ylim([0 nz])
% 
% 
% subplot(3,2,5)
% % subplot(1,2,1)
% % subplot(2,2,1)
% pcolor(K_mu_1'+K_mu_2')
% shading interp
% cm = cbrewer('div','RdBu',100,'PCHIP');
% colormap(cm)
% colorbar
% caxis([-c*m c*m])
% axis equal
% title('mu_1 + mu_2')
% xlim([0 nx])
% ylim([0 nz])
% 
% 
% % subplot(2,2,3)
% % % subplot(1,2,1)
% % pcolor(imfilter(K_mu_1'+K_mu_2', myfilter, 'symmetric'))
% % shading interp
% % cm = cbrewer('div','RdBu',100,'PCHIP');
% % colormap(cm)
% % colorbar
% % caxis([-c*m c*m])
% % axis equal
% % title('mu_1 + mu_2 (smoothed)')
% % xlim([0 nx])
% % ylim([0 nz])
% 
% 
% 
% %% RHO KERNELS
% c = 0.3;
% m = max(max(abs(K_rho_1'+K_rho_2')));
% % myfilter = fspecial('gaussian',[40 40], 20);
% 
% 
% subplot(3,2,2)
% pcolor(K_rho_1')
% shading interp
% cm = cbrewer('div','RdBu',100,'PCHIP');
% colormap(cm)
% colorbar
% caxis([-c*m c*m])
% axis equal
% title('rho_1')
% xlim([0 nx])
% ylim([0 nz])
% 
% 
% subplot(3,2,4)
% pcolor(K_rho_2')
% shading interp
% cm = cbrewer('div','RdBu',100,'PCHIP');
% colormap(cm)
% colorbar
% caxis([-c*m c*m])
% axis equal
% title('rho_2')
% xlim([0 nx])
% ylim([0 nz])
% 
% 
% subplot(3,2,6)
% % subplot(1,2,2)
% % subplot(2,2,2)
% pcolor(K_rho_1'+K_rho_2')
% shading interp
% cm = cbrewer('div','RdBu',100,'PCHIP');
% colormap(cm)
% colorbar
% caxis([-c*m c*m])
% axis equal
% title('rho_1 + rho_2')
% xlim([0 nx])
% ylim([0 nz])
% 
% 
% % subplot(2,2,4)
% % pcolor(imfilter(K_rho_1'+K_rho_2', myfilter, 'symmetric'))
% % shading interp
% % cm = cbrewer('div','RdBu',100,'PCHIP');
% % colormap(cm)
% % colorbar
% % caxis([-c*m c*m])
% % axis equal
% % title('rho_1 + rho_2 (smoothed)')
% % xlim([0 nx])
% % ylim([0 nz])


%% plot velocity kernel
figure
K_v = 2*rho.*sqrt(mu./rho).*K_mu_uniform;
mesh(X,Z,imfilter(K_v', myfilter, 'symmetric'))
shading interp
colormap(cm)
m = max(max(abs(K_v)));
caxis([-c*m c*m])

figure
mesh(X,Z,K_v')
shading interp
colormap(cm)
m = max(max(abs(K_v)));
caxis([-c*m c*m])

