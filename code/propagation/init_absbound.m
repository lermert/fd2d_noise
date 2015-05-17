
function [absbound] = init_absbound()

% get parameters
[Lx,Lz,nx,nz,~,~,~,~] = input_parameters();
[X,Z,~,~,~,~] = define_computational_domain(Lx,Lz,nx,nz);

absbound = ones(nx,nz);
[width,absorb_left,absorb_right,absorb_top,absorb_bottom] = absorb_specs();


%- Initialisation of Cerjan-type absorbing boundary tapers ----------------
%--------------------------------------------------------------------------

%- left boundary
if (absorb_left==1)
    absbound=absbound.*(double([X'>width])+exp(-(X'-width).^2/(2*width)^2).*double([X'<=width]));
end
%- right boundary
if (absorb_right==1)
    absbound=absbound.*(double([X'<(Lx-width)])+exp(-(X'-(Lx-width)).^2/(2*width)^2).*double([X'>=(Lx-width)]));
end
%- bottom boundary
if (absorb_bottom==1)
    absbound=absbound.*(double([Z'>width])+exp(-(Z'-width).^2/(2*width)^2).*double([Z'<=width]));
end
%- top boundary
if (absorb_top==1)
    absbound=absbound.*(double([Z'<(Lz-width)])+exp(-(Z'-(Lz-width)).^2/(2*width)^2).*double([Z'>=(Lz-width)]));
end
