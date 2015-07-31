function [min_norm_y, M_main, y_main, sumMmax, initial_corners, uni] = ...
    scan_aquisition_rand(P, N_scan_shifts, initial_corners, uni, scan_window_sz_r)
%RECTANGULAR_SCAN_AQUISITION_RAND generates data from the rectangular
%scanning of higher resolution images using lower resolution scans with
%randomly chosen scannng window position
%   Output:
%   MIN_NORM_Y is the minimum norm among the norms of k blocks of Y_MAIN
%   M_MAIN is the scan matrix
%   Y_MAIN is the vetor of acquired scan data (lower resolution image)
%   SUMMAX is the max column sum among the k blocks of M_MAIN
%   INITIAL_CORNERS is the upper left coordinates of 1st scan window
%   UNI are the indexes of the scanned pixels
%
%   Input:
%   P is the higher resolution image
%   N_SCAN_SHIFTS is the number of rectangular scan shifts
%   INITIAL_CORNER coordinates of the upper left pixel of the scan window
%   UNI are the indexes of the scanned pixels
%   SCAN_WINDOW_SZ_R is the number of rows on the scan window
%
% Wagner Fortes 2014/2015 wfortes@gmail.com

scan_window_sz_c = scan_window_sz_r;  % number of rows = number of columns
k = N_scan_shifts; % number of rectangular scan shifts

if isempty(initial_corners)
    %
    % ---------------- Build the set of initial scan windows
    initial_corners = zeros(2,k);
    initial_corners(1,1) = 1; initial_corners(2,1) = 1;
%     initial_corners(1,1) = randi(scan_window_sz_r,1); % choose randomly
%     initial_corners(2,1) = randi(scan_window_sz_c,1); % choose randomly
    
    fillin = 1;
else
    fillin = size(initial_corners,2);
end
    if k>scan_window_sz_r*scan_window_sz_c
        error('Problem: N_scan_shifts = %g > %g = scan-window size',k ,...
            scan_window_sz_r * scan_window_sz_c);
    elseif k==scan_window_sz_r*scan_window_sz_c
        aux = 1;
        for i=1:scan_window_sz_r
            for j=1:scan_window_sz_c
                initial_corners(1,aux) = i;
                initial_corners(2,aux) = j;
                aux =aux +1;
            end
        end
    else
        while fillin<k
            left_up_corner_r = randi(scan_window_sz_r,1); % choose randomly
            left_up_corner_c = randi(scan_window_sz_c,1); % choose randomly
            check = 1;
            while check < fillin
                if initial_corners(1,check)==left_up_corner_r && initial_corners(2,check)==left_up_corner_c
                    left_up_corner_r = randi(scan_window_sz_r,1); % choose randomly
                    left_up_corner_c = randi(scan_window_sz_c,1); % choose randomly
                    check = 1;
                else
                    check = check +1;
                end
            end
            fillin = fillin + 1;
            initial_corners(1,fillin) = left_up_corner_r;
            initial_corners(2,fillin) = left_up_corner_c;
        end % -----------------------------------------------------------------
    end

% ---------- Rectangular scan:
M_main = [];
y_main = [];
col = cell(k,1);
idx = 1;
for i=1:k
    [M{i} y{i}] = rectangular_scan(P,scan_window_sz_r,[],initial_corners(:,i));
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
%         inter = intersect(inter, col{i});
        uni = union(uni, col{i});
    elseif isempty(uni)
%         inter = col{1};
        uni = col{1};
    end
end
% -------------------------------------------------------------