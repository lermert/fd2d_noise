
close all

path(path,genpath('../'))

type = 'source';
flip_sr = 'no';

[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();
[width,absorb_left,absorb_right,absorb_top,absorb_bottom] = absorb_specs();
output_specs


% define receiver array
nr_x = 4;
nr_z = 4;
array = zeros(nr_x*nr_z,2);
for i = 1:nr_x
    for j = 1:nr_z
        array( (i-1)*nr_x + j, 1 ) = 4*width + ( i-1 )*(Lx-8*width)/(nr_x-1);
        array( (i-1)*nr_z + j, 2 ) = 4*width + ( j-1 )*(Lz-8*width)/(nr_z-1);
    end
end

% nr_x = 2;
% nr_z = 1;
% array = zeros(nr_x*nr_z,2);
% for i = 1:nr_x
%         array( i, 1 ) = Lx/2 + (-1)^i * 0.15*Lx;
%         array( i, 2 ) = Lz/2;
% end



% select receivers that will be reference stations
% ref_stat = array(1,:);
ref_stat = array;


% plot configuration
if( strcmp(make_plots,'yes') )
    figure
    hold on
    plot(array(:,1),array(:,2),'o')
    plot(ref_stat(:,1),ref_stat(:,2),'x')
    xlim([0 Lx])
    ylim([0 Lz])
end


% calculate correlations
nr = size(array,1)-1;
fprintf('\n')
for i = 1:size(ref_stat,1)
    
%     if( strcmp(verbose,'yes') )
        fprintf('reference station: %i\n',i)
%     end
    
    % each reference station will act as a source once
    src = ref_stat(i,:);
    rec = array( find(~ismember(array,src,'rows') ) , :);
    
    % calculate the correlation for each pair
    [~,~] = run_forward('forward_green',src,rec,i,flip_sr);
    [c_data( (i-1)*nr + 1 : i*nr , :),t] = run_forward('correlation',src,rec,i,flip_sr);
    
end


% plot data
figure
plot_recordings_all(c_data,t,'vel','k-',0);
legend('data')


% save array and data for inversion
save(sprintf('../output/interferometry/array_%i_ref.mat',size(ref_stat,1)),'array','ref_stat')
save(sprintf('../output/interferometry/data_%i_ref.mat',size(ref_stat,1)),'c_data','t')

