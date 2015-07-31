function [r, EB_any2binsol, EB_rxbinsol] = scan_bound_core(central_R, ...
    sumMmax, min_1norm_p, union)
%RECTANGULAR_SCAN_BOUND_CORE is the core code for computing 2 types of 
%error bounds as in the paper: 
%   Error bounds on the reconstruction of binary images from low resolution
%   scans
%   K.J. Batenburg, W. Fortes
%   CAIP, Lecture Notes in Computer Science, Vol. 6855, 152-160. 2011.
%
% Wagner Fortes 2014/2015 wfortes@gmail.com

if isempty(central_R)
    central_R = ls_solver(W, Q, data.solver, data.maxit, data.tol);
end

npix = size(central_R(union),1);
% compute the number of non scanned pixels for a specific scan-window
N_min_not_scan_pix = npix-sumMmax;

% computing norm of high resolution image from its scanned data
bound_squared_xbin = min_1norm_p + N_min_not_scan_pix;

% square of radius
sqradius = bound_squared_xbin - dot(central_R, central_R);

% round to binary
[r, ~, ordb, ~] = round2binary(central_R);

% Vector of diference between R and its rounded (to binary) vector r
dif_Rr = central_R - r;

% Parameter R^2-T^2
parameter = sqradius - dot(dif_Rr, dif_Rr);

% Erro bound on the difference between any 2 possible high resolution
% images that generates the same set of scan data
eb_any2binsol = error_bound4r(ordb, 2*parameter);

% Erro bound on the difference between reconstruction r and high resolution
% image
eb_rxbinsol = error_bound4r(ordb, parameter);
%
