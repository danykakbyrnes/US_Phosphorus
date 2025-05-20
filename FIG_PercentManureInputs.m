clc, clear

%% Finding the distribution of dominant manure inputs (vs. tot fertilizer) 
% Filepaths
OUTPUTfilepath = '..\OUTPUTS\PUE_drivers\';
INPUTfilepath = '..\OUTPUTS\HUC2\';
trendINPUTfilepath = ['..\..\3_TREND_Nutrients\TREND_Nutrients\OUTPUT\',...
    'Grid_TREND_P_Version_1\TREND-P_Postpocessed_Gridded_2023-11-18\'];

% Figure aesthetics 
fontSize_p = 11;
fontSize_p2 = 8; 
plot_dim = [200,200,400,200];
plot_dim_2 = [200,200,400,425]; 

% Loading in the files
PUEfilepath = '..\OUTPUTS\PUE\PUE_2017.tif';

fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU\';
livestockFolder = 'Lvst_Agriculture_LU\';

[PUE2017,~] = readgeoraster(PUEfilepath);

[LVSTK2017,georef] = readgeoraster([trendINPUTfilepath,livestockFolder,...
                               'Lvst_2017.tif']);
Rinfo = geotiffinfo([trendINPUTfilepath,livestockFolder,...
                               'Lvst_2017.tif']);
[FERT2017,~] = readgeoraster([trendINPUTfilepath,fertilizerFolder,...
                              'Fertilizer_Ag_2017.tif']);

% Manipuating the data
PUE2017_v = double(PUE2017(:));
LVSTK2017_v = double(LVSTK2017(:));
FERT2017_v = double(FERT2017(:));

% Removing the cells with no data because of no agricultural land
DisnanIDX = (PUE2017_v == 0 | isnan(PUE2017_v));
PUE2017_v = PUE2017_v(DisnanIDX < 1, :);
LVSTK2017_v = LVSTK2017_v(DisnanIDX < 1, :);
FERT2017_v = FERT2017_v(DisnanIDX < 1, :);

% Removing the boxes that have no quadrant in 
D = [PUE2017_v, LVSTK2017_v, FERT2017_v,...
                      LVSTK2017_v./(FERT2017_v+LVSTK2017_v)];

% Regional data
PUE_AGHA = readmatrix([INPUTfilepath,'PUE_medianHUC2_fromgrid.txt']);
PCT_MANU = readmatrix([INPUTfilepath, 'PCT_Manure_In_medianHUC2_fromgrid.txt']);

% Isolate 2017
YEARS = 1930:2017;
PCT_MANU = PCT_MANU(:,[1, find(YEARS == 2017)+1]);
PCT_MANU(1,:) = [];
PCT_MANU = sortrows(PCT_MANU,'ascend');

PUE_AGHA = PUE_AGHA(:,[1, find(YEARS == 2017)+1]);
PUE_AGHA = sortrows(PUE_AGHA,'ascend');

% Insert a column in indexes that are sequential for 
% plotting and do not correspond to region numbers.
D_reg = [PUE_AGHA, PCT_MANU(:,2), [1:size(PUE_AGHA,1)]'];
regionID = {'9';'8';'7';'6';'5';...
    '4';'3';'2';'1'};

%% FIGURE X: PUE vs. % manure

% Color map
%colorMap = [15,37,30;
%            64, 150, 122;
%            255, 255, 255]./255;
colorMap = [96,96,96;
            175, 175, 175;
            255, 255, 255]./255;

map = interp1([0;50;100], colorMap,linspace(100,0,248),'pchip');

%% scatter plot version of gridded data
close all
I = sort(randperm(length(D),ceil(length(D)/100))'); 
D_ss = D(I,:);

scatter(D_ss(:,1), D_ss(:,4), 25,...
    'MarkerFaceColor', '#BABABA', ...
    'MarkerEdgeColor', '#BABABA', ...
    'MarkerFaceAlpha', 0.025,...
    'MarkerEdgeAlpha', 0.05)

hold on

% Adding regions
RegCol =  [228,26,28; % region 9
           55,126,184; % region 8
           77,175,74;
           152,78,163;
           255,127,0;
           255,255,51;
           166,86,40;
           247,129,191;
           195,243,227]./255; % region 1

xlabel('PUE (2017) [-]')
xlim([0,2])
ylim([0,1])
ylabel('Manure to Total Input Ratio (2017)')

% Adding regions
groups = D_reg(:,3);

% Plot each group separately
for i = 1:length(D_reg(:,3))
    idx = D_reg(:,4) == groups(i);
    
    % Create scatter plot for this group
    h = scatter(D_reg(i,2), D_reg(i,3), ...
         120,...
         'filled', ...
         'LineWidth', 1.5);
    hold on
    % Set face alpha and edge color
    h.MarkerFaceColor = RegCol(i,:);
    h.MarkerFaceAlpha = 0.95;
    h.MarkerEdgeColor = RegCol(i,:) * 0.8; % Darker version of same color
end

box on
set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

set(gcf,'position',plot_dim_2)

hold off;
set(gcf,'position',[200,200,400,400])
Figfolderpath = [OUTPUTfilepath,'manure_totalInput_scatterplot_withRegions.png'];
print('-dpng','-r600',[Figfolderpath])

%% Hex and bin plots
close all
clearvars FERT2017 FERT2017_v LVSTK2017 LVSTK2017_v PUE2017 PUE2017_v DisnanIDX D_ss
hexscatter(D(:,1), D(:,4), ...
           'res', [140,40],...
           'showZeros', 0)

xlabel('PUE (2017) [-]')
xlim([0,2])
ylim([0,1])
ylabel('Manure to Total Input Ratio (2017)')

% Line of best fit
coefficients = polyfit(D(:,1), D(:,4), 1);
y_fit = polyval(coefficients, [0.1,1.9]);
hold on
%plot([0.1,1.9], y_fit, ...
%    'k:', 'LineWidth',3);

colormap(map);
colorbar;
caxis([0, 8*10^4]);

box on
set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

set(gcf,'position',plot_dim_2)

Figfolderpath = [OUTPUTfilepath,'manure_totalInput_hexplot.png'];
print('-dpng','-r600',[Figfolderpath])

% Adding regions
groups = D_reg(:,3);

% Plot each group separately
for i = 1:length(D_reg(:,3))
    idx = D_reg(:,4) == groups(i);
    
    % Create scatter plot for this group
    h = scatter(D_reg(i,2), D_reg(i,3), ...
         120,...
         'filled', ...
         'LineWidth', 1.5);
    hold on
    % Set face alpha and edge color
    h.MarkerFaceColor = RegCol(i,:);
    h.MarkerFaceAlpha = 0.9;
    h.MarkerEdgeColor = RegCol(i,:) * 0.8; % Darker version of same color
end

xlim([0,2])

%hold off;
set(gcf,'position',[200,200,450,425])
Figfolderpath = [OUTPUTfilepath,'manure_totalInput_hexplot_withRegions_12-2.png'];
print('-dpng','-r600',[Figfolderpath])