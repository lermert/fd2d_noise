function plot_noise_source_kernels(X,Z,K_s,src,rec)

%==========================================================================
%- plot noise source kernels as a function of frequency 
%==========================================================================

%- initialisations --------------------------------------------------------
path(path,'../input/');
cm = cbrewer('div','RdBu',100,'PCHIP');

[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
f_sample = input_interferometry();


%- decide on a frequency --------------------------------------------------
fprintf(1,'f_min=%g Hz, f_max=%g Hz, df=%g Hz\n',min(f_sample),max(f_sample),f_sample(2)-f_sample(1));
% f_min = input('min frequency in Hz: ');
% f_max = input('max frequency in Hz: ');

f_min = 0.08;
f_max = 0.18;

ind_f_min = find( min( abs(f_min-f_sample)) == abs(f_min-f_sample),1,'first' );
ind_f_max = find( min( abs(f_max-f_sample)) == abs(f_max-f_sample),1,'first' );


%- plot source and receiver positions -------------------------------------
figure
hold on
    
for k=1:size(src,1)
    plot(src(k,1),src(k,2),'kx')
end

for k=1:size(rec,1)
    plot(rec(k,1),rec(k,2),'ko')
end


%- plot noise source kernel -----------------------------------------------
K_sum = sum( K_s(:,:,ind_f_min:ind_f_max), 3 );

% pcolor(X,Z,K_sum');
mesh(X,Z,K_sum');
colormap(cm);
set(gca,'FontSize',20);
axis equal


%- axis, scaling, etc. ----------------------------------------------------
shading interp
colorbar

m = max(max(K_sum));
caxis([-m m]);
xlim([0 Lx])
ylim([0 Lz])

xlabel('x [m]','FontSize',20);
ylabel('z [m]','FontSize',20);

