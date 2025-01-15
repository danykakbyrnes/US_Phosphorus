%% Cumulative Surplus timeseries summary figures
clc, clear, close all

% First start by calculating national cumsum
OUTPUT_folderName = '../OUTPUTS/HUC2/';
CUMSUMfilepath = '..\OUTPUTS\Cumulative_Phosphorus\';

YEARS = 1930:2017;
fontSize_p = 10;
plot_dim_1 = [100,100,330, 400];

% Getting raster information
[CS2017,~] = readgeoraster([CUMSUMfilepath,'CumSum_2017.tif']);
[CS1980,~] = readgeoraster([CUMSUMfilepath,'CumSum_1980.tif']);
csNatMean_2017 = nanmean(CS2017(:));
csNatMean_1980 = nanmean(CS1980(:));

clearvars CS2017 CS1980

% Now getting the regional values
SURPcumu_AGHA = readmatrix([OUTPUT_folderName, 'CumSum_meanHUC2_fromgrid.txt']);
SURPcumu_AGHA = sortrows(SURPcumu_AGHA,'descend');

% Isolate 1980 and 2017
idx_1980 = find(YEARS == 1980);
idx_2017 = find(YEARS == 2017);

SURPcumu_AGHA = SURPcumu_AGHA(:,[1, idx_1980, idx_2017]);
%SURPcumu_AGHA = SURPcumu_AGHA(Regions_idx,:);
SURPcumu_AGHA = sortrows(SURPcumu_AGHA,'ascend');

% Insert national data
SURPcumu_AGHA = [SURPcumu_AGHA; 99, csNatMean_1980, csNatMean_2017];

% Insert a column in indexes that are sequential, for plotting purposes. 
SURPcumu_AGHA = [SURPcumu_AGHA, [1:size(SURPcumu_AGHA,1)]'];
regionID = {'Region 9';'Region 8';'Region 7';'Region 6';'Region 5';...
    'Region 4';'Region 3';'Region 2';'Region 1';'National'};
%regionID = {'Region 7';'Region 6';'Region 4'; 'National'};

h = barh(SURPcumu_AGHA(:,end), SURPcumu_AGHA(:,2:3)', 0.95);
h(1).FaceColor = '#79A6BF';
h(2).FaceColor = '#428186';

h(1).EdgeColor = '#4E86A6';
h(2).EdgeColor = '#386E72';

% Adjusting axies
xlim([-50, 600])
xlabel('kg-P ha^-^1')
a = gca;
set(a,'yticklabel',regionID)
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