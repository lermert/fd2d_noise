
function [width,absorb_left,absorb_right,absorb_top,absorb_bottom] = absorb_specs()

%==========================================================================
% absorbing boundaries
%==========================================================================

% width=30000;        % width of the boundary layer in km
width=250000.0;     % width of the boundary layer in km

absorb_left=1;      % absorb waves on the left boundary
absorb_right=1;     % absorb waves on the right boundary
absorb_top=1;       % absorb waves on the top boundary
absorb_bottom=1;    % absorb waves on the bottom boundary