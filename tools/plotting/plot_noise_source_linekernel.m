function K_line=plot_noise_source_linekernel(X,K_s)

%function plot_noise_source_linekernel(X,K_s)

%- initialisations --------------------------------------------------------

load cm_velocity;

[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
f_sample = input_interferometry();

%- decide on a frequency --------------------------------------------------

fprintf(1,'f_min=%g Hz, f_max=%g Hz, df=%g Hz\n',min(f_sample),max(f_sample),f_sample(2)-f_sample(1));
f_min=input('min frequency in Hz: ');
f_max=input('max frequency in Hz: ');

ind_f_min=find(min(abs(f_min-f_sample))==abs(f_min-f_sample));
ind_f_max=find(min(abs(f_max-f_sample))==abs(f_max-f_sample));


%- plot noise source kernel -----------------------------------------------

K_sum=sum(K_s(:,:,ind_f_min:ind_f_max),3);
K_line = sum(K_sum,2);

size(K_line)

figure
hold on

plot(X(1,:),K_line,'k')

%- plot source and receiver positions -------------------------------------

for k=1:length(src_x)
    plot(src_x(k),max(K_line)-min(K_line)/2+min(K_line),'rx')
end

for k=1:length(rec_x)
    plot(rec_x(k),max(K_line)-min(K_line)/2+min(K_line),'rv')
end

grid on