
path(path,genpath('../'))

% start matlabpool
cluster = parcluster('EulerLSF');
matlabpool(cluster,16)

% initial model
x0 = reshape( zeros(300,300),[],1 );

% run inversion
x = 4.8e10 * ( 1 + LBFGS(x0,'get_obj_grad',0.2,5) );
% x = 4.8e10 * ( 1 + steepest_descent(x0,'get_obj_grad',0.2,0) );

% save solution
save ../output/solution.mat x

% close matlabpool
matlabpool close   
