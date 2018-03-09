%BunnySim

clear all
close all
G = gsp_bunny();

G2=G;

N_S=1000;

SubSet=linspace(0,1,N_S).^2;
SubSetR=floor(SubSet*(G2.N-1))+1;
SubSetR=unique(SubSetR);
N_S=length(SubSetR);
G2.N=N_S;
G2.coords=G2.coords(SubSetR,:);

gsp_plot_graph(G2);
figure
scatter3(G2.coords(:,3),G2.coords(:,1),G2.coords(:,2),20,SubSetR,'filled');
sigma_n=0.02*mean(std(G2.coords));
sugar_gen_points=sugar(G2.coords,'equalizeF',1,'sigma_n',sigma_n);

Zf=[G2.coords;sugar_gen_points]';
Classes=[ones(1,size(G2.coords,1)),2*ones(1,size(sugar_gen_points,1))];
figure
scatter3(Zf(3,:), Zf(1,:),Zf(2,:),10,Classes);