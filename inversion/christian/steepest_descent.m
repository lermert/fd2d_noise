function [xn,cn]=steepest_descent(x0,fg,tol,stepsz)
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

sig = 1;

xj=x0;
[f,g]=feval(fg,xj);
s=g;
nmg0=norm(g);
nmg=nmg0;
it=0;

% main loop
while (norm(g)>tol*max(0,nmg0))
 it=it+1;
 
 sig0=sig;
 stg=s'*g;

 if (stepsz==0)
% choose sig by Armijo stepsize rule starting with previous
% stepsize sig0. If sig0 is acceptable try sig=2^k*sig0.
  [sig,xn,fn,gn,cn]=stepsize_armijo(xj,s,stg,fg,f,del,sig0,1);
 else
% choose sig by Powell-Wolfe stepsize rule starting with previous
% stepsize sig0.
  [sig,xn,fn,gn,cn]=stepsize_wolfe(xj,s,stg,fg,f,del,theta,sig0);
 end
 
 %%%% xn=xj-sig*s;
 
 fprintf(1,'it=%3.d   f=%e   ||g||=%e  ||g||/||g0||=%e  sig=%5.3f\n',it,f,norm(g),norm(g)/nmg0,sig);
 save(sprintf('model_%i.mat',it),'xn','gn','cn')
 
 xj=xn;
 
 %%%% [f,g]=feval(fg,xj);
 f = fn;
 g = gn;
 
 s=g;
 nmg=norm(g);
 stg=s'*g;
end
it=it+1;
fprintf(1,'it=%3.d   f=%e   ||g||=%e  ||g||/||g0||=%e\n\n',it,f,norm(g),norm(g)/nmg0);
fprintf(1,'Successful termination with ||g||<%e*min(1,||g0||):\n',tol);

