
path(path,genpath('../'))

% start matlabpool
cluster = parcluster('EulerLSF');
matlabpool(cluster,16)

% initial model
x0 = reshape( ones(300,300),[],1 );

% run inversion
x = LBFGS(x0,'get_obj_grad',0.1,5);

% save solution
save ../output/solution.mat x

% close matlabpool
matlabpool close   