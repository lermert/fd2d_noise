function check_correlation_source_function(x_plot,z_plot)


%- load the velocity spectrum field ---------------------------------------
load('../output/interferometry/G_2.mat');


%- read input and make space-time coordinates -----------------------------
[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
f_sample = input_interferometry();

[X,Z,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);
t=-(nt-1)*dt:dt:(nt-1)*dt;


%- find index -------------------------------------------------------------
x_id = min(find(min(abs(x-x_plot))==abs(x-x_plot)));
z_id = min(find(min(abs(z-z_plot))==abs(z-z_plot)));


%- get the spectrum of the Greens function --------------------------------
s = reshape(G_2(x_id,z_id,:),length(f_sample),1);
s = conj(s);


%- initialise noise spectrum ----------------------------------------------
make_noise_source;


%- approximate inverse Fourier transform ----------------------------------
stf = zeros(1,length(t));
w_sample = 2*pi*f_sample;
dw = w_sample(2) - w_sample(1);

for k=1:length(f_sample)
    stf = stf + noise_spectrum(k) * s(k) * exp(1i*w_sample(k)*t);
end

%stf=stf+s(1)/2.0;
stf = real(dw*stf/pi);


%- plot results -----------------------------------------------------------
%- frequency domain
figure
set(gca,'FontSize',20)

subplot(2,1,1)
plot(f_sample,abs(noise_spectrum.*s),'k');
xlabel('\nu [Hz]')
ylabel('amplitude spectrum')
title(['displacement spectrum at position x=' num2str(x(x_id)) ' m, z=' num2str(z(z_id)) ' m'])

subplot(2,1,2)
plot(f_sample,angle(noise_spectrum.*s),'k');
xlabel('\nu [Hz]','FontSize',20)
ylabel('phase spectrum','FontSize',20)

%- time domain
figure
set(gca,'FontSize',20)
hold on

plot(t,real(stf),'k')
plot(t,imag(stf),'k--')
xlabel('time [s]')
ylabel('amplitude')
title('time-domain source function (solid: real, dashed: imaginary)')
