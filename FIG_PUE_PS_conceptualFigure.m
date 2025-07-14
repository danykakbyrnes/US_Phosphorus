clc, clear, close all

%% Creating the Surplus v. PUE scatter plot figure. 
% Filepaths
loadenv(".env")
INPUT_filepath = getenv('REGIONAL_ANALYSIS');
TREND_filepath = getenv('POSTPROCESSED_TREND');
PUE_filepath = getenv('PHOS_USE_EFFICIENCY');
OUTPUT_filepath = getenv('SURPLUS_PUE');

%% Aesthetic 
fontSize_p = 12;
plot_dim_1 = [400,400,400,400];

% Regional Color schemes
RegCol =  [228,26,28; % region 9
           55,126,184; % region 8
           77,175,74;
           152,78,163;
           255,127,0;
           255,255,51;
           166,86,40;
           247,129,191;
           195,243,227]./255; % region 1

mSize = 10; 

%% Reading in data
PUE_AGHA = readmatrix([INPUT_filepath,'PUE_medianRegion.txt']);
AGS_AGHA = readmatrix([INPUT_filepath,'Ag_Surplus_medianRegion.txt']);

% Importing the gridded data
[PUE,~] = readgeoraster([PUE_filepath, 'PUE_2017.tif']);
[SURP,~] = readgeoraster([TREND_filepath, 'Ag_Surplus\Ag_Surplus_2017.tif']);

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

%% Surplus vs. PUE on x-axis 
figure(1)

% Plotting the middle lines to section off the negative and positive
% surplus
plot([-200,1000], [0, 0],'k:')
hold on
plot([0,0], [0, 2],'k:')

% Plot 1% of gridded data points 
scatter(SURP, PUE, 25,...
    'MarkerFaceColor', '#BABABA', ...
    'MarkerEdgeColor', '#BABABA', ...
    'MarkerFaceAlpha', 0.025,...
    'MarkerEdgeAlpha', 0.05)

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

% Adding regional medians to scatter plot of P surplus vs. PUE
YEARS = 1930:2017;
idx_2017 = find(YEARS == 2017);

PUE_AGHA = PUE_AGHA(:,[1, idx_2017+1]);
PUE_AGHA = sortrows(PUE_AGHA,'ascend');

AGS_AGHA = AGS_AGHA(:,[1, idx_2017+1]);
AGS_AGHA = sortrows(AGS_AGHA,'ascend');

% Insert a column in indexes that are sequential for 
% plotting and do not correspond to region numbers.
PUE_AGHA = [PUE_AGHA, [1:size(PUE_AGHA,1)]'];
AGS_AGHA = [AGS_AGHA, [1:size(AGS_AGHA,1)]'];

groups = PUE_AGHA(:,3);

% Plot each group separately
for i = 1:length(PUE_AGHA(:,3))
    idx = PUE_AGHA(:,3) == groups(i);
    
    % Create scatter plot for this group
    h = scatter(AGS_AGHA(i,2), PUE_AGHA(i,2), ...
         120, ...
         RegCol(i,:), ... % Use the color for this group
         'filled', ...
         'LineWidth', 1.5);
    hold on
    % Set face alpha and edge color
    h.MarkerFaceColor = RegCol(i,:);
    h.MarkerFaceAlpha = 0.95;
    h.MarkerEdgeColor = RegCol(i,:) * 0.8; % Darker version of same color
end

hold off;

n_ylim = [0,1.5];
ylim(n_ylim)
xlim([-25,75]) % [0.999,0.001]
xticks([-25, 0, 25, 50, 75])    
box on

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gcf,'position',plot_dim_1)

ylabel('PUE')
xlabel('Surplus (kg-P ha^-^1 y^-^1)')

Figfolderpath = [OUTPUT_filepath, 'ConcepFigure_Surplus_v_PUE.png'];
print('-dpng','-r600',Figfolderpath)

%% 1-PUE on x-axis
PUE_inv = 1-PUE;
PUE_AGHA(:,4) = 1-PUE_AGHA(:,2);

figure(2)
% Plotting the middle lines to section off the negative and positive
% surplus
plot([-200,1000], [0, 0],'k:')
hold on
plot([0,0], [0, 2],'k:')

% Plot 1% of gridded data points 
scatter(SURP, PUE_inv, 25,...
    'MarkerFaceColor', '#BABABA', ...
    'MarkerEdgeColor', '#BABABA', ...
    'MarkerFaceAlpha', 0.025,...
    'MarkerEdgeAlpha', 0.05)

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
         120, ...
         RegCol(i,:), ... % Use the color for this group
         'filled', ...
         'LineWidth', 1.5);
    hold on

    % Set face alpha and edge color
    h.MarkerFaceColor = RegCol(i,:);
    h.MarkerFaceAlpha = 0.95;
    h.MarkerEdgeColor = RegCol(i,:) * 0.8; % Darker version of same color
end

hold off;

n_ylim = [-0.25,1];
ylim(n_ylim)
xlim([-25,75]) % [0.999,0.001]
xticks([-25, 0, 25, 50, 75])    
box on

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gcf,'position',plot_dim_1)

ylabel('1 - PUE')
xlabel('Surplus (kg-P ha^-^1 y^-^1)')

Figfolderpath = [OUTPUT_filepath,'ConcepFigure_Surplus_v_PUE_V2.png'];
print('-dpng','-r600',Figfolderpath)

%% 1-PUE on x-axis
figure(3)
% Plotting the middle lines to section off the negative and positive
% surplus
plot([1, 1], [-200,100],'k:')
hold on
plot([0, 2], [0,0],'k:')

% Plot 1% of gridded data points 
scatter(PUE, SURP, 25,...
    'MarkerFaceColor', '#BABABA', ...
    'MarkerEdgeColor', '#BABABA', ...
    'MarkerFaceAlpha', 0.025,...
    'MarkerEdgeAlpha', 0.05)

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
    h = scatter(PUE_AGHA(i,2), AGS_AGHA(i,2),...
         120, ...
         RegCol(i,:), ... % Use the color for this group
         'filled', ...
         'LineWidth', 1.5);
    hold on

    % Set face alpha and edge color
    h.MarkerFaceColor = RegCol(i,:);
    h.MarkerFaceAlpha = 0.95;
    h.MarkerEdgeColor = RegCol(i,:) * 0.8; % Darker version of same color
end

hold off;

n_xlim = [0,1.25];
xlim(n_xlim)
ylim([-10,50]) % [0.999,0.001]
yticks([-10, 0, 10, 20, 30, 40, 50])
box on

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gcf,'position',plot_dim_1)

xlabel('PUE')
ylabel('Surplus(kg-P ha^-^1 y^-^1)')

Figfolderpath = [OUTPUT_filepath,'ConcepFigure_PUE_v_surplus.png'];
print('-dpng','-r600', Figfolderpath)