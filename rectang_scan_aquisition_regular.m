function [min_norm_y M_main y_main sumMmax,uni] = ...
    rectang_scan_aquisition_regular(P,img_sz,N_scan_windows,ratio,scan_window_sz_r)
%
scan_window_sz_c = scan_window_sz_r;         % number of columns
if strcmp(N_scan_windows,'ratio')
    k = ceil(img_sz/ratio);       % number of rectangular scan shifts
elseif strcmp(N_scan_windows,'N_scan_w')
    k=ratio;
end

count_aux = floor((scan_window_sz_r-1)/k)+1;
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
        uni = union(uni, col{i});
    else
        uni = col{1};
    end
end
% -------------------------------------------------------------