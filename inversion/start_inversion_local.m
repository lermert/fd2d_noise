
path(path,genpath('../'))
[~,~,nx,nz] = input_parameters();

% initial model
x0 = ones(nx*nz, 1);

% run inversion
% x = LBFGS(x0,'get_obj_grad',0.1,5);
% x = 4.8e10 * ( 1 + LBFGS(x0,'get_obj_grad',0.1,5) );
x = steepest_descent(x0,'get_obj_grad',0.05,0);

% save solution
save ../output/solution.mat x

figure
hold on
mesh(reshape(x,nx,nz))
contourf(reshape(x,nx,nz))
grid on