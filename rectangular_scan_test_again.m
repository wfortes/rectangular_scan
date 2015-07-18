% testing rectangular scan

% Graphs Error X # projection angle
% Fixed image width. Several available
% Fixed phantom. Several available
%
clear all;
chemin='/ufs/fortes/Desktop/tomo_m_files/';
addpath(genpath(chemin));

% ------------- parameters:
img_index_set = 5;%[1,3,5];
% ratio_set = [16,8,4,2,1];
img_sz_set = [512];
scan_window_sz_set=[32,8];%[32,16,8];% 64 have problems with memory
distribution_set = [0,1];
%
initial_corners = [];
uni = [];inter=[];
for distribution = distribution_set
    if distribution==0
        type = 'regular';
    else
        type = 'random';
    end
    for scan_window_sz=scan_window_sz_set
        if scan_window_sz == 8
            ratio_set = [8,4,2,1];
        elseif scan_window_sz == 16
            ratio_set = [16,8,4,2,1];
        elseif scan_window_sz == 32
            ratio_set = [32,16,8,4,2];
        elseif scan_window_sz == 1
            ratio_set = 1;
        end
        N_scan_w_set = scan_window_sz./ratio_set;
        for img_sz = img_sz_set
            %     N_scan_w_set_aux = ceil(img_sz./ratio_set);
            %     N_scan_w_set = [1,N_scan_w_set_aux];
            
            for img_index = img_index_set;
                aux = 1;
                for N_scan_w = N_scan_w_set
                    % ----------------------------- do not change:
                    P = img_read(img_index,img_sz);
                    P = double(P);
                    P = P/max(max(P)); % only for binary images
                    % -------------------------------------------------------------------------------------
                    %
                    if strcmp(type,'random')
                        [min_norm_y M_main y_main sumMmax,initial_corners,...
                            uni] = rectang_scan_aquisition_rand(P,img_sz,...
                            'N_scan_w',N_scan_w,initial_corners,uni,scan_window_sz);
                    elseif strcmp(type,'regular')
                        [min_norm_y M_main y_main sumMmax,uni] = ...
                            rectang_scan_aquisition_regular(P,img_sz,'N_scan_w',N_scan_w,scan_window_sz);
                    end
                    n1_p_sub=[];
                    %
                    P = reshape(P,img_sz^2,1);
                    npix = length(P);
                    
                    % Q = M_main * P;
                    [R, res, sol] = cgls_W(M_main, y_main,[], 100, 1e-10);
                    %
                    [r Rr(aux,1) s(aux,1) Vx(aux,1) Vr1(aux,1) Vr2(aux,1)]...
                        = rectang_scan_bound_core(P,R,sumMmax,min_norm_y,uni,inter,n1_p_sub,'useless');
                    
                    % ---------------------------------------------------------------------------------------
                    aux = aux+1; 
%                     build_and_save_image(P,R,r,uni,img_index,img_sz,scan_window_sz,N_scan_w,type)
                end
                uni=[];inter=[];
                it = N_scan_w_set.^2;
                build_and_save_graphs(img_index,img_sz,scan_window_sz,N_scan_w,it,Vr2,s,Rr,type)
                %----------------------------------------------------------
                clear Rr s Vx Vr1 Vr2
            end
            close all
            initial_corners = [];
        end
    end
end
