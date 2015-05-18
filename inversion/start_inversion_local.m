
path(path,genpath('../'))

% initial model
x0 = reshape( ones(300,300),[],1 );

% run inversion
x = LBFGS(x0,'get_obj_grad',0.1,5);

% save solution
save ../output/solution.mat x

figure
hold on
mesh(reshape(x,300,300))
contourf(reshape(x,300,300))
grid on