function [X,Z,K_rho,K_mu]=run_noise_structure_kernel(simulation_mode,i_ref,flip_sr)

%==========================================================================
% run simulation to compute sensitivity kernel for rho (only one-sided)
%
% output:
%--------
% X, Z: coordinate axes
% K_rho: sensitivity kernel
%
%==========================================================================

%==========================================================================
% set paths and read input
%==========================================================================

path(path,genpath('../'));
cm = cbrewer('div','RdBu',100,'PCHIP');


%==========================================================================
% initialise simulation
%==========================================================================

%- material and domain ----------------------------------------------------
[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
[mu,rho] = define_material_parameters(nx,nz,model_type);
[X,Z,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);

output_specs


%- time axis -------------------------------------------------------------- 
t = -(nt-1)*dt:dt:(nt-1)*dt;
nt = length(t);

    
%- read adjoint source locations ------------------------------------------
if( strcmp(flip_sr,'no') )
    fid = fopen([adjoint_source_path 'source_locations_' num2str(i_ref)],'r');
else
    fid = fopen([adjoint_source_path 'source_locations_flip_sr_' num2str(i_ref)],'r');
end

adsrc = zeros(1,1);
k=1;
while (feof(fid)==0)
    adsrc(k,1) = fscanf(fid,'%g',1);
    adsrc(k,2) = fscanf(fid,'%g',1);
    fgetl(fid);
    k = k+1;
end

fclose(fid);


%- read adjoint source time functions and reverse time axis ---------------
ns = size(adsrc,1);
stf = zeros(ns,nt);

for n=1:ns
    if( strcmp(flip_sr,'no') )
        fid = fopen([adjoint_source_path '/src_' num2str(i_ref) '_' num2str(n)],'r');
    else
        fid = fopen([adjoint_source_path '/src_' num2str(i_ref) '_' num2str(n) '_flip_sr'],'r');
    end
    
    stf(n,nt:-1:1) = fscanf(fid,'%g',nt);
    fclose(fid);
end


%- compute indices for adjoint source locations ---------------------------    
adsrc_id = zeros(ns,2);
for i=1:ns
    adsrc_id(i,1) = min( find( min(abs(x-adsrc(i,1))) == abs(x-adsrc(i,1))) );
    adsrc_id(i,2) = min( find( min(abs(z-adsrc(i,2))) == abs(z-adsrc(i,2))) );
end


%- initialise interferometry ----------------------------------------------        
f_sample = input_interferometry();
w_sample = 2*pi*f_sample;
dw = w_sample(2) - w_sample(1);

G_1 = zeros(nx,nz,length(f_sample)) + + 1i*zeros(nx,nz,length(f_sample));
G_1_strain_dxv = zeros(nx-1,nz,length(f_sample)) + 1i*zeros(nx-1,nz,length(f_sample));
G_1_strain_dzv = zeros(nx,nz-1,length(f_sample)) + 1i*zeros(nx,nz-1,length(f_sample));
            

%- dynamic fields and absorbing boundary field ----------------------------
v = zeros(nx,nz);
sxy = zeros(nx-1,nz);
szy = zeros(nx,nz-1);


%- initialise absorbing boundary taper a la Cerjan ------------------------
[absbound] = init_absbound();


%==========================================================================
% iterate
%==========================================================================

if( strcmp(make_plots,'yes') )
    figure;
    set(gca,'FontSize',20);
end


for n=1:length(t)
    
    %- compute divergence of current stress tensor ------------------------    
    DS = div_s(sxy,szy,dx,dz,nx,nz,order);
    
    
    %- add point sources --------------------------------------------------    
    for i=1:ns
        DS( adsrc_id(i,1),adsrc_id(i,2) ) = DS( adsrc_id(i,1),adsrc_id(i,2) ) + stf(i,n);
    end
    
    
    %- update velocity field ----------------------------------------------    
    v = v + dt*DS./rho;
    
    
    %- apply absorbing boundary taper -------------------------------------    
    v = v .* absbound;
    
    
    %- compute derivatives of current velocity and update stress tensor ---
    strain_dxv = dx_v(v,dx,dz,nx,nz,order);
    strain_dzv = dz_v(v,dx,dz,nx,nz,order);
    
    sxy = sxy + dt*mu(1:nx-1,:) .* strain_dxv;
    szy = szy + dt*mu(:,1:nz-1) .* strain_dzv;
     
    
    %- accumulate Fourier transform of the velocity field -----------------
    if( mod(n,5) == 1 )
        for k=1:length(w_sample)
            G_1(:,:,k) = G_1(:,:,k) + v(:,:) * exp(-1i*w_sample(k)*t(n)) * dt;            
            G_1_strain_dxv(:,:,k) = G_1_strain_dxv(:,:,k) + strain_dxv(:,:) * exp(-1i*w_sample(k)*t(n)) * dt;
            G_1_strain_dzv(:,:,k) = G_1_strain_dzv(:,:,k) + strain_dzv(:,:) * exp(-1i*w_sample(k)*t(n)) * dt;
        end
    end
    
    
    %- plot velocity field ------------------------------------------------
    if (strcmp(make_plots,'yes'))
        plot_velocity_field;
    end

end


%==========================================================================
% compute structure kernels 
%==========================================================================

%- load Fourier transformed correlation velocity field
if( strcmp(flip_sr,'no') )
    load(['../output/interferometry/C_2_' num2str(i_ref) '.mat']);    
    load(['../output/interferometry/C_2_strain_dxv_' num2str(i_ref) '.mat']);
    load(['../output/interferometry/C_2_strain_dzv_' num2str(i_ref) '.mat']);
else
    load(['../output/interferometry/C_2_flip_sr' num2str(i_ref) '.mat']);    
    load(['../output/interferometry/C_2_strain_dxv_flip_sr'  num2str(i_ref) '.mat']);
    load(['../output/interferometry/C_2_strain_dzv_flip_sr'  num2str(i_ref) '.mat']);
end


%- accumulate kernel by looping over frequency
K_rho = zeros(nx,nz);
K_mu = zeros(nx,nz);
for k=1:length(w_sample)
    K_rho = K_rho - G_1(:,:,k) .* C_2(:,:,k) * dw;
    
    % both is still in velocity
    K_mu(1:nx-1,:) = K_mu(1:nx-1,:) - G_1_strain_dxv(:,:,k) .* C_2_strain_dxv(:,:,k) / w_sample(k)^2 * dw;
    K_mu(:,1:nz-1) = K_mu(:,1:nz-1) - G_1_strain_dzv(:,:,k) .* C_2_strain_dzv(:,:,k) / w_sample(k)^2 * dw;
end

K_rho = real(K_rho);
K_mu = real(K_mu);


%==========================================================================
% output 
%==========================================================================

%- store the movie if wanted ----------------------------------------------
if strcmp(make_movie,'yes')
    writerObj=VideoWriter(movie_file,'MPEG-4');
    open(writerObj);
    writeVideo(writerObj,M);
    close(writerObj);
end

