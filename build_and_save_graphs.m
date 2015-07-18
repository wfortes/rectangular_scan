function build_and_save_graphs(img_index,img_sz,scan_window_sz,N_scan_w,it,Vr2,s,Rr,type)
%
img = num2str(img_index);
sz = num2str(img_sz);
scan_w = num2str(scan_window_sz);
scan = num2str(N_scan_w);
%
figura = semilogy(it,Vr2(:,1),'m-+','LineWidth',3,'MarkerSize',9);
hold on
semilogy(it,s(:,1),'b-s','LineWidth',2.5,'MarkerSize',9);
semilogy(it,Rr(:,1),'r-x','LineWidth',2.5,'MarkerSize',9);
%
legend('V','U','E')
hold off;
set(gca,'fontsize',18)
xlabel('Number of partial partitions','fontsize',23)
ylabel('Fraction of pixels','fontsize',23)
%
filename = strcat('V+BE+E-',type,'-rectang-scan','-Im',img,'-sz',sz,'-wsz-',scan_w,'.fig');
%
saveas(figura,filename);
clear figura;
% --------------------------------------------------------
%
%                 it = log2(it);
%                 figura = semilogy(it,Vr2(:,1),'m-+','LineWidth',1.2,'MarkerSize',7);
%                 hold on
% %
%                 semilogy(it,s(:,1),'b-s','LineWidth',1.2,'MarkerSize',7);
%                 semilogy(it,Rr(:,1),'r-x','LineWidth',1.2,'MarkerSize',7);
% %
%                 legend('Variability','Error bound in r','True error in r')
%                 hold off;
%                 xlabel('log2 of the number of partial partitions','fontsize',14)
%                 ylabel('Fraction of pixels','fontsize',14)
% %
%                 filename = strcat('V+BE+E-log2-',type,'-rectang-scan','-Im',img,'-sz',sz,'-wsz-',scan_w,'.fig');
% %
%                 saveas(figura,filename);
%                 clear figura;