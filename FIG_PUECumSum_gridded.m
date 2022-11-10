clc, clear

% Aesthetic 
fontSize_p = 10;
plot_dim_1 = [400,400,375,300];
plot_dim_3 = [200,200,275,200];

% Read in gif files
PUEfilepath = '..\OUTPUTS\PUE\PUE_2017.tif';
CUMSUMfilepath = '..\OUTPUTS\Cumulative Phosphorus\CumSum_2017.tif';
OUTPUTfilepath = '..\OUTPUTS\Figures\PUE_2017.tif';

% binscatter(x,y)
[PUE,~] = readgeoraster(PUEfilepath);
[CS,~] = readgeoraster(CUMSUMfilepath);

PUE = single(PUE)./1000;

% Vectorizin the data
PUE_v = PUE(:);
CS_v = CS(:);


%% Figure
close all
h = binscatter(CS_v,PUE_v,  'YLimits',[0,3], 'XLimits', [-500, 4000]);
caxis([ 3000]);
hold on
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,2000],[1,1],'--k','LineWidth',1)

ylim([0,3])
xlim([-500, 4000])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
ylabel('Phosphorus Use Efficiency')

%%
h = scatter(CS_v,PUE_v);
%caxis([ 3000]);
hold on
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,2000],[1,1],'--k','LineWidth',1)

ylim([0,3])
xlim([-500, 4000])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
ylabel('Phosphorus Use Efficiency')

