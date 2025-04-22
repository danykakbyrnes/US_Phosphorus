%% Agricultural surplus and PUE regional figures
clc, clear, close all

% First start by calculating national cumsum
OUTPUT_folderName = '../OUTPUTS/HUC2/';

YEARS = 1930:2017;
fontSize_p = 10;
plot_dim_1 = [100,100,350,400];
plot_dim_2 = [100,100,275,325];
plot_dim_3 = [100,100,450,400];

% Now getting the regional values
PUE_AGHA = readmatrix([OUTPUT_folderName, 'PUE_medianHUC2_fromgrid.txt']);

AGS_AGHA = readmatrix([OUTPUT_folderName, 'Ag_Surplus_medianHUC2Components.txt']);

% Isolate 1980 and 2017
idx_1930 = find(YEARS == 1930);
idx_1980 = find(YEARS == 1980);
idx_2017 = find(YEARS == 2017);

PUE_AGHA_TS = PUE_AGHA ;
PUE_AGHA = PUE_AGHA(:,[1, idx_1980+1, idx_2017+1]);
PUE_AGHA = sortrows(PUE_AGHA,'ascend');


AGS_AGHA_TS = AGS_AGHA;
AGS_AGHA = AGS_AGHA(:,[1, idx_1930+1, idx_1980+1, idx_2017+1]);
AGS_AGHA = sortrows(AGS_AGHA, 1, 'ascend');
AGS_AGHA_TS = sortrows(AGS_AGHA_TS, 1, 'descend');

% Insert a column in indexes that are sequential of region numbers.
PUE_AGHA = [PUE_AGHA, [1:size(PUE_AGHA,1)]'];
AGS_AGHA = [AGS_AGHA, [1:size(AGS_AGHA,1)]'];
regionID = {'9';'8';'7';'6';'5';...
    '4';'3';'2';'1'};

%% Plotting PUE lollichart
% Plot a line at PUE = 1
plot([1,1], [0,10], ':', 'Color','#ABABAB', 'LineWidth',1)

% Plotting a scatter plot with lines in the middle
hold on
for i = 1:length(PUE_AGHA(:,3))
   plot(PUE_AGHA(i,[2,3]), [i,i], 'Color','#E8EAEB', 'LineWidth',8)
end

scatter(PUE_AGHA(:,2), PUE_AGHA(:,end), 70, ...
    [254,196,79]./255,'filled', 'MarkerEdgeColor', [236,112,20]./255)
hold on 
scatter(PUE_AGHA(:,3), PUE_AGHA(:,end), 70, ...
    [204,76,2]./255, 'filled', 'MarkerEdgeColor',[140,45,4]./255)

% Adjusting axies
ylim([0.5, 9.5])
xlim([0.29, 1.25])
xlabel('PUE [-]')

a = gca;
set(a,'yticklabel', regionID)
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

Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_median_PUE_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])

%% Plotting Surplus lineplots
figure(2)

smoothing_int = [5 5];

for i = 1:size(AGS_AGHA_TS,1)
    subplot(3,3,i)
    plot(YEARS, movmeanAGS, '-', 'LineWidth',2.5, 'Color', '#0868AC') 
    hold on
    plot(YEARS, movmeanAGS, '-', 'LineWidth', 1, 'Color', '#43A2CA') 
    
    set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3, ...
        {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
        {'k','k','k'});
    set(gca,'XColor',[0,0,0])
    set(gca,'YColor',[0,0,0])
    set(gca,'ZColor',[0,0,0])
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca,'TickLength',[0.03, 0])
    ylim([-5,15])

    if i == 1 | i == 4 | i == 7
        yticks([-5, 0, 5, 10, 15])
    else
        yticks([])
    end
end

set(gcf, 'Position',plot_dim_3)
Figfolderpath =  [OUTPUT_folderName,'HUCFigures/HUC_median_Surplus_Timeseries.png'];
print('-dpng','-r600',[Figfolderpath])


