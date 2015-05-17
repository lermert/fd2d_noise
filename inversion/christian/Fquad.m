function [f,g,H]=Fquad(x)
%
%  Computes value, gradient and Hessian (depending on the number
%  of given output arguments) of the quadratic function
%
%            f(x)=0.5*x'*diag(1,20,...,20*(n-1))*x
%
n=size(x,1);
Q=diag([1;[20:20*(n-1)]']);
f=0.5*x'*Q*x;

if nargout>1
 g=Q*x;
end

if nargout>2
 H=Q;
end
