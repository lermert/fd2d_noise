
if (mod(n,plot_nt)==0)
    
    hold on
    
    %- plot velocity field ------------------------------------------------ 
    pcolor(X,Z,v');
    
    [width,absorb_left,absorb_right,absorb_top,absorb_bottom] = absorb_specs();
    plot([width,Lx-width],[width,width],'k--')
    plot([width,Lx-width],[Lz-width,Lz-width],'k--')
    plot([width,width],[width,Lz-width],'k--')
    plot([Lx-width,Lx-width],[width,Lz-width],'k--')
    
    set(gca,'FontSize',20);
    axis image
    
    
    %- scale, label, etc ... ----------------------------------------------   
    if (n<0.8*length(t))
        scale=max(max(abs(v)));
    end
   
    caxis([-scale scale]);
    colorbar
    colormap(cm);
    shading interp
    xlabel('x [m]');
    ylabel('z [m]');
    
    if (strcmp(simulation_mode,'forward') || strcmp(simulation_mode,'forward_green'))
        title('velocity field [m/s]');
    elseif (strcmp(simulation_mode,'correlation') && t(n)<0)
        title('acausal correlation field');
    elseif (strcmp(simulation_mode,'correlation') && t(n)>=0)
        title('causal correlation field');
    end
    
    
    %- plot source and receiver positions ---------------------------------
    if ( ~strcmp(simulation_mode,'noise_source_kernel') && ~strcmp(simulation_mode,'noise_source_kernel') )
        for k=1:size(src,1)
            plot(src(k,1),src(k,2),'kx')
        end
        
        for k=1:size(rec,1)
            plot(rec(k,1),rec(k,2),'ko')
        end
    end
       
    
    %- record movie -------------------------------------------------------
    if strcmp(make_movie,'yes')
    
        if exist('movie_index','var')
            movie_index=movie_index+1;
        else
            movie_index=1;
        end
        
        M(movie_index)=getframe(gcf);
        
    end
    
    
    %- finish -------------------------------------------------------------
    drawnow
    hold off
    clf
            
end
