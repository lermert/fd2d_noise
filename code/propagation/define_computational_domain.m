function [X,Z,x,z,dx,dz] = define_computational_domain(Lx,Lz,nx,nz)

%==========================================================================
% define the geometry and discretisation of the computational domain
%
% input:
%-------
% Lx, Lz: extensions of the computational doman [m] in x- and z-directions
% nx, nz: number of grid points in x- and z-directions
%
% output:
%--------
% X, Z: coordinate matrices
% x, z: coordinate vectors
% dx, dz: grid sizes in x- and z-directions
%==========================================================================

dx = Lx/(nx-1);
dz = Lz/(nz-1);

x = 0:dx:Lx;
z = 0:dz:Lz;

[X,Z] = meshgrid(x,z);
