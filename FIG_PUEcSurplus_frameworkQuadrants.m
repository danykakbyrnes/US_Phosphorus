
clc, clear, close all

% Filepaths
OUTPUT_filepath = getenv('QUADRANT_ANALYSIS');

%% FIGURE 7: Framework figure
% Aesthetic 
fontSize_p = 11;
fontSize_p2 = 8; 
plot_dim_1 = [400,400,200,150];
plot_dim_2 = [200,200,215,350];
plot_dim_alt = [200,200,215,215];

mSize = 4; 

colourPalette = [1,102,94;
                140,81,10; 
                 90,180,172;
                 216,179,101]./255;
             
%% Read and clean data
load([OUTPUT_filepath,'QuadrantMapping.mat'])

% D_copy is the unfiltered form of the data.
D_allData = D;

% Cleaning the data 
% First we will clean up the D matrix to only consider PUE data
% that has both 1980 and 2017 data. Which means looking ONLY at the 
% grid-cells that are still agricultural. If PUE is NaN
% then there is no ag land in that year for the grid-cell.
DisnanIDX = [(D(:,7) == 0) + (D(:,8) == 0)];
D = D(DisnanIDX < 1, :);

% D_copy is the cleaned form of the data.
D_cleanedData = D;

%% Quadrant Plot
% To improve computation speed for plotting, we will only use 1% of the 
% gridcells available.
I = sort(randperm(length(D),ceil(length(D)/100))'); 
D = D(I,:);

% Getting quadrant numbers
unQ = unique(D(:,8));

% 2017
figure(1)
for i = 1:length(unQ)
    temp_D = D(find(D(:,8) == unQ(i)),:); 
    scatter(temp_D(:,4), temp_D(:,2), mSize, 'filled',...
              'MarkerFaceColor',colourPalette(i,:),...
              'MarkerFaceAlpha',0.05)
    hold on
end

plot([0,20], [0,0],'--k','LineWidth',0.5)
plot([1,1], [-2000,4000],'--k','LineWidth',0.5)

xlim([0,3])
ylim([-300, 4000])

set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gcf,'position',plot_dim_1)

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

% Saving Figure
Figfolderpath = [OUTPUT_filepath,'QuadrantPlot_2017.png'];
print('-dpng','-r600',[Figfolderpath])

% 1980
figure(2)
for i = 1:length(unQ)
    temp_D = D(find(D(:,7) == unQ(i)),:); 
    scatter(temp_D(:,3),temp_D(:,1), mSize, 'filled',...
              'MarkerFaceColor',colourPalette(i,:),...
              'MarkerFaceAlpha',0.05)
    hold on
end
plot([0,20], [0,0],'--k','LineWidth',0.5)
plot([1,1], [-2000,4000],'--k','LineWidth',0.5)

xlim([0,3])
ylim([-300, 4000])

set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gcf,'position',plot_dim_1)

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

% Saving Files
Figfolderpath = [OUTPUT_filepath,'QuadrantPlot_1980.png'];
print('-dpng','-r600',Figfolderpath)

%% Creating a Sankey Flow Chart
D = D_cleanedData;

data = D(:,[7,8]);
% Customizable options
% Colormap: can be the name of matlab colormaps or a matrix of (N x 3).
%   Important: N must be the max number of categories in a layer 
%   multiplied by the number of layers. 

options.flow_transparency = 0.3;    % opacity of the flow paths
options.bar_width = 30;             % width of the category blocks
options.show_perc = false;          % show percentage over the blocks
options.text_color = [1 1 1];       % text color for the percentages
options.show_layer_labels = false;   % show layer names under the chart
options.show_cat_labels = false;     % show categories over the blocks.
options.categoryNames = [{'1980'},{'2017'}];
options.show_legend = false;        % show legend with the category names. 
                                    % if the data is not a table, then the
                                    % categories are labeled as catX-layerY
options.color_map = [colourPalette; colourPalette];
plotSankeyFlowChart(data,options);
%set(gcf,'position',plot_dim_2)
set(gcf,'position',plot_dim_alt)

Figfolderpath = [OUTPUT_filepath,'SankeyPlot.svg'];
print('-dsvg',[Figfolderpath])

% Percentages for Manuscript Metrics
Q_pct = [sum(D(:,7) == 1)/length(D), sum(D(:,8) == 1)/length(D); 
     sum(D(:,7) == 2)/length(D), sum(D(:,8) == 2)/length(D); 
     sum(D(:,7) == 3)/length(D), sum(D(:,8) == 3)/length(D);
     sum(D(:,7) == 4)/length(D), sum(D(:,8) == 4)/length(D)]*100;
save([OUTPUT_filepath,'QuadrantPct.mat'], 'Q_pct')