 
%==========================================================================
% location for adjoint sources, only for slow mode
%==========================================================================

adjoint_source_path='../input/sources/adjoint/';


%==========================================================================
% print output concerning specification and timing
%==========================================================================

verbose = 'no';


%==========================================================================
% make plots every nth timestep
%==========================================================================

make_plots = 'yes';
plot_nt = 100;


%==========================================================================
% make wavepropagation movie
%==========================================================================

make_movie='no';                                          
movie_file='../output/C_2.mp4';                            % should be .mp4


%==========================================================================
% summarize configuration
%==========================================================================

% if( strcmp(verbose,'yes') )
%     
%     v = 4000;
%     fprintf('\ndx = %f\n',Lx/(nx-1));
%     fprintf('dz = %f\n',Lz/(nz-1));
%     fprintf('dt = c * min(dx,dz)/%5.1f = c * %f\n',v,min(Lx/(nx-1),Lz/(nz-1))/v);
%     fprintf('chosen c = %f\n\n',dt/(min(Lx/(nx-1),Lz/(nz-1))/v));
%     fprintf('freq_max = %f\n',v/(15*max(Lx/(nx-1),Lz/(nz-1))));
%     fprintf('lamda_min = %f\n\n',15*max(Lx/(nx-1),Lz/(nz-1)));
%     
%     % fprintf('freq_min = %f\n', v/(sqrt((rec_x-src_x).^2 + (rec_z-src_z).^2)/3) );
%     % fprintf('lamda_max = %f\n', sqrt((rec_x-src_x).^2 + (rec_z-src_z).^2)/3 );
%     clear v;
%     
% end


