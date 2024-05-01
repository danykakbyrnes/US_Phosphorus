clc, clear, close all
% ------------------------------------------------------------------------
% MAKING HUC TIMESERIES FOR FIGURE 4. This uses the mean PUE of all 
% gridcells 
% ------------------------------------------------------------------------
smoothing_int = [5 5];

fontSize_p = 9;
plot_dim_1 = [100,100,250,175];
plot_dim_3 = [100,100,400,125];
mSize = 36; 

colourPalette = [1,102,94;
                216,179,101; 
                 90,180,172;
                 140,81,10]./255;
c = '#007a0c';
YEARS = 1930:2017;
OUTPUT_folderName = '../OUTPUTS/HUC2/';
%% Opening files

MANURE_AGHA = readmatrix([OUTPUT_folderName, 'Lvsk_medianHUC2Components.txt']);
MANURE_AGHA = sortrows(MANURE_AGHA,'descend');

FERT_AGHA = readmatrix([OUTPUT_folderName, 'Fert_medianHUC2Components.txt']);
FERT_AGHA = sortrows(FERT_AGHA,'descend');

CROP_AGHA = readmatrix([OUTPUT_folderName, 'Crop_medianHUC2Components.txt']);
CROP_AGHA = sortrows(CROP_AGHA,'descend');

% Read in land use
HUCLU_diso = readmatrix([OUTPUT_folderName, 'HUC2LandUse_tif.txt']);

%% Reorganizing HUCLU and map the LU to the dates. 
unHUC = unique(HUCLU_diso(:,1)); 
for i = 1:length(unHUC)
    
    HUCLU_i = HUCLU_diso(find(HUCLU_diso(:,1) == unHUC(i)),:);
    
    for j = 1:length(YEARS)
       YEAR_j = YEARS(j);
       
        if YEAR_j <= 1938
            % Use 1938
            LUFrac = HUCLU_i(find(HUCLU_i(:,2) == 1938),end);
            AgLand = HUCLU_i(find(HUCLU_i(:,2) == 1938),3)*(250*250)/10^4;
        elseif YEAR_j > 1938 && YEAR_j < 2006
            % Use the individual year
            LUFrac = HUCLU_i(find(HUCLU_i(:,2) == YEAR_j),end);
            AgLand = HUCLU_i(find(HUCLU_i(:,2) == YEAR_j),3)*(250*250)/10^4;
        elseif YEAR_j >= 2006 && YEAR_j < 2008
            % Use 2006
            LUFrac = HUCLU_i(find(HUCLU_i(:,2) == 2006),end);
            AgLand = HUCLU_i(find(HUCLU_i(:,2) == 2006),3)*(250*250)/10^4;
        elseif  YEAR_j >= 2008 && YEAR_j < 2011
            % Use 2008
            LUFrac = HUCLU_i(find(HUCLU_i(:,2) == 2008),end);
            AgLand = HUCLU_i(find(HUCLU_i(:,2) == 2008),3)*(250*250)/10^4;
        elseif  YEAR_j >= 2011 && YEAR_j < 2013
            % Use 2011
            LUFrac = HUCLU_i(find(HUCLU_i(:,2) == 2011),end);
            AgLand = HUCLU_i(find(HUCLU_i(:,2) == 2011),3)*(250*250)/10^4;
        elseif  YEAR_j >= 2013 && YEAR_j < 2016
            % Use 2013
            LUFrac = HUCLU_i(find(HUCLU_i(:,2) == 2013),end);
            AgLand = HUCLU_i(find(HUCLU_i(:,2) == 2013),3)*(250*250)/10^4;
        elseif  YEAR_j >= 2016
            % Use 2016
            LUFrac = HUCLU_i(find(HUCLU_i(:,2) == 2016),end);
            AgLand = HUCLU_i(find(HUCLU_i(:,2) == 2016),3)*(250*250)/10^4;
        end

    HUCLU(i,1) = unHUC(i);
    HUCLU(i,j+1) = LUFrac;
    
    HUCAgHA(i,1) = unHUC(i);
    HUCAgHA(i,j+1) = AgLand; % in hectares

    end
    
end

% Sort from largest HUC ID to smallers 
HUCLU = sortrows(HUCLU,1,'descend');
HUCAgHA = sortrows(HUCAgHA,1,'descend');

%save([OUTPUT_folderName, 'HUC2_AgLandUse.mat'],'HUCLU')
%save([OUTPUT_folderName, 'HUC2_AgLandUse_ha.mat'],'HUCAgHA')


%% Calculating PUE and combined inputs
HUC_PUE = readmatrix([OUTPUT_folderName, 'PUE_medianHUC2_fromgrid.txt']);
HUC_PUE = sortrows(HUC_PUE,1,'descend');

