
% Graphs Error X # projection angle
% Fixed image width. Several available
% Fixed phantom. Several available
%
clear all;
chemin='/ufs/fortes/Desktop/tomo_m_files/';
addpath(genpath(chemin));

% ------------- parameters:
img_index_set = [1,3,5];
ratio_set = [16,8,6,4];
img_sz_set = [512];
%
scan_k_set = [];
initial_corners = [];
inter = [];
uni = [];
for img_sz = img_sz_set
    N_scan_w_set_aux = ceil(img_sz./ratio_set);
    N_scan_w_set = [1,N_scan_w_set_aux];
    for img_index = img_index_set;
        aux = 1;
        for N_scan_w = N_scan_w_set
            % ----------------------------- do not change:
            P = img_read(img_index,img_sz);
            P = double(P);
            P = P/max(max(P)); % only for binary images
            % -------------------------------------------
            [min_norm_y M_main y_main sumMmax,scan_k,initial_corners,...
                uni,inter,n1_p_sub] = rectang_scan_aquisition(P,img_sz,...
                'N_scan_w',N_scan_w,initial_corners,uni,inter);
            %
%             [min_norm_y M_main y_main sumMmax,scan_k,uni] = ...
%                 rectang_scan_aquisition_regular(P,img_sz,'N_scan_w',N_scan_w);
%             scan_k_set = [scan_k_set N_scan_w];
            %
            P = reshape(P,img_sz^2,1);
            npix = length(P);
            
            % Q = M_main * P;
            [R, res, sol] = cgls_W(M_main, y_main, 100, 1e-10);
%             [R, res, sol] = cgls_W(M_main, y_main, 100, 1e-10);
            %
            [r Rr(aux,1) s(aux,1) Vx(aux,1) Vr1(aux,1) Vr2(aux,1)]...
                = rectang_scan_bound_core(P,R,sumMmax,min_norm_y,uni,inter,n1_p_sub,'useless');
            %
            aux = aux+1; % ------------------------------------------------
            %              size(M_main,2)/size(M_main,1)
            P_uni = P(uni);
            R_uni = R(uni);
            r_uni = r(uni);
            
%             z = reshape(P_uni-R_uni,sqrt(size(P_uni,1)),sqrt(size(P_uni,1)));
%             figure;z=imshow(z,[min(z(:)) max(z(:))]);
%             img = num2str(img_index);
%             sz = num2str(img_sz);
%             scan = num2str(scan_k);
%             filename = strcat('P-xls','-rand-image','-Im',img,'-sz',sz,'-scan',scan,'-wsz-64','.fig');
%             saveas(z,filename);
%             clear z;
%             z = reshape(P_uni-r_uni,sqrt(size(P_uni,1)),sqrt(size(P_uni,1)));
%             figure;z=imshow(z,[min(z(:)) max(z(:))]);
%             filename = strcat('P-r','-rand-image','-Im',img,'-sz',sz,'-scan',scan,'-wsz-64','.fig');
%             saveas(z,filename);
%             clear z;
        end
        uni=[];
        inter=[];
        it = N_scan_w_set;
% it = N_scan_w_set;
% scan_k_set = [];
        % Vr2 is more accurate
        %         figura = semilogy(it,Vx(:,1),'c-o','LineWidth',1.2,'MarkerSize',7);
        figura = semilogy(it,Vr2(:,1),'m-+','LineWidth',1.2,'MarkerSize',7);
        hold on
        %         semilogy(it,Vr1(:,1),'k-d','LineWidth',1.2,'MarkerSize',7);
        %         semilogy(it,Vr2(:,1),'m-+','LineWidth',1.2,'MarkerSize',7);
        semilogy(it,s(:,1),'b-s','LineWidth',1.2,'MarkerSize',7);
        semilogy(it,Rr(:,1),'r-x','LineWidth',1.2,'MarkerSize',7);
        %
        %         legend('Vx','Vr1','Vr2','Error bound r','True error')
        legend('Variability','Error bound r','True error')
        hold off;
        xlabel('Number of scan-windows','fontsize',14)
        ylabel('Fraction of pixels','fontsize',14)
        %         title(['ratio = ',num2str(size(M_main,2)/size(M_main,1))])
        %
        img = num2str(img_index);
        sz = num2str(img_sz);
        filename = strcat('V+BE+E-','rand-rectang-scan','-Im',img,'-sz',sz,'-wsz-64','.fig');
%         filename = strcat('all-','rectang-scan','-Im',img,'-sz',sz,'.fig');
        saveas(figura,filename);
        clear figura;
    end
    initial_corners = [];
end