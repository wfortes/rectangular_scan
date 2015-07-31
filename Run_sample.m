%This example computes 2 types of error bounds as in the paper: 
%   Error bounds on the reconstruction of binary images from low resolution
%   scans
%   K.J. Batenburg, W. Fortes
%   CAIP, Lecture Notes in Computer Science, Vol. 6855, 152-160. 2011.
%
%
% Wagner Fortes 2014/2015 wfortes@gmail.com

% ------------- parameters:
img_index = 3; % select image index from 1 to 5
img_sz = 128;  % select image dimension 32, 64, 128, 256, 512
scan_window_sz = 8; % select sz of scan window <= img_sz
% ratio between size of scan window and number of scan windows
ratio_set = [8,4,2,1];
scan_distribution = 'regular'; % 'regular' or 'random'
% --------------
N_scan_windows_set = scan_window_sz./ratio_set;

initial_corners = [];
uni = [];

% loads image
P = img_read(img_sz, img_index);
P = double(P);
P = P/max(max(P)); % only for binary images

aux = 1;
for N_scan_w = N_scan_windows_set
       
    if strcmp(scan_distribution,'random')
        [min_norm_y, M_main, y_main, sumMmax,initial_corners, uni] = ...
            scan_aquisition_rand(P, N_scan_w, initial_corners, uni,scan_window_sz);
    elseif strcmp(scan_distribution,'regular')
        [min_norm_y, M_main, y_main, sumMmax, uni] = ...
            scan_aquisition_regular(P, N_scan_w, scan_window_sz);
    end
    
    %
    P_vector = reshape(P,img_sz^2,1);
    
    central_R = ls_solver(M_main, y_main, [], [], []);
    %
    [r, EB1(aux,1), EB2(aux,1)] = scan_bound_core(central_R, sumMmax, min_norm_y, uni);
    
    % true error of r
    npix = size(P_vector(uni),1);
    Pr(aux,1) = norm(P_vector-r,1)/npix;

    aux = aux+1;
end

it = N_scan_w_set.^2;
build_graphs_scan(N_scan_windows_set, EB1/npix, EB2/npix, Pr)
%----------------------------------------------------------
clear Rr V U
%