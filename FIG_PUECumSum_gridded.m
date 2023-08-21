clc, clear, close all

%% Aesthetic 
fontSize_p = 10;
fontSize_p2 = 12; 
plot_dim_1 = [400,400,375,280];
plot_dim_2 = [200,200,170,125];
plot_dim_3 = [200,200,200,150];
mSize = 10; 

colourPalette = [1,102,94;
                140,81,10; 
                 90,180,172;
                 216,179,101]./255;
             
% colourPalette_extended = [1,102,94;1,102,94;
%                         216,179,101; 216,179,101; 
%                         90,180,172; 90,180,172;
%                         140,81,10; 140,81,10]./255;
%% Read in gif files
INPUTfilepath = '..\INPUTS_103122\';
PUEfilepath = '..\OUTPUTS\PUE\PUE_2017.tif';
CUMSUMfilepath = '..\OUTPUTS\Cumulative Phosphorus\CumSum_2017.tif';
%OUTPUTfilepath = '..\OUTPUTS\Quadrant\'; [OUTPUTfilepath,'Lvstk_Fert_Ratio_Grid_20230623.mat']
HUC2filepath = '..\OUTPUTS\HUC2\';
% binscatter(x,y)
[PUE2017,~] = readgeoraster(PUEfilepath); % single
[CS2017,~] = readgeoraster(CUMSUMfilepath); % single

PUE2017(find(PUE2017 > 2^20)) = 0; 
CS2017(find(CS2017 > 2^20)) = 0; 

PUEfilepath = '..\OUTPUTS\PUE\PUE_1980.tif';
CUMSUMfilepath = '..\OUTPUTS\Cumulative Phosphorus\CumSum_1980.tif';

% binscatter(x,y)
[PUE1980,~] = readgeoraster(PUEfilepath); % single
[CS1980,~] = readgeoraster(CUMSUMfilepath); % single

PUE1980(find(PUE1980 > 2^20)) = 0; 
CS1980(find(CS1980 > 2^20)) = 0; 

% Vectorizin the data
PUE2017_v = PUE2017(:);
CS2017_v = CS2017(:);
PUE2017 = []; 
CS2017 = []; 

PUE1980_v = PUE1980(:);
CS1980_v = CS1980(:);
PUE1980 = []; 
CS1980 = []; 

D = [CS1980_v, CS2017_v,PUE1980_v, PUE2017_v]; 

loadstar_CumSum = 0; %median(D(:,1),'omitnan');
loadstar_PUE = 1;% median(D(:,3),'omitnan');


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
D_copy = D; 
%% Creating barchart of the fraction of the total dataset that belongs to what quadrant.
D = D_copy;
close all
% Stats for each quadrant
% 1980
Q_1980 = [length(find(D(:,5) == 1)); 
          length(find(D(:,5) == 2)); 
          length(find(D(:,5) == 3)); 
          length(find(D(:,5) == 4))]./size(D,1); 

Q_2017 = [length(find(D(:,6) == 1)); 
          length(find(D(:,6) == 2)); 
          length(find(D(:,6) == 3)); 
  length(find(D(:,6) == 4))]./size(D,1); 

figure(1)
b = bar([Q_1980,Q_2017]','stacked');
b(1).FaceColor = colourPalette(1,:);
b(2).FaceColor = colourPalette(2,:);
b(3).FaceColor = colourPalette(3,:);
b(4).FaceColor = colourPalette(4,:);

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},...
    {'k','k','k'});
set(gcf,'position',plot_dim_3)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

ylim([0,0.2])

set(gca,'xticklabel',{'1980', '2017'})

%% Finding the distribution of dominant manure inputs (vs. tot fertilizer) for each quadrant.
D = D_copy;
% Read in the 2017 livestock and fertilzier rasters
INPUTfilepath = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded (2023-07-25)\'];
OUTPUTfilepath = '..\OUTPUTS\Quadrants\';
YEARS = 1930:2017;

fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU\';
livestockFolder = 'Lvst_Agriculture_LU\';

[LVSTK2017,~] = readgeoraster([INPUTfilepath,livestockFolder,'Lvst_2017.tif']);
[FERT2017,~] = readgeoraster([INPUTfilepath,fertilizerFolder,'Fertilizer_Ag_2017.tif']);

[LVSTK1980,~] = readgeoraster([INPUTfilepath,livestockFolder,'Lvst_1980.tif']);
[FERT1980,~] = readgeoraster([INPUTfilepath,fertilizerFolder,'Fertilizer_Ag_1980.tif']);

LVSTK2017_v = double(LVSTK2017(:));
FERT2017_v = double(FERT2017(:));

LVSTK1980_v = double(LVSTK1980(:));
FERT1980_v = double(FERT1980(:));


% Removing the boxes that have no quadrant in 2018
Lvsk_Fert_Quadrant = [LVSTK2017_v./(FERT2017_v+LVSTK2017_v), D(:,6), ones(size(D,1),1)*2017; 
                      LVSTK1980_v./(FERT1980_v+LVSTK1980_v), D(:,5), ones(size(D,1),1)*1980];         
