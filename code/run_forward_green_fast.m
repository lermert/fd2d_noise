function [G_2] = run_forward_green_fast(mu,src)

%==========================================================================
% run forward simulation
%
% input:
%--------
% mu [N/m^2]
% src: source, i.e. reference station
%
% output:
%--------
% G_2: Green function of reference station
%
%==========================================================================


%==========================================================================
% initialise simulation
%==========================================================================

%- material and domain ----------------------------------------------------
[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
[~,~,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);
[~,rho] = define_material_parameters(nx,nz,model_type);
mu = reshape(mu,nx,nz);


%- initialise interferometry ----------------------------------------------
f_sample = input_interferometry();
n_sample = length(f_sample);
w_sample = 2*pi*f_sample;
dw = w_sample(2) - w_sample(1);


%- time axis --------------------------------------------------------------
t = 0:dt:dt*(nt-1);


%- compute indices for source locations -----------------------------------
ns = size(src,1);
src_id = zeros(ns,2);
for i = 1:ns
    src_id(i,1) = min( find( min(abs(x-src(i,1))) == abs(x-src(i,1)) ) );
    src_id(i,2) = min( find( min(abs(z-src(i,2))) == abs(z-src(i,2)) ) );
end


%- make source time function ----------------------------------------------
stf = 1.0e9*ones(1,length(t));


%- Fourier transform of the forward Greens function
G_2 = zeros(nx,nz,length(f_sample)) + 1i*zeros(nx,nz,length(f_sample));


% prepare coefficients for Fourier transform
fft_coeff = zeros(length(t),length(w_sample)) + 1i*zeros(length(t),length(f_sample));
for k = 1:n_sample
    fft_coeff(:,k) = exp(-1i*w_sample(k)*t')*dt;
end


%- dynamic fields and absorbing boundary field ----------------------------
v = zeros(nx,nz);
sxy = zeros(nx-1,nz);
szy = zeros(nx,nz-1);


%- initialise absorbing boundary taper a la Cerjan ------------------------
[absbound] = init_absbound();


%==========================================================================
% iterate
%==========================================================================

for n = 1:length(t)
    
    %- compute divergence of current stress tensor ------------------------    
    DS = div_s(sxy,szy,dx,dz,nx,nz,order);
    
    
    %- add point sources --------------------------------------------------    
    for i=1:ns
        DS(src_id(i,1),src_id(i,2)) = DS(src_id(i,1),src_id(i,2)) + stf(n);
    end
        
    
    %- update velocity field ----------------------------------------------
    v = v + dt*DS./rho;
    
    
    %- apply absorbing boundary taper -------------------------------------    
    v = v.*absbound;
    
    
    %- compute derivatives of current velocity and update stress tensor ---
    strain_dxv = dx_v(v,dx,dz,nx,nz,order);
    strain_dzv = dz_v(v,dx,dz,nx,nz,order);
    
    sxy = sxy + dt*mu(1:nx-1,:) .* strain_dxv;
    szy = szy + dt*mu(:,1:nz-1) .* strain_dzv;
    
    
    %- accumulate Fourier transform of the displacement Greens function ---
    if( mod(n,5) == 1)         
        
        for k=1:n_sample
            G_2(:,:,k) = G_2(:,:,k) + v(:,:) * fft_coeff(n,k);
        end
        
    end
    
end


end

