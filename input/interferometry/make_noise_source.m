
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generalities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

standalone = 'no';             % 'yes' for usage without other computations

%- number of noise sources
n_noise_sources = 1;
sources_everywhere = false;

%- characteristics of the noise spectrum ----------------------------------
%- only needed in this routine --------------------------------------------
f_peak = 0.125;              % peak frequency in Hz
bandwidth = 0.03;            % bandwidth in Hz

%- Geographic distribution of sources -------------------------------------
%- Location and width of a Gaussian 'blob' --------------------------------
x_sourcem = 1.0e5;
z_sourcem = 2.3e5;
sourcearea_width = 0.4e5;

x_source_r = 2.0e5;
z_source_r = 2.0e5;
radius = 1.4e5;
thickness = 40000;
angle_cover = 40.0;
taper_width = 20;
taper_strength = 100;



%- Or how to set sources everywhere? --------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get model setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if( strcmp(standalone,'yes') )

    % path(path,genpath('../../'));
    addpath(genpath('../../'))
    output_specs
    
    f_sample = input_interferometry();
    [Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
    [X,Z,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);
    [width,absorb_left,absorb_right,absorb_top,absorb_bottom] = absorb_specs();

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% source spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noise_spectrum=zeros(length(f_sample),n_noise_sources);

%- spectrum for source regions --------------------------------------------
for i=1:n_noise_sources
    noise_spectrum(:,i)=1/(n_noise_sources-i+1)*exp(-(abs(f_sample)-f_peak(i)).^2/bandwidth(i)^2);
    
    if ( strcmp(standalone,'yes') )
        if(i==1)
            figure
            % set(gca,'FontSize',20)
            hold on
        end
        
        plot(f_sample,noise_spectrum(:,i),'k');
        xlabel('frequency [Hz]');
        % title(sprintf('noise power-spectral density for noise source %i',i))
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geographic power-spectral density distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noise_source_distribution=zeros(nx,nz,n_noise_sources);

noise_source_distribution(:,:,:) = 1.0;

%- if distribution homogeneous
if sources_everywhere == true

    noise_source_distribution(:,:,:) = 1.0;
    
else

    %- noise source geography ---------------------------------------------
%     A = imread('source.png');
%     noise_source_distribution(:,:,i) = flipud( abs((double(A(:,:))-255)/max(max(abs(double(A)-255)))) )'; 
 
  
%     for i=1:n_noise_sources        
%         
%         R = ( (X-x_source_r(i)).^2 + (Z-z_source_r(i)).^2 ).^(1/2);        
%         angle = atan( abs( X-x_source_r(i) )./abs(Z-z_source_r(i)) ) *180/pi;
%         [k,l]=find(isnan(angle));
%         angle(k,l) = 10;
%         
% %         pcolor(X,Z,R')
% %         shading interp
% %         colorbar
%         
%         if( angle_cover == 90 )
%             noise_source_distribution(:,:,i) = double(R > (radius-+thickness/2) & R < (radius+thickness/2) & angle <= angle_cover);
%         else
%             noise_source_distribution(:,:,i) = exp( -(angle-(angle_cover-taper_width)).^2/(taper_strength) .* double( angle>angle_cover-taper_width & angle<angle_cover ) ) .* double( R > (radius-+thickness/2) & R < (radius+thickness/2) & angle <= angle_cover ) ;
%         end
%         
%     end
    
 
    for i=1:n_noise_sources        
        noise_source_distribution(:,:,i) = noise_source_distribution(:,:,i) + 3.0*( exp( -( (X-x_sourcem(i)).^2 + (Z-z_sourcem(i)).^2 ) / (sourcearea_width(i))^2 ) )';        
    end
    
end



for i=1:n_noise_sources
    if ( strcmp(standalone,'yes') && ~sources_everywhere )
        figure;
        hold on
        % set(gca,'FontSize',20);
        load cm_psd
        pcolor(X,Z,noise_source_distribution(:,:,i)');
        
        plot([width,Lx-width],[width,width],'k--')
        plot([width,Lx-width],[Lz-width,Lz-width],'k--')
        plot([width,width],[width,Lz-width],'k--')
        plot([Lx-width,Lx-width],[width,Lz-width],'k--')
        
        axis equal
        xlim([0 Lx])
        ylim([0 Lz])
        shading interp
        colormap(cm_psd)
        colorbar
        xlabel('x [m]');
        ylabel('z [m]');
        title(sprintf('power-spectral density distribution of noise source %i',i));
        
    end
end

if ( strcmp(standalone,'yes') )
    rmpath(genpath('../../'))
end

