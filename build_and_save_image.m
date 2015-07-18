function build_and_save_image(P,R,r,uni,img_index,img_sz,scan_window_sz,N_scan_w,type)

P_sub = P(uni);
R_sub = R(uni);
r_sub = r(uni);
%
img = num2str(img_index);
sz = num2str(img_sz);
scan_w = num2str(scan_window_sz);
scan = num2str(N_scan_w);
%                     %
z = reshape(R_sub,sqrt(size(P_sub,1)),sqrt(size(P_sub,1)));
figure;z=imshow(z,[min(z(:)) max(z(:))]);
filename = strcat('xls-',type,'-image','-Im',img,'-sz',sz,'-scan',scan,'-wsz-',scan_w,'.fig');
saveas(z,filename);
clear z;
%
z = reshape(P_sub-R_sub,sqrt(size(P_sub,1)),sqrt(size(P_sub,1)));
figure;z=imshow(z,[min(z(:)) max(z(:))]);
filename = strcat('P-xls-',type,'-image','-Im',img,'-sz',sz,'-scan',scan,'-wsz-',scan_w,'.fig');
saveas(z,filename);
clear z;
%-----------------------------
z = reshape(r_sub,sqrt(size(P_sub,1)),sqrt(size(P_sub,1)));
figure;z=imshow(z,[min(z(:)) max(z(:))]);
filename = strcat('r-',type,'-image','-Im',img,'-sz',sz,'-scan',scan,'-wsz-',scan_w,'.fig');
saveas(z,filename);
clear z;
%
z = reshape(P_sub-r_sub,sqrt(size(P_sub,1)),sqrt(size(P_sub,1)));
figure;z=imshow(z,[min(z(:)) max(z(:))]);
filename = strcat('P-r-',type,'-image','-Im',img,'-sz',sz,'-scan',scan,'-wsz-',scan_w,'.fig');
saveas(z,filename);
clear z;