%% Plotting surplus lollichart
% Plotting a scatter plot with lines a zero
figure(3)
plot([0,0], [0,10], ':', 'Color','#ABABAB', 'LineWidth',1)

hold on
for i = 1:length(AGS_AGHA(:,3))
   plot(AGS_AGHA(i,2:4), [i,i,i], 'Color','#E8EAEB', 'LineWidth',8)
end

% 1930
scatter(AGS_AGHA(:,2), AGS_AGHA(:,end), 70, ...
    [204, 249, 232]./255,'filled', 'MarkerEdgeColor', [110, 159, 141]./255)
hold on 
% 1980
scatter(AGS_AGHA(:,3), AGS_AGHA(:,end), 70, ...
    [123, 204, 196]./255, 'filled', 'MarkerEdgeColor', [83, 140, 135]./255)
% 2017
scatter(AGS_AGHA(:,4), AGS_AGHA(:,end), 70, ...
    [67, 162, 202]./255,'filled', 'MarkerEdgeColor', [8, 104, 172]./255)

% Adjusting axies
ylim([0.5, 9.5])
%xlim([0.29, 1.25])
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
box on
set(gcf, 'Position',plot_dim_1)

Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_median_Surplus_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])

%% Plotting surplus bar chart
figure(4)
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

%% Fertilizer regional figures
% Now getting the regional values
FERT_AGHA = readmatrix([OUTPUT_folderName, 'Fert_medianHUC2Components.txt']);
% Isolate 1930, 1980 and 2017
idx_1930 = find(YEARS == 1930);
idx_1980 = find(YEARS == 1980);
idx_2017 = find(YEARS == 2017);

FERT_AGHA = FERT_AGHA(:,[1, idx_1930+1, idx_1980+1, idx_2017+1]);
FERT_AGHA = sortrows(FERT_AGHA,'ascend');

% Insert a column in indexes that are sequential of region numbers.
FERT_AGHA = [FERT_AGHA, [1:size(FERT_AGHA,1)]'];

% Plotting fertilizer lollichart
figure(5)

for i = 1:length(FERT_AGHA(:,3))
    plot(FERT_AGHA(i,2:4), [i,i,i], 'Color','#E8EAEB', 'LineWidth',8)
    hold on
end
% 1930
scatter(FERT_AGHA(:,2), FERT_AGHA(:,end), 70, ...
    [254,224,210]./255,'filled', 'MarkerEdgeColor', 0.5*[254,224,210]./255)
hold on
% 1980
scatter(FERT_AGHA(:,3), FERT_AGHA(:,end), 70, ...
    [251,106,74]./255, 'filled', 'MarkerEdgeColor', 0.5*[251,106,74]./255)
% 2017
scatter(FERT_AGHA(:,4), FERT_AGHA(:,end), 70, ...
    [165,15,21]./255,'filled', 'MarkerEdgeColor', 0.5*[165,15,21]./255)

% Adjusting axes
ylim([0.5, 9.5])
xlim([0, 25])
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
box on
set(gcf, 'Position',plot_dim_2)
Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_median_Fert_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])

%% Livestock regional figures
% Now getting the regional values
LVSK_AGHA = readmatrix([OUTPUT_folderName, 'Lvsk_medianHUC2Components.txt']);
% Isolate 1930, 1980 and 2017
LVSK_AGHA = LVSK_AGHA(:,[1, idx_1930+1, idx_1980+1, idx_2017+1]);
LVSK_AGHA = sortrows(LVSK_AGHA,'ascend');
% Insert a column in indexes that are sequential of region numbers.
LVSK_AGHA = [LVSK_AGHA, [1:size(LVSK_AGHA,1)]'];

% Plotting livestock lollichart
figure(6)

for i = 1:length(LVSK_AGHA(:,3))
    plot(LVSK_AGHA(i,2:4), [i,i,i], 'Color','#E8EAEB', 'LineWidth',8)
    hold on
end
% 1930
scatter(LVSK_AGHA(:,2), LVSK_AGHA(:,end), 70, ...
    [239,237,245]./255,'filled', 'MarkerEdgeColor', 0.5*[239,237,245]./255)
hold on
% 1980
scatter(LVSK_AGHA(:,3), LVSK_AGHA(:,end), 70, ...
    [158,154,200]./255, 'filled', 'MarkerEdgeColor', 0.5*[158,154,200]./255)
% 2017
scatter(LVSK_AGHA(:,4), LVSK_AGHA(:,end), 70, ...
    [84,39,143]./255,'filled', 'MarkerEdgeColor', 0.5*[84,39,143]./255)

% Adjusting axes
ylim([0.5, 9.5])
xlim([0, 25])
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
box on
set(gcf, 'Position',plot_dim_2)
Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_median_Lvsk_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])

