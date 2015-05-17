
fun = 'Frosenbrock';
x0=[0.9;0.1];

% steepest descent with Armijo-Goldstein stepsize
% xopt = steepest_descent(x0,fun,1e-4,0);

% steepest descent with Powell-Wolfe stepsize 
% xopt = steepest_descent(x0,fun,1e-4,1);

% Limited-memory BFGS 
xopt = LBFGS(x0,fun,1e-4,2);

% Newton-Linesearch with exact Hessian
% xopt = newton(x0,fun,1e-4);

% Trust-region Newton with exact solution of the subproblem
% xopt = trust_region(x0,fun,1e-4,0);

% Trust-region Newton-CG (Steihaug)
% xopt = trust_region(x0,fun,1e-4,1);