% Isolate three regions. 
Regions_idx = [4,6,7];
HUCLU = HUCLU(Regions_idx,:);
HUC_PUE = HUC_PUE(Regions_idx,:);
MANURE_AGHA = MANURE_AGHA(Regions_idx,:);
CROP_AGHA = CROP_AGHA(Regions_idx,:);
FERT_AGHA = FERT_AGHA(Regions_idx,:);

for i = 1:height(HUC_PUE)
% FIGURE 1: TIMESERIES OF PUE ACROSS HUC REGIONS
    figure(1) 
    subplot(1,3,i)
    yyaxis right
    movmeanAGLAND = movmean(HUCLU(i,2:end),smoothing_int)*100;
    X = [YEARS, fliplr(YEARS)];
    Y = [zeros(1,length(YEARS)), fliplr(movmeanAGLAND)];
    pgon = polyshape(X,Y);
   
    hold on
    plot(pgon, 'EdgeColor', 'none', 'FaceColor', c)
    ylim([0,70])
    
    box on
    set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
    set(gca,'XColor',[0,0,0])
    set(gca,'YColor',[0,0,0])
    set(gca,'ZColor',[0,0,0])    

    yyaxis left
    plot([1930,2017], [1,1], ':k', 'LineWidth',0.5)
    hold on
    movmeanPUE = movmean(HUC_PUE(i,2:end),smoothing_int);
    plot(YEARS, movmeanPUE, '-', 'LineWidth',4,'Color', '#42233A')
    plot(YEARS, movmeanPUE, ':', 'LineWidth',1.5, 'Color', '#8C4A7A')
    xlim([1930,2017])
    ylim([0,1.5])
    
    box on
    set(gca, 'SortMethod', 'depth')
    set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
    set(gca,'XColor',[0,0,0])
    set(gca,'YColor',[0,0,0])
    set(gca,'ZColor',[0,0,0])
   set(gca,'XMinorTick','on','YMinorTick','on')
   set(gca,'TickLength',[0.03, 0])

    if i == 1
        yyaxis left
        yticks([0, 0.5, 1, 1.5])
        yyaxis right
        yticks([])
    elseif i == 2
        yyaxis left
        yticks([])
        yyaxis right
        yticks([])
    elseif i == 3
        yyaxis left
        yticks([])
        yyaxis right
        yticks([0, 35, 70])
    end