Lvsk_Fert_Quadrant = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant(:,2) ~= 0,:) ;

Lvsk_Fert_Quadrant =  array2table(Lvsk_Fert_Quadrant, 'VariableNames', {'LvstkFertFract','Q','QYear'});
save([OUTPUTfilepath,'Lvstk_Fert_Ratio_Grid_20230818.mat'], 'Lvsk_Fert_Quadrant')
%%
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
xticks([0, 0.5, 1, 1.5, 2, 2.5,3, 3.5,4])    
xticklabels({'.','1980','2017','1980','2017','1980','2017','1980','2017'})
%ylabel('% Manure of Total Fertilizer')

%%
figure(2)
Lvsk_Fert_Quadrant_1980 = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.QYear == 1980,:);

for i = 1:4
    sLvsk_Fert_Quadrant_1980 = Lvsk_Fert_Quadrant_1980(Lvsk_Fert_Quadrant_1980.Q == i,:);
    b_1980 = boxchart(sLvsk_Fert_Quadrant_1980.Q,...
        sLvsk_Fert_Quadrant_1980.LvstkFertFract,'MarkerStyle',...
        'none','BoxFaceColor',colourPalette(i,:));
    hold on
end

box on
set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

ylim([0,1.05])
xticks([1,2,3,4])
xticklabels({'Q1','Q2','Q3','Q4'})

Figfolderpath = [OUTPUTfilepath,'Q_Boxplot_1980_',datestr(datetime,'mmddyy'),'.png'];
print('-dpng','-r600',[Figfolderpath])

figure(3)
Lvsk_Fert_Quadrant_2017 = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.QYear == 2017,:);

for i = 1:4
    sLvsk_Fert_Quadrant_2017 = Lvsk_Fert_Quadrant_2017(Lvsk_Fert_Quadrant_2017.Q == i,:);
    b_2017 = boxchart(sLvsk_Fert_Quadrant_2017.Q,...
        sLvsk_Fert_Quadrant_2017.LvstkFertFract,'MarkerStyle',...
        'none','BoxFaceColor',colourPalette(i,:));
    hold on
end
box on
set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

ylim([0,1.05])
xticks([1,2,3,4])
xticklabels({'Q1','Q2','Q3','Q4'})
%ylabel('% Manure of Total Inputs')

Figfolderpath = [OUTPUTfilepath,'Q_Boxplot_2017_',datestr(datetime,'mmddyy'),'.png'];
print('-dpng','-r600',[Figfolderpath])

%% Subsampling the data
D = D_copy;
D = D(~isnan(D(:,1)),:);
I = sort(randperm(length(D),ceil(length(D)/100))'); 

D = D(I,:);
% 2017
unQ = unique(D(:,6));
unQ = unQ(find(unQ ~= 0));

%% Scatter 
close all

%2017
figure(1)
for i = 1:length(unQ)
    temp_D = D(find(D(:,6) == unQ(i)),:); 
    scatter(temp_D(:,4), temp_D(:,2), mSize, 'filled',...
              'MarkerFaceColor',colourPalette(i,:),...
              'MarkerFaceAlpha',0.05)
%             'MarkerEdgeColor',none[0 0 0],...
%              'LineWidth',0.5
    hold on
end
plot([0,20], [0,0],'--k','LineWidth',1)
plot([1,1], [-2000,4000],'--k','LineWidth',1)

xlim([0,3])
ylim([-300, 4000])

set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

%xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
%ylabel('Phosphorus Use Efficiency')

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
plot([0,20], [0,0],'--k','LineWidth',1)
plot([1,1], [-2000,4000],'--k','LineWidth',1)

xlim([0,3])
ylim([-300, 4000])
%% Saving Files

set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

%xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
%ylabel('Phosphorus Use Efficiency')

Figfolderpath = [OUTPUTfilepath,'Quadrant_1980_', datestr(datetime,'mmddyy'),'.png'];
print('-dpng','-r600',Figfolderpath)

%% Creating a Sankey Flow Chart
D(D(:,5) == 0,:) = [];
D(D(:,6) == 0,:) = [];
data = D(:,[5,6]);
% Customizable options
% Colormap: can be the name of matlab colormaps or a matrix of (N x 3).
%   Important: N must be the max number of categories in a layer 
%   multiplied by the number of layers. 

options.color_map = [colourPalette; colourPalette];
options.flow_transparency = 0.1;    % opacity of the flow paths
options.bar_width = 40;             % width of the category blocks
options.show_perc = false;          % show percentage over the blocks
options.text_color = [1 1 1];       % text color for the percentages
options.show_layer_labels = true;   % show layer names under the chart
options.show_cat_labels = true;     % show categories over the blocks.
options.categoryNames = [{'Year 1980'},'Year 2017'];
options.show_legend = false;        % show legend with the category names. 
                                    % if the data is not a table, then the
                                    % categories are labeled as catX-layerY

plotSankeyFlowChart(data,options);

%% Adding HUC2 to the quadrant plot
%HUC2_PUE = readtable([HUC2filepath,'PUE_meanHUC2_fromgrid.txt']);   