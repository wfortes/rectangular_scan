% testing rectangular scan
% Contain 2 codes
% 1st: Graphs "Error" X Image width
% 2nd: Graphs "Error" X # projection angle
%
% clear all
% chemin='/ufs/fortes/Desktop/tomo_m_files/';
% addpath(genpath(chemin));
%
% % ------------- parameters:
% img_index_set = [1,3,5];
% ratio_set = [16,8,4];
% img_sz_set = [64,128,256,512];
% %
% for img_index = img_index_set
%     for ratio = ratio_set
%         aux_sz = 1;
%         for img_sz = img_sz_set
%             % ----------------------------- do not change:
%             P = img_read(img_index,img_sz);
%             P = double(P);
%             P = P/max(max(P)); % only for binary images
%             % -------------------------------------------
%             [min_norm_y M_main y_main sumMmax] = ...
%                 rectang_scan_aquisition(P,img_sz,'ratio',ratio);
%             %
%             P = reshape(P,img_sz^2,1);
%             npix = length(P);
%
%             % Q = M_main * P;
%             [R, res, sol] = cgls_W(M_main, y_main, 25, 1e-5);
%             %
%             [r Rr(aux_sz,1) s(aux_sz,1) Vx(aux_sz,1) Vr1(aux_sz,1) Vr2(aux_sz,1)]...
%                 = rectang_scan_bound_core(P,npix,R,sumMmax,min_norm_y);
%             %
%             aux_sz=aux_sz+1;
%         end
%         it = img_sz_set;
%         % Vr2 is more accurate
%         figura = semilogy(it,Vr2(:,1),'m-+','LineWidth',1.2,'MarkerSize',7);
%         hold on
%         semilogy(it,s(:,1),'b-s','LineWidth',1.2,'MarkerSize',7);
%         semilogy(it,Rr(:,1),'r-x','LineWidth',1.2,'MarkerSize',7);
%         %
%         legend('Variability','Error bound r','True error')
%         hold off;
%         xlabel('Image width','fontsize',14)
%         ylabel('Fraction of pixels','fontsize',14)
%         %
%         img = num2str(img_index);
%         rat = num2str(ratio);
%         filename = strcat('V+BE+E-','rectang-scan','-Im',img,'-r',rat,'.fig');
%         saveas(figura,filename);
%         clear figura;
%     end
% end
%%