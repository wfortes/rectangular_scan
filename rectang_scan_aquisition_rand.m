function [min_norm_y M_main y_main sumMmax,initial_corners,uni] = ...
    rectang_scan_aquisition_rand(P,img_sz,N_scan_windows,ratio,initial_corners,uni,scan_window_sz_r)
%
scan_window_sz_c = scan_window_sz_r;         % number of columns
if strcmp(N_scan_windows,'ratio')
    k = ceil(img_sz/ratio);       % number of rectangular scan shifts
elseif strcmp(N_scan_windows,'N_scan_w')
    k=ratio;
end

if isempty(initial_corners)
    %
    % --------------------------------- Build the set of initial scan windows
    initial_corners = zeros(2,k);
    initial_corners(1,1) = 1; initial_corners(2,1) = 1;
%     initial_corners(1,1) = randi(scan_window_sz_r,1); % choose randomly
%     initial_corners(2,1) = randi(scan_window_sz_c,1); % choose randomly
    
    fillin = 1;
    if k>scan_window_sz_r*scan_window_sz_c
        error('Problem: k=%g > %g = scan-window size',k,scan_window_sz_r*scan_window_sz_c);
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
else
    fillin = size(initial_corners,2);
    if k>scan_window_sz_r*scan_window_sz_c
        error('Problem: k=%g > %g = scan-window size',k,scan_window_sz_r*scan_window_sz_c);
    elseif k==scan_window_sz_r*scan_window_sz_c
        aux = 1;
        for i=size(initial_corners,2):scan_window_sz_r
            for j=size(initial_corners,2):scan_window_sz_c
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
end
% % Attempt to allocate space for the matrices M{i}
% [m,n] =  size(P);
% nc = m*n;
% factor1 = zeros(k);
% factor2 = zeros(k);
% nr = zeros(k);
% % M = cell(1,k); % is it correct?
% % y = cell(k);   % is it correct?
% for i=1:k
%     factor1(i) = floor((m-initial_corners(1,i)+1)/scan_window_sz_r); % aux nr
%     factor2(i) = floor((n-initial_corners(2,i)+1)/scan_window_sz_c); % aux nr
%     nr(i) = factor1(i)*factor2(i);
%     M{i} = cell(nr(i),nc); % attempt to pre-allocate
%     y{i} = cell(nr(i),1);  % attempt to pre-allocate
% end
% -------------------------------------------------------------
%
% ---------- Rectangular scan:
M_main = [];
y_main = [];
col = cell(k,1);
idx = 1;
for i=1:k
    [M{i} y{i}] = rectangular_scan_Beta(P,scan_window_sz_r,[],initial_corners(:,i));
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