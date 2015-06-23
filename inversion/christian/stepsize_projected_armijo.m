function [sig,xn,fn,gn,cn]=stepsize_projected_armijo(xj,s,fct,f,del,sig0,sig_gt_1, xl, xu)
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
 xn=project_model(xj-sig*s, xl, xu);
 if (norm(max(xl-xn,0) + max(xn-xu,0) )  > 0)
    disp ('Warning: projection method failed!!')
 end
 [fn,gn,cn]=feval(fct,xn);
 
% determine maximal sig=sig0/2^k satisfying Armijo
 while (f-fn<del* norm(xj-xn)^2 / sig)
    sig=0.5*sig;
    xn=project_model(xj-sig*s, xl, xu);
    [fn,gn,cn]=feval(fct,xn);
 end
 
 fprintf('Projected Armijo condition satisfied for sigma = %f\n', sig);

% if sig=sig0 satisfies Armijo and sig_gt_1 is given then try sig=2^k*sig0
 if (sig==sig0) & (sig_gt_1)
  xnn=project_model(xj-2*sig*s, xl, xu);
   if (norm(max(xl-xnn,0) + max(xnn-xu,0) )  > 0)
    disp ('Warning: projection method failed!!')
    end 
  [fnn,gnn,cnn]=feval(fct,xnn);
  while (f-fnn>=del* norm(xj-xnn)^2 / (2*sig) )
   sig=2*sig;
   fprintf('Projected Armijo condition satisfied for sigma = %f\n', sig);
   xn=xnn;
   fn=fnn;
   gn=gnn;
   cn=cnn;
   xnn=project_model(xj-2*sig*s, xl, xu);
   if (norm(max(xl-xnn,0) + max(xnn-xu,0) )  > 0)
    disp ('Warning: projection method failed!!')
    end 
   [fnn,gnn,cnn]=feval(fct,xnn);
  end
 end
