%% Agricultural surplus and PUE regional figures
clc, clear, close all

% First start by calculating national cumsum
OUTPUT_folderName = '../OUTPUTS/HUC2/';

YEARS = 1930:2017;
fontSize_p = 10;
plot_dim_1 = [100,100,350,400];

% Now getting the regional values
PUE_AGHA = readmatrix([OUTPUT_folderName, 'PUE_medianHUC2_fromgrid.txt']);

AGS_AGHA = readmatrix([OUTPUT_folderName, 'Ag_Surplus_medianHUC2Components.txt']);

% Isolate 1980 and 2017
idx_1930 = find(YEARS == 1930);
idx_1980 = find(YEARS == 1980);
idx_2017 = find(YEARS == 2017);

PUE_AGHA = PUE_AGHA(:,[1, idx_1980, idx_2017]);
PUE_AGHA = sortrows(PUE_AGHA,'ascend');

AGS_AGHA = AGS_AGHA(:,[1, idx_1930, idx_1980, idx_2017]);
AGS_AGHA = sortrows(AGS_AGHA,'ascend');

% Insert a column in indexes that are sequential, for plotting purposes. 
PUE_AGHA = [PUE_AGHA, [1:size(PUE_AGHA,1)]'];
AGS_AGHA = [AGS_AGHA, [1:size(AGS_AGHA,1)]'];
regionID = {'9';'8';'7';'6';'5';...
    '4';'3';'2';'1'};

%% Plotting PUE figure
% Plot a line at PUE = 1
plot([1,1], [0,10], ':', 'Color','#ABABAB', 'LineWidth',1)

% Plotting a scatter plot with lines in the middle
hold on
for i = 1:length(PUE_AGHA(:,3))
   plot(PUE_AGHA(10-i,2:3), [i,i], 'Color','#E8EAEB', 'LineWidth',8)
end

% Calculate IQR for 1980 and 2017

scatter(PUE_AGHA(:,2), 10-PUE_AGHA(:,end), 70, ...
    [47, 133, 181]./255,'filled', 'MarkerEdgeColor', [13,79,116]./255)
hold on 
scatter(PUE_AGHA(:,3), 10-PUE_AGHA(:,end), 70, ...
    [27, 146, 155]./255, 'filled', 'MarkerEdgeColor',[13, 78, 83]./255)

% Adjusting axies
ylim([0.5, 9.5])
xlim([0.29, 1.25])
xlabel('[-]')

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
box on
set(gcf, 'Position',plot_dim_1)

Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_PUE_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])

%% Plotting surplus figure
figure(2)
h = barh(AGS_AGHA(:,end), AGS_AGHA(:,2:4)', 0.95);
h(1).FaceColor = '#bdc9e1';
h(2).FaceColor = '#79A6BF';
h(3).FaceColor = '#428186';

h(1).EdgeColor = '#738CBF'  ;
h(2).EdgeColor = '#4E86A6';
h(3).EdgeColor = '#386E72';

% Adjusting axies
xlim([-3, 25])
xlabel('kg-P ha^-^1 yr^-^1')
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

Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_SURP_BarChart.png'];
print('-dpng','-r600',[Figfolderpath])