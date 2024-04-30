clc, clear all%, close all

%% Folders and files
filepathPSurplus = ['..\..\3_TREND_Nutrients\TREND_Nutrients\OUTPUT\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded (2023-11-18)\',...
    'Surplus_P\Surplus_P_2017.tif'];
filepathPUE = '..\OUTPUTS\PUE\PUE_2017.tif';

%% Conceptual figure, panel b
 [PS,~] = readgeoraster(filepathPSurplus);
 [PUE,~]= readgeoraster(filepathPUE);

PS =  PS(:);
PUE =  PUE(:);

% subset 10%
scatter(PS, PUE,'o','filled','k')
close all
%% Supplemental Plots
% plot y = b*(1-x) where b = 10, 100
figure(1)

b = [2,10,50,100];

fp = fplot(@(x) b.*(1-x),'LineWidth',2);
xlim([0,1])
ylim([0,100])

legend({'input (kg-P/ha) = 2', 'input (kg-P/ha) = 10', 'input (kg-P/ha) = 50', 'input (kg-P/ha) = 100'})

xlabel('Phosphorus Use Efficiency')
ylabel('P Surplus (kg-P ha^-^1)')

set(gca,'FontSize',14)


figure(2)

b = [2,10,50,100];

fp = fplot(@(x) b.*(1/x - 1),'LineWidth',2);
xlim([0,1])
ylim([0,100])

legend({'CU (kg-P/ha) = 2', 'CU (kg-P/ha) = 10', 'CU (kg-P/ha) = 50', 'CU (kg-P/ha) = 100'})

xlabel('Phosphorus Use Efficiency')
ylabel('P Surplus (kg-P ha^-^1)')

set(gca,'FontSize',14)