%% Cumulative Surplus timeseries summary figures
clc, clear, close all

% First start by calculating national cumsum
OUTPUT_folderName = '../OUTPUTS/HUC2/';
CUMSUMfilepath = '..\OUTPUTS\Cumulative_Phosphorus\';

YEARS = 1930:2017;
fontSize_p = 10;
plot_dim_1 = [100,100,330, 400];

regionID_1 = {'9';'8';'7';'6';'5';...
    '4';'3';'2';'1';'National'};
regionID_2 = {'9';'8';'7';'6';'5';...
    '4';'3';'2';'1'};

% Getting raster information
[CS2017,~] = readgeoraster([CUMSUMfilepath,'CumSum_2017.tif']);
[CS1980,~] = readgeoraster([CUMSUMfilepath,'CumSum_1980.tif']);
csNatMean_2017 = nanmean(CS2017(:));
csNatMean_1980 = nanmean(CS1980(:));

clearvars CS2017 CS1980

% Now getting the regional values
SURPcumu_AGHA = readmatrix([OUTPUT_folderName, 'CumSum_meanHUC2_fromgrid.txt']);

medSURPcumu_AGHA = readmatrix([OUTPUT_folderName, 'CumSum_medianHUC2_fromgrid.txt']);
medSURPcumu_AGHA = medSURPcumu_AGHA(2:end, :);
medSURPcumu_AGHA = sortrows(medSURPcumu_AGHA,'ascend');
medSURPcumu_AGHA = [medSURPcumu_AGHA, [1:size(medSURPcumu_AGHA,1)]'];

% Isolate 1980 and 2017
idx_1980 = find(YEARS == 1980);
idx_2017 = find(YEARS == 2017);

SURPcumu_AGHA = SURPcumu_AGHA(:,[1, idx_1980+1, idx_2017+1]);
SURPcumu_AGHA = sortrows(SURPcumu_AGHA,'ascend');

% Insert national data
SURPcumu_AGHA = [SURPcumu_AGHA; 99, csNatMean_1980, csNatMean_2017];

% Insert a column in sequential indexes for plotting order. 
SURPcumu_AGHA = [SURPcumu_AGHA, [1:size(SURPcumu_AGHA,1)]'];

h = barh(SURPcumu_AGHA(:,end), SURPcumu_AGHA(:,2:3)', 0.95);
h(1).FaceColor = '#79A6BF';
h(2).FaceColor = '#428186';

h(1).EdgeColor = '#4E86A6';
h(2).EdgeColor = '#386E72';

% Adjusting axies
xlim([-50, 600])
xlabel('kg-P ha^-^1')
a = gca;
set(a,'yticklabel',regionID_1)
set(a,'XMinorTick','on','YMinorTick','off')
set(a,'TickLength',[0.015, 0])
set(a,'FontSize',fontSize_p, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(a,'XColor',[0,0,0])
set(a,'YColor',[0,0,0])
set(a,'ZColor',[0,0,0])

set(gcf, 'Position',plot_dim_1)

Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_SURPcumu_BarChart.png'];
print('-dpng','-r600',[Figfolderpath])

%% Plotting surplus lollichart
% Plotting a scatter plot with lines a zero
figure(2)
plot([0,0], [0,10], ':', 'Color','#ABABAB', 'LineWidth',1)

hold on
for i = 1:length(medSURPcumu_AGHA(:,3))
   plot(medSURPcumu_AGHA(i,2:3), [i,i], 'Color','#E8EAEB', 'LineWidth',8)
end

% 1980
scatter(medSURPcumu_AGHA(:,2), medSURPcumu_AGHA(:,end), 70, ...
    [123, 204, 196]./255, 'filled', 'MarkerEdgeColor', [83, 140, 135]./255)
% 2017
scatter(medSURPcumu_AGHA(:,3), medSURPcumu_AGHA(:,end), 70, ...
    [67, 162, 202]./255,'filled', 'MarkerEdgeColor', [8, 104, 172]./255)

% Adjusting axies
ylim([0.5, 9.5])
%xlim([0.29, 1.25])
xlabel('kg-P ha^-^1')

a = gca;
set(a,'yticklabel',regionID_2)
set(a,'XMinorTick','on','YMinorTick','off')
set(a,'TickLength',[0.015, 0])
set(a,'FontSize',fontSize_p, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(a,'XColor',[0,0,0])
set(a,'YColor',[0,0,0])
set(a,'ZColor',[0,0,0])
box on
set(gcf, 'Position',plot_dim_1)

Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_median_cumuSurplus_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])