%% FIGURE 2: MANURE, FERTILIZER, AND CROP TIMESERIES
   figure(2) 
   faceColor = [134, 168, 147;
                180, 126, 93;
                111, 155,183]./255;
   faceColor = [50, 87, 64; 
                101, 55, 27;
                27, 73, 101]./255;
   subplot(1,3,i)
   movmeanManure = movmean(MANURE_AGHA(i,2:end),smoothing_int);
   plot(YEARS,movmeanManure,'-k', 'LineWidth',2, 'Color',faceColor(1,:)) 
   hold on
   
   movmeanCrop = movmean(CROP_AGHA(i,2:end),smoothing_int);
   plot(YEARS,movmeanCrop,'-k', 'LineWidth',2, 'Color',faceColor(2,:)) 
   
   movmeanFertilizer = movmean(FERT_AGHA(i,2:end),smoothing_int);
   plot(YEARS,movmeanFertilizer,'-k', 'LineWidth',2,'Color',faceColor(3,:)) 
    
  if i == 1
       ylim([0, 25])
       yticks([0, 12, 25])
  else
       ylim([0, 25])
       yticks([])
   end

   set(gca,'FontSize',fontSize_p,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   set(gca,'XMinorTick','on','YMinorTick','on')
   set(gca,'TickLength',[0.03, 0])

   %% FIGURE 3: MANURE, FERTILIZER, AND CROP TIMESERIES
   figure(3)
   
   faceColor = [134, 168, 147;
                180, 126, 93;
                111, 155,183]./255;
   edgeColor = [50, 87, 64; 
                101, 55, 27;
                27, 73, 101]./255;

    subplot(1,3,i)
    movmeanComponents = [movmeanManure; movmeanFertilizer];
    a = area(YEARS, movmeanCrop*-1);
    a(1).FaceColor = faceColor(1, :);
    a(1).EdgeColor = edgeColor(1, :);
    a(1).LineWidth = 0.75;
    hold on
    a = area(YEARS, movmeanComponents');
    a(1).FaceColor = faceColor(2, :);
    a(2).FaceColor = faceColor(3, :);

    a(1).EdgeColor = edgeColor(2, :);
    a(2).EdgeColor = edgeColor(3, :);

    a(1).LineWidth = 1.5;
    a(2).LineWidth = 0.75;

  if i == 1
       ylim([-25, 27])
       yticks([-25, 0, 25])
  else
       ylim([-25, 27])
       yticks([])
  end
   set(gca,'FontSize',fontSize_p,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   set(gca,'XMinorTick','on','YMinorTick','on')
   set(gca,'TickLength',[0.03, 0])

   plot([1930,2017], [0,0], 'LineWidth',0.3, 'Color', '#454545')

   %% FIGURE 4: MANURE, FERTILIZER, AND CROP TIMESERIES
   figure(4)
   
   faceColor = [134, 168, 147;
                180, 126, 93;
                111, 155,183]./255;
   edgeColor = [50, 87, 64; 
                101, 55, 27;
                27, 73, 101]./255;

    subplot(1,3,i)
    movmeanComponents = [movmeanManure; movmeanFertilizer];
    a = area(YEARS, movmeanCrop*-1);
    a.FaceColor = faceColor(1, :);
    a.EdgeColor = edgeColor(1, :);
    a.LineWidth = 1.25;
    a.FaceAlpha = 0.4;
    hold on
    a = area(YEARS, movmeanManure);
    a.FaceColor = faceColor(2, :);
    a.EdgeColor = edgeColor(2, :);
    a.LineWidth = 1.25;
    a.FaceAlpha = 0.4;

    a = area(YEARS, movmeanFertilizer);
    a.FaceColor = faceColor(3, :);
    a.EdgeColor = edgeColor(3, :);
    a.LineWidth = 1.25;
    a.FaceAlpha = 0.4;

   set(gca,'FontSize',fontSize_p,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   set(gca,'XMinorTick','on','YMinorTick','on')
   set(gca,'TickLength',[0.03, 0])

   plot([1930,2017], [0,0], 'LineWidth',0.3, 'Color', '#454545')

  if i == 1
       ylim([-25, 25])
       yticks([-25, 0, 25])
  else
       ylim([-25, 25])
       yticks([])
  end
end

figure(1)
set(gcf, 'Position',plot_dim_3)
Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_PUE_grid_panel_median_subset.png'];
print('-dpng','-r600',[Figfolderpath])

figure(2)
set(gcf, 'Position',plot_dim_3)
Figfolderpath = [OUTPUT_folderName,'HUCFigures/Component_grid_timeseries_median_subset.png'];
print('-dpng','-r600',[Figfolderpath])

figure(3)
set(gcf, 'Position',plot_dim_3)
Figfolderpath = [OUTPUT_folderName,'HUCFigures/Component_grid_areaplot_median_subset.png'];
print('-dpng','-r600',[Figfolderpath])

figure(4)
set(gcf, 'Position',plot_dim_3)
Figfolderpath = [OUTPUT_folderName,'HUCFigures/Component_grid_overlap_areaplot_median_subset.png'];
print('-dpng','-r600',[Figfolderpath])

%% How to make the Cumulative Surplus timeseries summary figures
close all
SURPcumu_AGHA = readmatrix([OUTPUT_folderName, 'CumSum_meanHUC2_fromgrid.txt']);
SURPcumu_AGHA = sortrows(SURPcumu_AGHA,'descend');

% Isolate 1980 and 2017
idx_1980 = find(YEARS == 1980);
idx_2017 = find(YEARS == 2017);

SURPcumu_AGHA = SURPcumu_AGHA(:,[1, idx_1980, idx_2017]);
SURPcumu_AGHA = SURPcumu_AGHA(Regions_idx,:);
SURPcumu_AGHA = sortrows(SURPcumu_AGHA,'ascend');

% Insert a column in indexes that are sequential, for plotting purposes. 
SURPcumu_AGHA = [SURPcumu_AGHA, [1:size(SURPcumu_AGHA,1)]'];
%regionID = {'9';'8';'7';'6';'5'; '4';'3';'2';'1'};
regionID = {'Region 7';'Region 6';'Region 4'};

h = barh(SURPcumu_AGHA(:,end), SURPcumu_AGHA(:,2:3)', 1);
h(1).FaceColor = [178,223,138]./255;
h(2).FaceColor = [146,195,221]./255;
h(1).EdgeColor = [108,176,48]./255;
h(2).EdgeColor = [84,160,201]./255;

% Adjusting axies
xlim([-50, 600])
a = gca;
set(a,'yticklabel',regionID)
set(a,'XMinorTick','on','YMinorTick','off')
set(a,'TickLength',[0.015, 0])
set(a,'FontSize',fontSize_p,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(a,'XColor',[0,0,0])
set(a,'YColor',[0,0,0])
set(a,'ZColor',[0,0,0])

set(gcf, 'Position',plot_dim_1)
Figfolderpath = [OUTPUT_folderName,'HUCFigures/HUC_SURPcumu_BarChart_subset.png'];
print('-dpng','-r600',[Figfolderpath])
