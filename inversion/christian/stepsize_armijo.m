function [sig,xn,fn,gn,cn]=stepsize_armijo(xj,s,stg,fct,f,del,sig0,sig_gt_1)
%
%
% S. Ulbrich, F. Kruse, C. Boehm, 2012
%
% This code comes with no guarantee or warranty of any kind.
%
% function [sig,xn,fn]=armijo(xj,s,stg,fct,f,del,sig0,sig_gt_1)
%
% Determines stepsize satisfying the Armijo-Goldstein condition
%
% Input:  xj       current point
%         s        search direction (xn=xj-sig*s)
%         stg      stg=s'*g
%         fct      name of a matlab-function [f]=fct(x)
%                  that returns the value of the objective function
%         f        current objective function value f=fct(xj)
%         del      constant 0<del<1/2 in Armijo condition f-fn>=sig*del*stg
%         sig0     initial stepsize (usually sig0=1)
%         sig_gt_1 optional: if the argument is given and sig0 satisfies
%                  Armijo then the maximal sig=2^k*sig0, k=0,1,... is
%                  determined, before Armijo is violated 
%
% Output: sig      stepsize sig satisfying the Armijo condition
%         xn       new point xn=xj-sig*s
%         fn       fn=f(xn)
%
 sig=sig0;
 xn=xj-sig*s;
 [fn,gn,cn]=feval(fct,xn);
% determine maximal sig=sig0/2^k satisfying Armijo
 while (f-fn<del*sig*stg)
  sig=0.5*sig;
  xn=xj-sig*s;
  [fn,gn,cn]=feval(fct,xn);
 end

% if sig=sig0 satisfies Armijo and sig_gt_1 is given then try sig=2^k*sig0
 if (sig==sig0) & (nargin==8)
  xnn=xj-2*sig*s;
  [fnn,gnn,cnn]=feval(fct,xnn);
  while (f-fnn>=2*del*sig*stg)
   sig=2*sig;
   xn=xnn;
   fn=fnn;
   gn=gnn;
   cn=cnn;
   xnn=xj-2*sig*s;
   [fnn,gnn,cnn]=feval(fct,xnn);
  end
 end
