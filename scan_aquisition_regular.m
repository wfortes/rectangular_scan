function [min_norm_y, M_main, y_main, sumMmax, uni] = ...
    scan_aquisition_regular(P, N_scan_shifts, scan_window_sz)
%RECTANGULAR_SCAN_AQUISITION_REGULAR generates data from the rectangular
%scanning of higher resolution images using lower resolution scans with
%regularly distributed scannng window position
%   Output:
%   MIN_NORM_Y is the minimum norm among the norms of k blocks of Y_MAIN
%   M_MAIN is the scan matrix
%   Y_MAIN is the vetor of acquired scan data (lower resolution image)
%   SUMMAX is the max column sum among the k blocks of M_MAIN
%   UNI are the indexes of the scanned pixels
%
%   Input:
%   P is the higher resolution image
%   N_SCAN_SHIFTS is the number of rectangular scan shifts
%   SCAN_WINDOW_SZ is the number of rows on the scan window
%
% Wagner Fortes 2014/2015 wfortes@gmail.com

k = N_scan_shifts; % number of rectangular scan shifts

count_aux = floor((scan_window_sz-1)/k)+1;
initial_corners = zeros(2,k);
aux = 0;

for i=0:k-1
    for j=0:k-1
        aux = aux+1;
        initial_corners(1,aux) = 1+i*count_aux;
        initial_corners(2,aux) = 1+j*count_aux;
    end
end

% ---------- Rectangular scan:
M_main = [];
y_main = [];
col = cell(k,1);
idx = 1;
for i=1:k
    [M{i} y{i}] = rectangular_scan(P,scan_window_sz,[],initial_corners(:,i));
    if i==1
        sumMmax = sum(sum(M{1}));
        sumMnew = sumMmax;
        min_norm_y = norm(y{1},1);
        min_norm_y_new = min_norm_y;
    else
        sumMnew = sum(sum(M{idx}));
        min_norm_y_new = norm(y{idx},1);
    end
    if sumMmax<sumMnew
        idx = i;
        sumMmax = sumMnew;
        min_norm_y = min_norm_y_new;
    elseif(sumMmax==sumMnew) && (min_norm_y > min_norm_y_new)
        idx = i;
        sumMmax = sumMnew;
        min_norm_y = min_norm_y_new;
    end
    M_main=[M_main;cell2mat(M(i))];
    y_main=[y_main;cell2mat(y(i))'];
    
    [~,col{i}] = find(M{i});
    if i>1
        uni = union(uni, col{i});
    else
        uni = col{1};
    end
end
% -------------------------------------------------------------