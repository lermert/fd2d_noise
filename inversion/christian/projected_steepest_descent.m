function [xn,cn]=projected_steepest_descent(x0,xl,xu,fg,tol,stepsz)
%
%
% S. Ulbrich, F. Kruse, C. Boehm, 2012
%
% This code comes with no guarantee or warranty of any kind.
%
% function [xn]=grad(x0,fg,tol,stepsz)
%
% Steepest descent method with Armijo-Goldstein or
% Powell-Wolfe stepsize rule. 
%
% Input:  x0      starting point
%         fg      name of a matlab-function [f,g]=fg(x)
%                 that returns value and gradient
%                 of the objective function depending on the
%                 number of the given ouput arguments
%         tol     stopping tolerance: the algorithm stops
%                 if ||g(x)||<=tol*min(1,||g(x0)||)
%         stepsz  0: Armijo, 1: Powell-Wolfe
%
% Output: xn      result after termination
%

% constant 0<del<1/2 for Armijo condition
del=0.001;
% constant del<theta<1 for Wolfe condition
theta=0.6;

sig = 0.250;

verbose = true;

xj=project_model(x0, xl, xu);

[f,g]=feval(fg,xj);
s=g;
gp = project_gradient(g, xj, xl, xu);
nmg0=norm(gp);
nmg=nmg0;
it=0;

if (verbose)
   norm(max(xl-xj,0) + max(xj-xu,0) ) 
   norm(gp-g)
   disp 'Active set lower bound:'
   find(xj==xl)
   disp 'Active set upper bound:'
   find(xj==xu)
end

% main loop

while (nmg>tol*max(0,nmg0))
 it=it+1;
 
 sig0=sig;
 
% choose sig by Armijo stepsize rule starting with previous
% stepsize sig0. If sig0 is acceptable try sig=2^k*sig0.
  [sig,xn,fn,gn,cn]=stepsize_projected_armijo(xj,s,fg,f,del,sig0,1, xl, xu);
 
 %%%% xn=xj-sig*s;
 
 fprintf(1,'it=%3.d   f=%e   ||g||=%e  ||g||/||g0||=%e  sig=%5.3f\n',it,f,nmg,nmg/nmg0,sig);
 save(sprintf('model_%i.mat',it),'xn','gn','cn')
 
 xj=xn;
 
 if (verbose)
   norm(max(xl-xj,0) + max(xj-xu,0) ) 
 end 
 if (norm(max(xl-xj,0) + max(xj-xu,0) )  > 0)
    disp ('Warning: projection method failed!!')
 end 
 
 %%%% [f,g]=feval(fg,xj);
 f = fn;
 g = gn;
 
 s=g;
 gp = project_gradient(g, xj, xl, xu);
 nmg=norm(gp);
end
it=it+1;
fprintf(1,'it=%3.d   f=%e   ||g||=%e  ||g||/||g0||=%e\n\n',it,f,nmg,nmg/nmg0);
fprintf(1,'Successful termination with relative tol %e:\n',tol);

