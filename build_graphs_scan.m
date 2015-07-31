function build_graphs_scan(it, V, U, Pr)
% Build three graphs
%
%--------------------------------------------------------------------------
%
semilogy(it,V(:,1),'m-+','LineWidth',2,'MarkerSize',8);
hold on
semilogy(it,U(:,1),'b-s','LineWidth',2,'MarkerSize',8);
semilogy(it,Pr(:,1),'r-x','LineWidth',2,'MarkerSize',8);
%
legend('EB1','EB2','Pr')
hold off;
set(gca,'fontsize',15)
xlabel('Number of partial partitions','fontsize',20)
ylabel('Fraction of pixels','fontsize',20)
title('Error bounds on reconstructions from lower resolution scanner','fontsize',12)
%