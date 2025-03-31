clc, clear, close all

%% Aesthetic 
fontSize_p = 10;
fontSize_p2 = 12; 
plot_dim_1 = [400,400,400,350];

% Regional Color schemes
RegCol =  [228,26,28;
55,126,184;
77,175,74;
152,78,163;
255,127,0;
255,255,51;
166,86,40;
247,129,191;
195,243,227]./255;

mSize = 10; 

%% Figure to explore the failures of PUE as a metric
PUE_AGHA = readmatrix('..\OUTPUTS\HUC2\PUE_medianHUC2_fromgrid.txt');
AGS_AGHA = readmatrix('..\OUTPUTS\HUC2\Ag_Surplus_medianHUC2Components.txt');

% Importing the gridded data
[SURP,~] = readgeoraster('B:\LabFiles\users\DanykaByrnes\3_TREND_Nutrients\TREND_Nutrients\OUTPUT\Grid_TREND_P_Version_1\TREND-P_Postpocessed_Gridded_2023-11-18\Ag_Surplus\AgSurplus_2017.tif');
[PUE,~] = readgeoraster('..\OUTPUTS\PUE\PUE_2017.tif');

% Making the grid cells the same between 1980 and 2017
nanMask = isnan(PUE) | isnan(SURP);

% Apply the mask to all rasters at once
PUE(nanMask) = [];
SURP(nanMask) = [];

SURP = SURP(:);
PUE = PUE(:);

% Subset 1% of datapoints
I = sort(randperm(length(SURP), ceil(length(SURP)/100))'); 
SURP = SURP(I,:);
PUE = PUE(I,:);

figure(1)
% Plotting the middle lines to section off the negative and positive
% surplus
plot([-200,1000], [0, 0],'k:')
hold on
plot([0,0], [0, 2],'k:')

% Plot 1% of gridded data points 
scatter(SURP, PUE, 15,'filled', ...
    'MarkerFaceAlpha', 0.2, ...
    'MarkerFaceColor',[0.8,0.8,0.8], ...
    'MarkerEdgeColor',[0.7, 0.7, 0.7])

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

% Adding regional medians to scatter plot of P surplus vs. PUE
YEARS = 1930:2017;
idx_2017 = find(YEARS == 2017);

PUE_AGHA = PUE_AGHA(:,[1, idx_2017+1]);
PUE_AGHA = sortrows(PUE_AGHA,'descend');

AGS_AGHA = AGS_AGHA(:,[1, idx_2017+1]);
AGS_AGHA = sortrows(AGS_AGHA,'descend');

% Insert a column in indexes that are sequential of region numbers.
PUE_AGHA = [PUE_AGHA, [1:size(PUE_AGHA,1)]'];
AGS_AGHA = [AGS_AGHA, [1:size(AGS_AGHA,1)]'];
regionID = {'9';'8';'7';'6';'5';...
    '4';'3';'2';'1'};

groups = PUE_AGHA(:,3);

% Plot each group separately
for i = 1:length(PUE_AGHA(:,3))
    idx = PUE_AGHA(:,3) == groups(i);
    
    % Create scatter plot for this group
    h = scatter(AGS_AGHA(i,2), PUE_AGHA(i,2), ...
         40, ...
         RegCol(i,:), ... % Use the color for this group
         'filled', ...
         'LineWidth', 1.5);
    hold on
    % Set face alpha and edge color
    %h.MarkerFaceAlpha = 0;
    h.MarkerEdgeColor = RegCol(i,:) * 0.7; % Darker version of same color
end

hold off;

n_ylim = [0,1.5];
ylim(n_ylim)
xlim([-25,75]) % [0.999,0.001]
xticks([-25, 0, 25, 50, 75])    
box on

set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gcf,'position',plot_dim_1)

ylabel('PUE (-)')
xlabel('Surplus (kg-P ha^-^1 y^-^1)')

Figfolderpath = ['..\OUTPUTS\HUC2\HUCFigures\ConcepFigure_Surplus_v_PUE.png'];
print('-dpng','-r600',[Figfolderpath])

%% 1-PUE on x-axis
PUE_inv = 1-PUE;
PUE_AGHA(:,4) = 1-PUE_AGHA(:,2);

figure(1)
% Plotting the middle lines to section off the negative and positive
% surplus
plot([-200,1000], [0, 0],'k:')
hold on
plot([0,0], [0, 2],'k:')

% Plot 1% of gridded data points 
scatter(SURP, PUE_inv, 15,'filled', ...
    'MarkerFaceAlpha', 0.2, ...
    'MarkerFaceColor',[0.8,0.8,0.8], ...
    'MarkerEdgeColor',[0.7, 0.7, 0.7])

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

% Adding regional medians to scatter plot of P surplus vs. PUE
YEARS = 1930:2017;
idx_2017 = find(YEARS == 2017);

groups = PUE_AGHA(:,3);

% Plot each group separately
for i = 1:length(PUE_AGHA(:,3))
    idx = PUE_AGHA(:,3) == groups(i);
    
    % Create scatter plot for this group
    h = scatter(AGS_AGHA(i,2), PUE_AGHA(i,4), ...
         40, ...
         RegCol(i,:), ... % Use the color for this group
         'filled', ...
         'LineWidth', 1.5);
    hold on
    % Set face alpha and edge color
    %h.MarkerFaceAlpha = 0;
    h.MarkerEdgeColor = RegCol(i,:) * 0.7; % Darker version of same color
end

hold off;

n_ylim = [-0.2,1];
ylim(n_ylim)
xlim([-25,75]) % [0.999,0.001]
xticks([-25, 0, 25, 50, 75])    
box on

set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gcf,'position',plot_dim_1)

ylabel('1 - PUE (-)')
xlabel('Surplus (kg-P ha^-^1 y^-^1)')

Figfolderpath = ['..\OUTPUTS\HUC2\HUCFigures\ConcepFigure_Surplus_v_PUE_V2.png'];
print('-dpng','-r600',[Figfolderpath])