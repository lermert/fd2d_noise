function s=solvetr(C,c,Del,trtol)
%
%
% S. Ulbrich, F. Kruse, C. Boehm, 2012
%
% This code comes with no guarantee or warranty of any kind.
%
% function s=solvetr(C,c,Del,trtol)
%
% Exact solution of the TR-problem
%
%         min Q(s):=c'*s+1/2*s'*C*s   s.t. ||s||<=Del
%
% Note: hard case not yet implemented
%
% Input:  C       symmetric nxn-matrix (sparse or dense)
%         c       n-vector (column vector)
%         Del     TR-radius
%         trtol   tolerance for trust-region radius:
%                 the final iterate solves the TR-problem
%                 for some Del' in [(1-trtol)*Del,(1+trtol)*Del]
%
%
% Output: s       result after termination

 [R,p]=chol(C);
 la=0;
 if (p~=0)
% C not positive definit
  la=max(sum(abs(C))'-spdiags(C,0));
  la=la+1;
  R=chol(C+la*speye(size(C)));
 end
 s=(c'/R);
 s=-(R\(s'));
 rho=norm(s);
 if (la==0)&(rho<=Del)
  return
 end
 while abs(rho-Del)>trtol*Del
  la0=la;
  h=(s'/R);
  h=(R\(h'));
  drho=-(s'*h)/rho;
  la=la-rho^2/drho*(1/Del-1/rho);
  p=1;
  while (p~=0)
   [R,p]=chol(C+la*speye(size(C)));
   if (p~=0) la=0.5*(la+la0); end
  end
  s=(c'/R);
  s=-(R\(s'));
  rho=norm(s);
 end
