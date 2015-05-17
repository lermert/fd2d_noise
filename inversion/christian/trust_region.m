function [xj]=tr(x0,fgH,tol,trsolv,Del0)
%
%
% S. Ulbrich, F. Kruse, C. Boehm, 2012
%
% This code comes with no guarantee or warranty of any kind.
%
% function [xn]=tr(x0,fgH,tol,trmethod)
%
% Trust-region algorithm with exact solution of the TR-problems
% or inexact solution with Steihaug-CG.
%
% Input:  x0      starting point
%         fgH     name of a matlab-function [f,g,H]=fgH(x)
%                 that returns value, gradient and Hessian (dense or sparse)
%                 of the objective function depending on the
%                 number of the given ouput arguments
%         tol     stopping tolerance: the algorithm stops
%                 if ||g(x)||<=tol*min(1,||g(x0)||)
%         trsolv  0: exact solution of TR-subproblem
%                 1: inexact solution with Steihaug-CG
%         Del0    initial TR-radius (optional)
%                 if not given Del0=1 is used
%
% Output: xn      result after termination
%

% constants for check of decrease ratio
eta1=0.001;
eta2=0.8;

if nargin<5
 Del=1;
else
 Del=Del0;
end
xj=x0;
[f,g,H]=feval(fgH,xj);
nmg0=norm(g);
nmg=nmg0;
it=0;

% main loop
while (norm(g)>tol*max(1,nmg0))
 if trsolv==0
  s=trust_region_subproblem_exact(H,g,Del,tol);
 else
  [s, ncg] =trust_region_subproblem_CG(H,g,Del,min(0.5,norm(g)));
 end
 pred=-(g'*s+0.5*s'*H*s);
 [fn]=feval(fgH,xj+s);
 ared=f-fn;
 if ared>eta1*pred
  xj=xj+s;
  [f,g,H]=feval(fgH,xj);
  if ared>eta2*pred
   Del=2*Del;
  end
  if trsolv == 0
    fprintf(1,'it=%3.d   f=%e   ||g||=%e   Delta=%5.3f\n',it,f,norm(g),Del);
  else
      fprintf(1,'it=%3.d   f=%e   ||g||=%e   Delta=%e   it_cg=%d \n',it,f,norm(g),Del,ncg);
  end
  it=it+1;
 else
  Del=min(0.5*Del,norm(s));
 end
end
fprintf(1,'Successful termination with ||g||<%e*max(1,||g0||):\n',tol);
