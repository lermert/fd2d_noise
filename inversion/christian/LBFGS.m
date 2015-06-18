function [xn]=LBFGS(x0,fg,tol,lmax)
%
%
% S. Ulbrich, F. Kruse, C. Boehm, 2012
%
% This code comes with no guarantee or warranty of any kind.
%
% function [xn]=LBFGS(x0,fg,tol,lmax)
%
% Limited memory BFGS-method with Powell-Wolfe stepsize rule. 
%
% Input:  x0      starting point
%         fg      name of a matlab-function [f,g]=fg(x)
%                 that returns value and gradient
%                 of the objective function depending on the
%                 number of the given ouput arguments
%         tol     stopping tolerance: the algorithm stops
%                 if ||g(x)||<=tol*max(1,||g(x0)||)
%         lmax    optional: maximal number of stored updates for
%                 the limited memory BFGS-approximation
%                 if not given, lmax=60 is used
%
% Output: xn      result after termination
%

% constants 0<del<theta<1, del<1/2 for Wolfe condition
del=0.001;
theta=0.6;
% constant 0<al<1 for sufficient decrease condition
al=0.001;
% lmax=5;
P=zeros(size(x0,1),lmax);
D=zeros(size(x0,1),lmax);
ga=zeros(lmax,1);
rho=zeros(lmax,1);
l=0;
gak=1;

xj=x0;
[f,g]=feval(fg,xj);
nmg0=norm(g);
nmg=nmg0;
it=0;
max_it=30;
l=0;
ln=1;

% main loop
% while (norm(g)>tol*max(1,nmg0))
while (norm(g)>tol*max(0,nmg0))
 it=it+1;

 if(it>max_it)
   return
 end
 
 if(it==1)
     sig = 16;
 else
     sig=1;
 end
 
% compute BFGS-step s=B*g;
 q=g;
 for j=1:l
  i=mod(ln-j-1,lmax)+1;
  ga(i)=rho(i)*(P(:,i)'*q);
  q=q-ga(i)*D(:,i);
%  pause
 end
 r=gak*q;
 for j=l:-1:1
  i=mod(ln-j-1,lmax)+1;
  be=rho(i)*(D(:,i)'*r);
  r=r+(ga(i)-be)*P(:,i);
 % pause;
 end
 s=r;
 step='LBFGS';

% check if BFGS-step provides sufficient decrease; else take gradient
 stg=s'*g;
 if stg<min(al,nmg)*nmg*norm(s)
  s=g;
  stg=s'*g;
  step='Grad';
 end
% choose sig by Powell-Wolfe stepsize rule
%xj
%s
%g
 [sig,xn,fn,gn]=stepsize_wolfe(xj,s,stg,fg,f,del,theta,sig);
 % xn=xj-sig*s;

 fprintf(1,'it=%3.d   f=%e   ||g||=%e   sig=%6.5f   step=%s\n',it,f,norm(g),sig,step);
 save(sprintf('model_%i.mat',it),'xn','gn')
 % [fn,gn]=feval(fg,xn);
%xn
%gn
% update BFGS-matrix
 d=g-gn;
 p=xj-xn;
 dtp=d'*p;
 if dtp>=1e-8*norm(d)*norm(p)
  rho(ln)=1/dtp;
  D(:,ln)=d;
  P(:,ln)=p;
  l=min(l+1,lmax);
  ln=mod(ln,lmax)+1;
  %if l==lmax
  % gak=dtp/(d'*d);
  %end
 end
 xj=xn;
 g=gn;
 f=fn;
 nmg=norm(g);
%D
%P
%rho
%pause
end
it=it+1;
fprintf(1,'it=%3.d   f=%e   ||g||=%e\n\n',it,f,norm(g));
fprintf(1,'Successful termination with ||g||<%e*max(1,||g0||):\n',tol);
