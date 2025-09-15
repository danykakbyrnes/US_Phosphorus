clc, clear, close all

% ------------------------------------------------------------------------
% MAKING REGIONAL LOLLI PLOTS FOR FIGURE 2, FIGURE 5, AND FIGURE 7.
% ------------------------------------------------------------------------

% Filepaths
loadenv(".env")
INPUT_filepath = getenv('REGIONAL_ANALYSIS');
OUTPUT_filepath = getenv('REGIONAL_FIGURES');
mkdir(OUTPUT_filepath)

%% Aesthetics
YEARS = 1930:2017;
fontSize_p = 10;
plot_dim = [100,100,350,400];
plot_dim_small = [100,100,275,325];

%% Reading in regional data
PUE_AGHA = readmatrix([INPUT_filepath, 'PUE_medianRegion.txt']);
AGS_AGHA = readmatrix([INPUT_filepath, 'Ag_Surplus_medianRegion.txt']);

% Isolate 1980 and 2017
idx_1930 = find(YEARS == 1930);
idx_1980 = find(YEARS == 1980);
idx_2017 = find(YEARS == 2017);

PUE_AGHA_TS = PUE_AGHA ;
PUE_AGHA = PUE_AGHA(:,[1, idx_1980+1, idx_2017+1]);
PUE_AGHA = sortrows(PUE_AGHA,'descend');

AGS_AGHA = AGS_AGHA(:,[1, idx_1930+1, idx_1980+1, idx_2017+1]);
AGS_AGHA = sortrows(AGS_AGHA, 1, 'descend');

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

Figfolderpath = [OUTPUT_filepath,'HUC_median_PUE_LolliChart.png'];
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

Figfolderpath = [OUTPUT_filepath,'HUC_median_Surplus_LolliChart.png'];
print('-dpng','-r600', Figfolderpath)

%% Cumulative surplus lolli chart
fontSize_p = 10;

% Plotting regional cumulative surplus lolli chart
SURPcumu_AGHA = readmatrix([INPUT_filepath, 'CumuSum_medianRegion.txt']);
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

Figfolderpath = [OUTPUT_filepath,'HUC_median_cumuSurplus_LolliChart.png'];
print('-dpng','-r600',[Figfolderpath])