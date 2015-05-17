function [xn]=newton(x0,fgH,tol)
%
%
% S. Ulbrich, F. Kruse, C. Boehm, 2012
%
% This code comes with no guarantee or warranty of any kind.
%
% function [xn]=newt(x0,fgH,tol)
%
% Robust line-search Newton method with Armijo-Goldstein stepsize rule. 
%
% Input:  x0      starting point
%         fgH     name of a matlab-function [f,g,H]=fgH(x)
%                 that returns value, gradient and Hessian (dense or sparse)
%                 of the objective function depending on the
%                 number of the given ouput arguments
%         tol     stopping tolerance: the algorithm stops
%                 if ||g(x)||<=tol*min(1,||g(x0)||)
%
% Output: xn      result after termination
%

% constant 0<del<1/2 for Armijo condition
del=0.001;
% constant 0<al<1 for sufficient decrease condition
al=0.001;

xj=x0;
[f,g,H]=feval(fgH,xj);
nmg0=norm(g);
nmg=nmg0;
it=0;

% main loop
while (norm(g)>tol*max(1,nmg0))
 it=it+1;
 sig=1;
% compute Newton step if H is not nearly singular
 warning off
 warning('Check H');

 s=H\g;
 step='Newt';

 warning backtrace
 w=lastwarn;
 if (w(1:7)~='Check H')
% H nearly singular, take gradient step
  s=g;
  step='Grad';
 end

% check if Newton step provides sufficient decrease; else take gradient
 stg=s'*g;
 if stg<min(al,nmg)*nmg*norm(s)
  s=g;
  stg=s'*g;
  step='Grad';
 end
% choose sig<=1 by Armijo stepsize rule
 sig=stepsize_armijo(xj,s,stg,fgH,f,del,1.0);
 xn=xj-sig*s;
 fprintf(1,'it=%3.d   f=%e   ||g||=%e   sig=%5.3f   step=%s\n',it,f,norm(g),sig,step);
 xj=xn;
 [f,g,H]=feval(fgH,xj);
 nmg=norm(g);
end
it=it+1;
fprintf(1,'it=%3.d   f=%e   ||g||=%e\n\n',it,f,norm(g));
fprintf(1,'Successful termination with ||g||<%e*max(1,||g0||):\n',tol);
