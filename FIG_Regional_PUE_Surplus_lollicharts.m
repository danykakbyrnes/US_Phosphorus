clc, clear, close all

% ------------------------------------------------------------------------
% MAKING REGIONAL LOLLI PLOTS FOR FIGURE 2, FIGURE 5, AND FIGURE 7.
% ------------------------------------------------------------------------

% Filepaths
loadenv(".env")
OUTPUT_folderName = getenv('REGIONAL_ANALYSIS');
CUMSUM_folderName = getenv('CUMULATIVE_PHOS');

%% Aesthetics
YEARS = 1930:2017;
fontSize_p = 10;
plot_dim = [100,100,350,400];
plot_dim_small = [100,100,275,325];

%% Reading in regional data
PUE_AGHA = readmatrix([OUTPUT_folderName, 'PUE_medianHUC2_fromgrid.txt']);
AGS_AGHA = readmatrix([OUTPUT_folderName, 'Ag_Surplus_medianHUC2Components.txt']);

% Isolate 1980 and 2017
idx_1930 = find(YEARS == 1930);
idx_1980 = find(YEARS == 1980);
idx_2017 = find(YEARS == 2017);

PUE_AGHA_TS = PUE_AGHA ;
PUE_AGHA = PUE_AGHA(:,[1, idx_1980+1, idx_2017+1]);
PUE_AGHA = sortrows(PUE_AGHA,'ascend');

AGS_AGHA = AGS_AGHA(:,[1, idx_1930+1, idx_1980+1, idx_2017+1]);
AGS_AGHA = sortrows(AGS_AGHA, 1, 'ascend');

% Insert a column in indexes that are sequential of region numbers.
PUE_AGHA = [PUE_AGHA, [1:size(PUE_AGHA,1)]'];
AGS_AGHA = [AGS_AGHA, [1:size(AGS_AGHA,1)]'];
regionID = {'9';'8';'7';'6';'5';...
    '4';'3';'2';'1'};

%% Plotting PUE lollichart
% Plot a line at PUE = 1
figure(1)
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
set(gcf, 'Position',plot_dim_small)

Figfolderpath = [OUTPUT_folderName,'Regional_Figures/HUC_median_PUE_LolliChart.png'];
print('-dpng','-r600', Figfolderpath)

%% Plotting surplus lollichart
% Plotting a scatter plot with lines a zero
figure(2)
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
xlabel('kg-P ha^-^1 y^-^1')

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
set(gcf, 'Position',plot_dim)

Figfolderpath = [OUTPUT_folderName,'Regional_Figures/HUC_median_Surplus_LolliChart.png'];
print('-dpng','-r600', Figfolderpath)

%% Plotting proportion of manure-derived P inputs regional lolli chart
Prop_MANUIN = readmatrix([OUTPUT_folderName, 'PCT_Manure_In_medianHUC2_fromgrid.txt']);
Prop_MANUIN = Prop_MANUIN(:,[1, idx_1930+1, idx_1980+1, idx_2017+1]);
Prop_MANUIN(1,:) = [];
Prop_MANUIN = sortrows(Prop_MANUIN,'ascend');

% Insert a column in indexes that are sequential of region numbers.
Prop_MANUIN = [Prop_MANUIN, [1:size(Prop_MANUIN,1)]'];

% Plotting % manure of total inputs lollichart
figure(3)

for i = 1:length(Prop_MANUIN(:,3))
    plot(Prop_MANUIN(i,2:4), [i,i,i], 'Color','#E8EAEB', 'LineWidth',8)
    hold on
end
% 1930
scatter(Prop_MANUIN(:,2), Prop_MANUIN(:,end), 70, ...
    [255,247,188]./255,'filled', 'MarkerEdgeColor', 0.5*[255,247,188]./255)
hold on
% 1980
scatter(Prop_MANUIN(:,3), Prop_MANUIN(:,end), 70, ...
    [254,196,79]./255, 'filled', 'MarkerEdgeColor', 0.5*[254,196,79]./255)
% 2017
scatter(Prop_MANUIN(:,4), Prop_MANUIN(:,end), 70, ...
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
Figfolderpath = [OUTPUT_folderName,'Regional_Figures/HUC_median_Pct_Manure_LolliChart.png'];

%% Cumulative surplus lolli chart
fontSize_p = 10;

% Plotting regional cumulative surplus lolli chart
SURPcumu_AGHA = readmatrix([OUTPUT_folderName, 'CumSum_medianHUC2_fromgrid.txt']);
SURPcumu_AGHA = sortrows(SURPcumu_AGHA, 'descend');
SURPcumu_AGHA = [SURPcumu_AGHA, [1:size(SURPcumu_AGHA,1)]'];

% Isolate 1980 and 2017
idx_1980 = find(YEARS == 1980);
idx_2017 = find(YEARS == 2017);

% Plotting a scatter plot with lines a zero
figure(4)
plot([0,0], [0,10], ':', 'Color','#ABABAB', 'LineWidth',1)

hold on
for i = 1:length(SURPcumu_AGHA(:,3))
   plot(SURPcumu_AGHA(i,2:3), [i,i], 'Color','#E8EAEB', 'LineWidth',8)
end

% 1980
scatter(SURPcumu_AGHA(:,2), SURPcumu_AGHA(:,end), 70, ...
    [123, 204, 196]./255, 'filled', 'MarkerEdgeColor', [83, 140, 135]./255)
% 2017
scatter(SURPcumu_AGHA(:,3), SURPcumu_AGHA(:,end), 70, ...
    [67, 162, 202]./255,'filled', 'MarkerEdgeColor', [8, 104, 172]./255)

% Adjusting axies
ylim([0.5, 9.5])
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
box on
set(gcf, 'Position',plot_dim)

Figfolderpath = [OUTPUT_folderName,'Regional_Figures/HUC_median_cumuSurplus_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])