%% Crop regional figures
% Now getting the regional values
CROP_AGHA = readmatrix([OUTPUT_folderName, 'Crop_medianHUC2Components.txt']);
% Isolate 1930, 1980 and 2017
CROP_AGHA = CROP_AGHA(:,[1, idx_1930+1, idx_1980+1, idx_2017+1]);
CROP_AGHA = sortrows(CROP_AGHA,'ascend');
% Insert a column in indexes that are sequential of region numbers.
CROP_AGHA = [CROP_AGHA, [1:size(CROP_AGHA,1)]'];

% Plotting livestock lollichart
figure(6)
hold on
for i = 1:length(CROP_AGHA(:,3))
    plot(CROP_AGHA(i,2:4), [i,i,i], 'Color','#E8EAEB', 'LineWidth',8)
end
% 1930
scatter(CROP_AGHA(:,2), CROP_AGHA(:,end), 70, ...
    [229,245,224]./255,'filled', 'MarkerEdgeColor', 0.5*[229,245,224]./255)
hold on
% 1980
scatter(CROP_AGHA(:,3), CROP_AGHA(:,end), 70, ...
    [65,171,93]./255, 'filled', 'MarkerEdgeColor', 0.5*[65,171,93]./255)
% 2017
scatter(CROP_AGHA(:,4), CROP_AGHA(:,end), 70, ...
    [0,109,44]./255,'filled', 'MarkerEdgeColor', 0.5*[0,109,44]./255)

% Adjusting axes
ylim([0.5, 9.5])
xlim([0, 25])
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
box on
set(gcf, 'Position',plot_dim_2)
Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_median_Crop_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])

%% Percent Manure of total inputs regional figures
% Now getting the regional values
PCT_MANU = readmatrix([OUTPUT_folderName, 'PCT_Manure_In_medianHUC2_fromgrid.txt']);
PCT_MANU = PCT_MANU(:,[1, idx_1930+1, idx_1980+1, idx_2017+1]);
PCT_MANU(1,:) = [];
PCT_MANU = sortrows(PCT_MANU,'ascend');

% Insert a column in indexes that are sequential of region numbers.
PCT_MANU = [PCT_MANU, [1:size(PCT_MANU,1)]'];

% Plotting livestock lollichart
figure(7)

for i = 1:length(PCT_MANU(:,3))
    plot(PCT_MANU(i,2:4), [i,i,i], 'Color','#E8EAEB', 'LineWidth',8)
    hold on
end
% 1930
scatter(PCT_MANU(:,2), PCT_MANU(:,end), 70, ...
    [255,247,188]./255,'filled', 'MarkerEdgeColor', 0.5*[255,247,188]./255)
hold on
% 1980
scatter(PCT_MANU(:,3), PCT_MANU(:,end), 70, ...
    [254,196,79]./255, 'filled', 'MarkerEdgeColor', 0.5*[254,196,79]./255)
% 2017
scatter(PCT_MANU(:,4), PCT_MANU(:,end), 70, ...
    [217,95,14]./255,'filled', 'MarkerEdgeColor', 0.5*[217,95,14]./255)

% Adjusting axes
ylim([0.5, 9.5])
xlim([0, 1])
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
set(gcf, 'Position',plot_dim_2)
Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_median_Pct_Manure_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])