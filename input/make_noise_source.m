
function [noise_spectrum, noise_source_distribution] = make_noise_source(source_type,make_plots)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % different source types
    % 'equal', 'gaussian', 'ring', 'picture'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %- number and type of noise sources
    n_noise_sources = 1;

    
    %- characteristics of the noise spectrum ------------------------------
    f_peak = [0.125 0.125];              % peak frequency in Hz
    bandwidth = [0.03 0.03];            % bandwidth in Hz

    
    %- location and width of a Gaussian 'blob' ----------------------------
    if(strcmp(source_type,'gaussian'))
        % x_sourcem = 0.8e5;
        % z_sourcem = 2.0e5;
        % sourcearea_width = 0.4e5;
        % strength = 3.0;

        x_sourcem = [0.5e6 1.4e6];
        z_sourcem = [0.8e6 1.6e6];
        sourcearea_width = [2.0e5 2.0e5];
        strength = [100.0 100.0];

    %- ring of sources ----------------------------------------------------
    elseif(strcmp(source_type,'ring'))
        x_source_r = 1.0e6;
        z_source_r = 1.0e6;
        radius = 6.8e5;
        thickness = 1e5;
        angle_cover = 60.0;
        taper_width = 20.0;
        taper_strength = 100;
    
    %- picture translated sources -----------------------------------------
    elseif(strcmp(source_type,'picture'))
        filename = 'source.png';
        
    end

    
    % get configuration
    f_sample = input_interferometry();
    [Lx,Lz,nx,nz,~,~,~,model_type] = input_parameters();
    [X,Z] = define_computational_domain(Lx,Lz,nx,nz);
    [mu,~] = define_material_parameters(nx,nz,model_type);
    [width] = absorb_specs();

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % source spectrum
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    noise_spectrum = zeros(length(f_sample),n_noise_sources);

    cmap = hsv(6);
    for i=1:n_noise_sources
        noise_spectrum(:,i) = 1/(1-i+1)*exp(-(abs(f_sample)-f_peak(i)).^2/bandwidth(i)^2);

%         if ( strcmp(make_plots,'yes') )
%             if(i==1)
%                 figure
%                 set(gca,'FontSize',12)
%                 hold on
%                 cstring = [];
%             end
%             
%             plot(f_sample,noise_spectrum(:,i),'Color',cmap(i,:))
%             cstring{end+1} = ['source ' num2str(i)];
%             xlabel('frequency [Hz]');
%             legend(cstring)
%         end
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % geographic power-spectral density distribution
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % equal noise distribution
    noise_source_distribution = ones(nx,nz,n_noise_sources);

    if(strcmp(source_type,'gaussian'))
        noise_source_distribution(:,:,:) = 1.0;
        for i=1:n_noise_sources
            noise_source_distribution(:,:,i) = noise_source_distribution(:,:,i) + strength(i)*( exp( -( (X-x_sourcem(i)).^2 + (Z-z_sourcem(i)).^2 ) / (sourcearea_width(i))^2 ) )';
        end
        
    elseif(strcmp(source_type,'ring'))
        for i=1:n_noise_sources
            
            R = ( (X-x_source_r(i)).^2 + (Z-z_source_r(i)).^2 ).^(1/2);
            angle = atan( abs( X-x_source_r(i) )./abs(Z-z_source_r(i)) ) *180/pi;
            
            [k,l] = find(isnan(angle));
            angle(k,l) = 0;
            
            if( angle_cover == 90 )
                noise_source_distribution(:,:,i) = (exp( -abs( R-radius ).^2/9e8 ) .* double(R > (radius-thickness/2) & R < (radius+thickness/2) ) );
            else
                noise_source_distribution(:,:,i) = (exp( -abs( R-radius ).^2/9e8 ) .* double(R > (radius-thickness/2) & R < (radius+thickness/2) ) );
                noise_source_distribution(:,:,i) = noise_source_distribution(:,:,i) + exp( -abs( R-radius ).^2/9e8 ) .* ( 5*exp( -(angle-(angle_cover-taper_width)).^2/(taper_strength) .* double( angle>angle_cover-taper_width & angle<angle_cover ) ) .* double( R > (radius-thickness/2) & R < (radius+thickness/2) & angle <= angle_cover ) );
            end
            
        end
        
    elseif(strcmp(source_type,'picture'))
        A = imread(filename);
        noise_source_distribution(:,:,i) = flipud( abs((double(A(:,:))-255)/max(max(abs(double(A)-255)))) )';
    end
    
    
    % plot noise distribution
    for i=1:n_noise_sources
        if ( strcmp(make_plots,'yes') && ~strcmp(source_type,'equal') )
            overlay = 'yes';
            
            figure;
            hold on
            set(gca,'FontSize',12);
            
            X = X/1000;
            Z = Z/1000;
            
            if(strcmp(overlay,'yes'))
                pcolor(X,Z,(noise_source_distribution(:,:,i)-1)'/max(max(max(abs(noise_source_distribution(:,:,i)-1)))));
                model = pcolor(X,Z,(mu-4.8e10)'/max(max(abs(mu-4.8e10))));
                cm = cbrewer('div','RdBu',100,'PCHIP');
                colormap(cm);
                % cb = colorbar;
                % ylabel(cb,'normalized for overlay') 
                caxis([-1.0 1.0])
                alpha(model,0.5)
            else
                pcolor(X,Z,(noise_source_distribution(:,:,i))');
                load cm_psd
                colormap(cm_psd)
                caxis([0.0 max(max(max(noise_source_distribution)))])
                colorbar
            end
            shading interp

            plot([width,Lx-width],[width,width],'k--')
            plot([width,Lx-width],[Lz-width,Lz-width],'k--')
            plot([width,width],[width,Lz-width],'k--')
            plot([Lx-width,Lx-width],[width,Lz-width],'k--')
            
            load('~/Desktop/data/array_16_ref.mat')
            plot(array(:,1),array(:,2),'ko')

            axis equal
            xlim([0 Lx]/1000)
            ylim([0 Lz]/1000)
            xlabel('x [m]');
            ylabel('z [m]');
            title(sprintf('power-spectral density distribution of noise source %i',i));

        end
    end

    
end

