clc, clear, close all

OUTPUT_filepath = getenv('SURPLUS_CUMUSURP');
CUMSUM_filepath = getenv('CUMULATIVE_PHOS');
TREND_filepath = getenv('POSTPROCESSED_TREND');

% reading in gridded data
[CS2017,~] = readgeoraster([CUMSUM_filepath,'CumSum_2017.tif']);
[SURP2017,~] = readgeoraster([TREND_filepath, 'Ag_Surplus\Ag_Surplus_2017.tif']);

% Reading in regional medians
SURPcumu_AGHA = readmatrix('..\OUTPUTS\HUC2\CumSum_medianHUC2_fromgrid.txt');
AGS_AGHA = readmatrix('..\OUTPUTS\HUC2\Ag_Surplus_medianHUC2Components.txt');

% Figure aesthetic
plot_dim = [100,100,400,350];
fontSize_p = 12;

% Cleaning the data so that only cells with data for PS and cPS are used. 
CS2017_v = CS2017(:);
SURP2017_v = SURP2017(:);

DisnanIDX = (SURP2017_v == 0 | isnan(SURP2017_v));
CS2017_v = CS2017_v(DisnanIDX < 1, :);
SURP2017_v = SURP2017_v(DisnanIDX < 1, :);

D = [SURP2017_v, CS2017_v];

% Organizing regional data
SURPcumu_AGHA = SURPcumu_AGHA(:,[1, end]); % Isolating 2017
SURPcumu_AGHA = sortrows(SURPcumu_AGHA,'ascend'); % sorting by first row

YEARS = 1930:2017;
AGS_AGHA = AGS_AGHA(:,[1, find(YEARS == 2017)+1]); % Isolating 2017
AGS_AGHA = sortrows(AGS_AGHA,'ascend');

% Insert a column in indexes that are sequential for 
% plotting and do not correspond to region numbers.
D_reg = [AGS_AGHA(:,2), SURPcumu_AGHA(:,2), [1:size(AGS_AGHA,1)]'];

%% scatter plot version of gridded data and regions
% Subsetting D so it can actually run
I = sort(randperm(length(D), ceil(length(D)/100))'); 
D_ss = D(I,:);

% plotting scatter
scatter(D_ss(:,1), D_ss(:,2), 20, ...
    'MarkerFaceColor', '#A7A5A5', ...
    'MarkerEdgeColor', '#A7A5A5', ...
    'MarkerFaceAlpha', 0.01,...
    'MarkerEdgeAlpha', 0.01)

hold on

% Adding regions
RegCol =  [228,26,28;
           55,126,184;
           77,175,74;
           152,78,163;
           255,127,0;
           255,255,51;
           166,86,40;
           247,129,191;
           195,243,227]./255;

xlabel('Surplus (2017) [kg-P ha^-^1 yr^-^1]')
xlim([-10,30])
ylim([-250,1500])
ylabel('Cumulative Surplus (2017) [kg-P ha^-^1]')

% Adding regions
groups = D_reg(:,3);

% Plot each group separately
for i = 1:size(D_reg,1)
    idx = D_reg(:,3) == groups(i);
    
    % Create scatter plot for this group
    h = scatter(D_reg(i,1), D_reg(i,2), ...
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

set(gcf,'position',plot_dim)

hold off;
set(gcf,'position',[200,200,400,400])
Figfolderpath = [OUTPUT_filepath,'ConcepFigure_PS_CumuSurplus.png'];
print('-dpng','-r600',[Figfolderpath])