clc, clear, close all

% Aesthetic 
fontSize_p = 11;
fontSize_p2 = 8; 
plot_dim_1 = [400,400,200,150];
plot_dim_2 = [200,200,215,350];
plot_dim_alt = [200,200,215,215];
plot_dim_3 = [200,200,400,200];

mSize = 4; 

colourPalette = [1,102,94;
                140,81,10; 
                 90,180,172;
                 216,179,101]./255;
             
% colourPalette_extended = [1,102,94;1,102,94;
%                         216,179,101; 216,179,101; 
%                         90,180,172; 90,180,172;
%                         140,81,10; 140,81,10]./255;

% Read in gif files
INPUTfilepath = '..\INPUTS_103122\';
OUTPUTfilepath = '..\OUTPUTS\Quadrants\';
HUC2filepath = '..\OUTPUTS\HUC2\';
trendINPUTfilepath = ['..\..\3_TREND_Nutrients\TREND_Nutrients\OUTPUT\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded (2023-11-18)\'];

% These data (PUE + SURPcumu) has NaN for all cells that are not ag land. 
% Reading in 2017 data.
PUEfilepath = '..\OUTPUTS\PUE\PUE_2017.tif';
CUMSUMfilepath = '..\OUTPUTS\Cumulative_Phosphorus\CumSum_2017.tif';
[PUE2017,~] = readgeoraster(PUEfilepath); % single
[CS2017,~] = readgeoraster(CUMSUMfilepath); % single

% Reading in 1980 data.
PUEfilepath = '..\OUTPUTS\PUE\PUE_1980.tif';
CUMSUMfilepath = '..\OUTPUTS\Cumulative_Phosphorus\CumSum_1980.tif';

[PUE1980,~] = readgeoraster(PUEfilepath); % single
[CS1980,~] = readgeoraster(CUMSUMfilepath); % single

% Vectorizing the data
PUE2017_v = PUE2017(:);
CS2017_v = CS2017(:);
PUE1980_v = PUE1980(:);
CS1980_v = CS1980(:);

clear PUE2017 CS2017 PUE1980 CS1980

% Creating a matrix with available data.
D = [CS1980_v, CS2017_v,PUE1980_v, PUE2017_v]; 

% Setting the quadrant divisions.
loadstar_CumSum = 0;
loadstar_PUE = 1;

% Assigning the data into quadrants.
% 1980
for i = 1:length(D)
   
    if D(i,1) > loadstar_CumSum
        if D(i,3) > loadstar_PUE
            D(i,5)  = 1; 
        elseif D(i,3) <= loadstar_PUE
            D(i,5)  = 2; 
        end
    elseif D(i,1) <= loadstar_CumSum
        if D(i,3) > loadstar_PUE
            D(i,5)  = 4;
        elseif D(i,3) <= loadstar_PUE
            D(i,5)  = 3; 
        end
    end
end

% 2017
for i = 1:length(D)
   
    if D(i,2) > loadstar_CumSum
        if D(i,4) > loadstar_PUE
            D(i,6)  = 1; 
        elseif D(i,4) <= loadstar_PUE
            D(i,6)  = 2; 
        end
    elseif D(i,2) <= loadstar_CumSum
        if D(i,4) > loadstar_PUE
            D(i,6)  = 4;
        elseif D(i,4) <= loadstar_PUE
            D(i,6)  = 3; 
        end
    end
end

save([OUTPUTfilepath,'QuadrantMapping.mat'], 'D', '-v7.3')

% D_copy is the unfiltered form of the data.
D_allData = D;

% Cleaning the data 
% First we will clean up the D matrix to only consider PUE data
% that has both 1980 and 2017 data. Which means looking ONLY at the 
% grid-cells that are still agricultural. If PUE is NaN
% then there is no ag land in that year for the grid-cell.

%DisnanIDX = isnan(D(:,3)) + isnan(D(:,4));
%D = D(DisnanIDX == 0, :);
DisnanIDX = [(D(:,5) == 0) + (D(:,6) == 0)];
D = D(DisnanIDX < 1, :);

% D_copy is the cleaned form of the data.
D_cleanedData = D;

%% Quadrant Plot

D = D_cleanedData;
% To improve computation speed for plotting, we will only use 1% of the 
% gridcells available.
I = sort(randperm(length(D),ceil(length(D)/100))'); 
D = D(I,:);

% Create colormaps
colourPalette = [1,102,94;
                140,81,10; 
                90,180,172;
                216,179,101]./255;

% Getting quadrant numbers
unQ = unique(D(:,6));

% 2017
figure(1)
for i = 1:length(unQ)
    temp_D = D(find(D(:,6) == unQ(i)),:); 
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
Figfolderpath = [OUTPUTfilepath,'Quadrant_2017_',datestr(datetime,'mmddyy'),'.png'];
print('-dpng','-r600',[Figfolderpath])

% 1980
figure(2)
for i = 1:length(unQ)
    temp_D = D(find(D(:,5) == unQ(i)),:); 
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
Figfolderpath = [OUTPUTfilepath,'Quadrant_1980_', datestr(datetime,'mmddyy'),'.png'];
print('-dpng','-r600',Figfolderpath)

%% Creating a Sankey Flow Chart
D = D_cleanedData;

data = D(:,[5,6]);
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

Figfolderpath = [OUTPUTfilepath,'SankeyPlot_',datestr(datetime,'mmddyy'),'.svg'];
print('-dsvg',[Figfolderpath])

% Percentages for Manuscript Metrics
Q_pct = [sum(D(:,5) == 1)/length(D), sum(D(:,6) == 1)/length(D); 
     sum(D(:,5) == 2)/length(D), sum(D(:,6) == 2)/length(D); 
     sum(D(:,5) == 3)/length(D), sum(D(:,6) == 3)/length(D);
     sum(D(:,5) == 4)/length(D), sum(D(:,6) == 4)/length(D)]*100;
save([OUTPUTfilepath,'QuadrantPct.mat'], 'Q_pct')

%% Finding the distribution of dominant manure inputs (vs. tot fertilizer) 
% for each quadrant.
D = D_allData; % D = CS1980, CS2017, PUE1980, PUE2017, Q1980, Q2017

% Read in the 2017 livestock and fertilzier rasters
YEARS = 1930:2017;

fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU\';
livestockFolder = 'Lvst_Agriculture_LU\';

[LVSTK2017,~] = readgeoraster([trendINPUTfilepath,livestockFolder,...
                               'Lvst_2017.tif']);
[FERT2017,~] = readgeoraster([trendINPUTfilepath,fertilizerFolder,...
                              'Fertilizer_Ag_2017.tif']);
%[CROP2017,~] = readgeoraster([trendINPUTfilepath,'CropUptake_Agriculture_Agriculture_LU/CropUptake_2017.tif']);

[LVSTK1980,~] = readgeoraster([trendINPUTfilepath,livestockFolder,...
                                'Lvst_1980.tif']);
[FERT1980,~] = readgeoraster([trendINPUTfilepath,fertilizerFolder,...
                                'Fertilizer_Ag_1980.tif']);

LVSTK2017_v = double(LVSTK2017(:));
FERT2017_v = double(FERT2017(:));
%CROP2017_v = double(CROP2017(:));

LVSTK1980_v = double(LVSTK1980(:));
FERT1980_v = double(FERT1980(:));

% Cleaning the data.  D = CS1980, CS2017, PUE1980, PUE2017, Q1980, Q2017
DisnanIDX = isnan(D(:,3)) + isnan(D(:,4));
D = D(DisnanIDX == 0, :);
LVSTK2017_v = LVSTK2017_v(DisnanIDX == 0, :);
FERT2017_v = FERT2017_v(DisnanIDX == 0, :);
LVSTK1980_v = LVSTK1980_v(DisnanIDX == 0, :);
FERT1980_v = FERT1980_v(DisnanIDX == 0, :);

% Removing the boxes that have no quadrant in 2018
Lvsk_Fert_Quadrant = [LVSTK2017_v./(FERT2017_v+LVSTK2017_v), D(:,6),... 
                      repmat(2017,size(D,1),1);
                      LVSTK1980_v./(FERT1980_v+LVSTK1980_v), D(:,5),...
                      repmat(1980,size(D,1),1)];

Lvsk_Fert_Quadrant =  array2table(Lvsk_Fert_Quadrant, 'VariableNames', {'LvstkFertFract','Q','QYear'});
save([OUTPUTfilepath,'Lvstk_Fert_Ratio_Grid.mat'], 'Lvsk_Fert_Quadrant')

% Creating the boxplot panel for quadrant input distribution (figure 6).
% 2017
figure(1)
for i = 1:4
    sLvsk_Fert_Quadrant= Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.Q == i,:);
    b = boxchart(sLvsk_Fert_Quadrant.Q,...
        sLvsk_Fert_Quadrant.LvstkFertFract,'MarkerStyle',...
        'none','BoxFaceColor',colourPalette(i,:),'GroupByColor',...
        sLvsk_Fert_Quadrant.QYear);
    hold on
end

box on
set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

ylim([0,1.05])
xlim([1,4])
xticks([1, 1.5, 2, 2.5,3, 3.5, 4])    
xticklabels({'1980','2017','1980','2017','1980','2017','1980','2017'})
ylabel('% Manure of Inputs')

close all

unyears = unique(Lvsk_Fert_Quadrant.QYear);
for j = 1:2
    subplot(1,2,j)
    Lvsk_Fert_Quadrant_j = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.QYear == unyears(j),:);
    for i = 1:4
        
        sLvsk_Fert_Quadrant = Lvsk_Fert_Quadrant_j(Lvsk_Fert_Quadrant_j.Q == i,:);
        b_1980 = boxchart(sLvsk_Fert_Quadrant.Q,...
            sLvsk_Fert_Quadrant.LvstkFertFract*100,'MarkerStyle',...
            'none','BoxFaceColor',colourPalette(i,:));
        hold on
    
        oLvsk_Fert_Quadrant = Lvsk_Fert_Quadrant_j(Lvsk_Fert_Quadrant_j.Q ~= i,:);
        pv(i) = ranksum(sLvsk_Fert_Quadrant.LvstkFertFract, oLvsk_Fert_Quadrant.LvstkFertFract);
    end
    box on
    set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
    set(gca,'XColor',[0,0,0])
    set(gca,'YColor',[0,0,0])
    set(gca,'ZColor',[0,0,0])
    
    ylim([0,105])
    xticks([1,2,3,4])
    xticklabels({'Q1','Q2','Q3','Q4'})
end
subplot(1,2,1)
ylabel('% Manure of Inputs')
yticks([0, 25, 50, 75, 100])
subplot(1,2,2)
yticks([])
set(gcf,'position',plot_dim_3)
Figfolderpath = [OUTPUTfilepath,'Q_Boxplot_',datestr(datetime,'mmddyy'),'.png'];
print('-dpng','-r600',[Figfolderpath])