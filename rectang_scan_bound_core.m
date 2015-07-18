function [r Rr s Vx Vr1 Vr2] = rectang_scan_bound_core(P,R,sumMmax,min_1norm_p,union,inter,n1_p_sub,str)

if ~strcmp(str,'subimage')
npix = size(P(union),1);
% compute the number of non scanned pixels for a specific scan-window
N_min_not_scan_pix = npix-sumMmax;

% computing norm(x) from its projection
bound_squared_xbin = min_1norm_p + N_min_not_scan_pix;

% square of radius
sqradius = bound_squared_xbin - dot(R,R);

% round to binary
[r, b, ordb, Ix, alpha] = round2binary(R);

Rr = norm(P-r,1)/npix; % true % error of r

parameter = sqradius - dot(alpha,alpha);

% bound the number of wrong pixels in r
s = bnwpixr(ordb,parameter,Ix,bound_squared_xbin,r,'notlimited')/npix;

% The 3 variabilities
[Vx Vr1 Vr2 wpix wpix1] = variability(npix,sqradius,s, ...
    ordb,parameter,Ix,bound_squared_xbin,r,'notlimited');
%
else
    P_sub = P(inter);
    R_sub = R(inter);
    
    npix = size(P_sub,1);
    
% computing norm(x) from its projection
bound_squared_xbin = n1_p_sub;

% square of radius
sqradius = bound_squared_xbin - dot(R_sub,R_sub);

% round to binary
[r, b, ordb, Ix, alpha] = round2binary(R_sub);

Rr = norm(P_sub-r,1)/npix; % true % error of r

parameter = sqradius - dot(alpha,alpha);

% bound the number of wrong pixels in r
s = bnwpixr(ordb,parameter,Ix,bound_squared_xbin,r,'notlimited')/npix;

% The 3 variabilities
[Vx Vr1 Vr2 wpix wpix1] = variability(npix,sqradius,s, ...
    ordb,parameter,Ix,bound_squared_xbin,r,'notlimited');
end