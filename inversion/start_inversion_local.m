
[~,~,nx,nz] = input_parameters();

% initial model
x0 = ones(nx*nz, 1);

% run source inversion
x0 = ones(nx*nz, 1);
x = steepest_descent(x0,'get_obj_grad',0.05,0);

% run structure inversion
% x0 = zeros(nx*nz, 1);
% x = 4.8e10 * ( 1 + LBFGS(x0,'get_obj_grad',0.05,5) );
% x = 4.8e10 * ( 1 + steepest_descent(x0,'get_obj_grad',0.05,0) );

% save solution
save ../output/solution.mat x

figure
hold on
mesh(reshape(x,nx,nz))
contourf(reshape(x,nx,nz))
grid on