function [displacement_seismograms,t,C_2_dxv,C_2_dzv] = run_forward_correlation_fast(G_2, source_dist, mu, rec)

%==========================================================================
% run forward simulation
%
% output:
%--------
% u: displacement seismograms
% t: time axis
%
%==========================================================================


%==========================================================================
% initialise simulation
%==========================================================================

%- material and domain ----------------------------------------------------
[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();

% reshape source distribution and mu - input is a column vector
noise_source_distribution = reshape(source_dist, nx, nz);
mu = reshape(mu, nx, nz);

[~,~,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);
[~,rho] = define_material_parameters(nx,nz,model_type); 


%- compute indices for receiver locations ---------------------------------
n_receivers = size(rec,1);
rec_id = zeros(n_receivers,2);

for i=1:n_receivers    
    rec_id(i,1) = min( find( min(abs(x-rec(i,1))) == abs(x-rec(i,1)) ) );
    rec_id(i,2) = min( find( min(abs(z-rec(i,2))) == abs(z-rec(i,2)) ) );   
end


%==========================================================================
%- forward simulation to compute correlation function ---------------------
%==========================================================================

%- time axis --------------------------------------------------------------
t = -(nt-1)*dt:dt:(nt-1)*dt;
nt = length(t);


%- initialise interferometry ----------------------------------------------
f_sample = input_interferometry();
n_sample = length(f_sample);
w_sample = 2*pi*f_sample;
dw = w_sample(2) - w_sample(1);


% prepare coefficients for Fourier transform and its inverse
fft_coeff = zeros(length(t),length(f_sample)) + 1i*zeros(length(t),length(f_sample));
ifft_coeff = zeros(length(t),length(f_sample)) + 1i*zeros(length(t),length(f_sample));
for k = 1:n_sample
    G_2(:,:,k) = conj(G_2(:,:,k));
    fft_coeff(:,k) = exp( -1i*w_sample(k)*t' )*dt;
    ifft_coeff(:,k) = dw*exp( 1i*w_sample(k)*t' )/(2*pi);
end


%- Fourier transform of the correlation velocity field
% C_2 = zeros(nx,nz,length(f_sample)) + 1i*zeros(nx,nz,length(f_sample));

%- Fourier transform of strain field
C_2_dxv = zeros(nx-1,nz,length(f_sample)) + 1i*zeros(nx-1,nz,length(f_sample));
C_2_dzv = zeros(nx,nz-1,length(f_sample)) + 1i*zeros(nx,nz-1,length(f_sample));


%- initialise noise source locations and spectra
n_noise_sources = 1;
f_peak = 0.125;             % peak frequency in Hz
bandwidth = 0.03;           % bandwidth in Hz


noise_spectrum = zeros(length(f_sample),n_noise_sources);
%- spectrum for source regions --------------------------------------------
for i=1:n_noise_sources
    noise_spectrum(:,i) = 1/(n_noise_sources-i+1) * exp(-(abs(f_sample)-f_peak(i)).^2/bandwidth(i)^2);
end
    

%- dynamic fields and absorbing boundary field ----------------------------
v = zeros(nx,nz);
sxy = zeros(nx-1,nz);
szy = zeros(nx,nz-1);


%- initialise seismograms -------------------------------------------------
displacement_seismograms = zeros(n_receivers,nt);
velocity_seismograms = zeros(n_receivers,nt);


%- initialise absorbing boundary taper a la Cerjan ------------------------
[absbound] = init_absbound();


%==========================================================================
% iterate
%==========================================================================

for n = 1:length(t)
    
    %- compute divergence of current stress tensor ------------------------    
    DS = div_s(sxy,szy,dx,dz,nx,nz,order);
    
    
    %- add sources of the correlation field -------------------------------    
    if( mod(n,5) == 1 && (t(n)<0.0) )
        
        %- transform on the fly to the time domain        
        S = zeros(nx,nz,n_noise_sources) + 1i*zeros(nx,nz,n_noise_sources);
        
        for ns = 1:n_noise_sources
            
            %- inverse Fourier transform for each noise source region           
            for k=1:n_sample
                S(:,:,ns) = S(:,:,ns) + noise_spectrum(k,ns) * G_2(:,:,k) * ifft_coeff(n,k);
            end
            
            %- add sources
            DS = DS + noise_source_distribution(:,:) .* real(S(:,:,ns));
            
        end
           
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
    
    
    %- record velocity seismograms ----------------------------------------    
    for k = 1:n_receivers
        velocity_seismograms(k,n) = v(rec_id(k,1),rec_id(k,2));
    end
    
    
    %- accumulate Fourier transform of the correlation velocity field -----    
    if( mod(n,5) == 1 )
        
        for k=1:n_sample
            % C_2(:,:,k) = C_2(:,:,k) + v(:,:) * fft_coeff(n,k);
            
            C_2_dxv(:,:,k) = C_2_dxv(:,:,k) + strain_dxv(:,:) * fft_coeff(n,k);
            C_2_dzv(:,:,k) = C_2_dzv(:,:,k) + strain_dzv(:,:) * fft_coeff(n,k);
        end

    end
    
end


%==========================================================================
% output 
%==========================================================================

%- displacement seismograms -----------------------------------------------
displacement_seismograms = cumsum(velocity_seismograms,2)*dt;


end

