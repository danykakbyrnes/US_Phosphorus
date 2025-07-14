clc, clear, close all
% ------------------------------------------------------------------------
% MAKING REGIONAL TIMESERIES FOR FIGURE 3 and 4. 
% This uses the median components and PUE of all grid cells within the
% region.
% ------------------------------------------------------------------------
% Filepaths
loadenv(".env")
OUTPUT_folderName = getenv('REGIONAL_ANALYSIS');

%% Plot aesthetics
smoothing_int = [5 5];

fontSize_p = 9;
plot_dim = [100,100,450,400];
mSize = 36; 

colourPalette = [1,102,94;
                216,179,101; 
                 90,180,172;
                 140,81,10]./255;
c = '#007a0c';
YEARS = 1930:2017;

%% Opening files
MANURE_AGHA = readmatrix([OUTPUT_folderName, 'Lvsk_medianRegion.txt']);
MANURE_AGHA = sortrows(MANURE_AGHA,'descend');

FERT_AGHA = readmatrix([OUTPUT_folderName, 'Fert_medianRegion.txt']);
FERT_AGHA = sortrows(FERT_AGHA,'descend');

CROP_AGHA = readmatrix([OUTPUT_folderName, 'Crop_medianRegion.txt']);
CROP_AGHA = sortrows(CROP_AGHA,'descend');

% Read in land use
RegionalLU = readmatrix([OUTPUT_folderName, 'HUC2LandUse_tif.txt']);

%% Gap filling regional LU trajectories
uniqueRegions = unique(RegionalLU(:,1)); 
for i = 1:length(uniqueRegions)
    
    RegionLU_i = RegionalLU(find(RegionalLU(:,1) == uniqueRegions(i)),:);
    
    for j = 1:length(YEARS)
       YEAR_j = YEARS(j);
       
        if YEAR_j <= 1938
            % Use 1938
            LUFrac = RegionLU_i(find(RegionLU_i(:,2) == 1938),end);
            AgLand = RegionLU_i(find(RegionLU_i(:,2) == 1938),3)*(250*250)/10^4;
        elseif YEAR_j > 1938 && YEAR_j < 2006
            % Use the individual year
            LUFrac = RegionLU_i(find(RegionLU_i(:,2) == YEAR_j),end);
            AgLand = RegionLU_i(find(RegionLU_i(:,2) == YEAR_j),3)*(250*250)/10^4;
        elseif YEAR_j >= 2006 && YEAR_j < 2008
            % Use 2006
            LUFrac = RegionLU_i(find(RegionLU_i(:,2) == 2006),end);
            AgLand = RegionLU_i(find(RegionLU_i(:,2) == 2006),3)*(250*250)/10^4;
        elseif  YEAR_j >= 2008 && YEAR_j < 2011
            % Use 2008
            LUFrac = RegionLU_i(find(RegionLU_i(:,2) == 2008),end);
            AgLand = RegionLU_i(find(RegionLU_i(:,2) == 2008),3)*(250*250)/10^4;
        elseif  YEAR_j >= 2011 && YEAR_j < 2013
            % Use 2011
            LUFrac = RegionLU_i(find(RegionLU_i(:,2) == 2011),end);
            AgLand = RegionLU_i(find(RegionLU_i(:,2) == 2011),3)*(250*250)/10^4;
        elseif  YEAR_j >= 2013 && YEAR_j < 2016
            % Use 2013
            LUFrac = RegionLU_i(find(RegionLU_i(:,2) == 2013),end);
            AgLand = RegionLU_i(find(RegionLU_i(:,2) == 2013),3)*(250*250)/10^4;
        elseif  YEAR_j >= 2016
            % Use 2016
            LUFrac = RegionLU_i(find(RegionLU_i(:,2) == 2016),end);
            AgLand = RegionLU_i(find(RegionLU_i(:,2) == 2016),3)*(250*250)/10^4;
        end

    REGLU(i,1) = uniqueRegions(i);
    REGLU(i,j+1) = LUFrac;
    
    REGAgHA(i,1) = uniqueRegions(i);
    REGAgHA(i,j+1) = AgLand; % in hectares

    end
    
end

% Sort from largest Region ID to smallers 
REGLU = sortrows(REGLU,1,'descend');
REGAgHA = sortrows(REGAgHA,1,'descend');

save([OUTPUT_folderName, 'HUC2_AgLandUse.mat'],'REGLU')
save([OUTPUT_folderName, 'HUC2_AgLandUse_ha.mat'],'REGAgHA')

%% Calculating PUE and combined inputs
REG_PUE = readmatrix([OUTPUT_folderName, 'PUE_medianRegion.txt']);
REG_PUE = sortrows(REG_PUE,1,'descend');

for i = 1:height(REG_PUE)
% FIGURE 4: TIMESERIES OF PUE ACROSS REGIONS
    figure(1) 
    subplot(3,3,i)
    yyaxis right
    movmeanAGLAND = movmean(REGLU(i,2:end), smoothing_int)*100;
    X = [YEARS, fliplr(YEARS)];
    Y = [zeros(1,length(YEARS)), fliplr(movmeanAGLAND)];
    pgon = polyshape(X,Y);
   
    hold on
    plot(pgon, 'EdgeColor', 'none', 'FaceColor', c)
    ylim([0,70])
    
    box on
    set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3, ...
        {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
        {'k','k','k'});
    set(gca,'XColor',[0,0,0])
    set(gca,'YColor',[0,0,0])
    set(gca,'ZColor',[0,0,0])    

    yyaxis left
    plot([1930,2017], [1,1], ':k', 'LineWidth',0.5)
    hold on
    movmeanPUE = movmean(REG_PUE(i,2:end),smoothing_int);
    plot(YEARS, movmeanPUE, '-', 'LineWidth',2.5,'Color', '#42233A')
    plot(YEARS, movmeanPUE, '-', 'LineWidth',1, 'Color', '#8C4A7A')
    xlim([1930,2017])
    ylim([0,1.5])
    
    box on
    set(gca, 'SortMethod', 'depth')
    set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3, ...
        {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
        {'k','k','k'});
    set(gca,'XColor',[0,0,0])
    set(gca,'YColor',[0,0,0])
    set(gca,'ZColor',[0,0,0])
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca,'TickLength',[0.03, 0])

    if i == 1 | i == 4 | i == 7
        yyaxis left
        yticks([0, 0.5, 1, 1.5])
        yyaxis right
        yticks([])
    elseif i == 3 | i == 6 | i == 9
        yyaxis left
        yticks([])
        yyaxis right
        yticks([0, 35, 70])
    else
        yyaxis left
        yticks([])
        yyaxis right
        yticks([])
    end

%% FIGURE 3: MANURE, FERTILIZER, AND CROP TIMESERIES
   figure(2) 

   lineColor = [66, 94, 36;        % CROP
                101, 55, 27;       % MANURE
                58, 95, 117]./255; % FERT

   faceColor = [132, 187, 72;
                154, 108, 29;
                169, 205, 225]./255;
  
   subplot(3,3,i)
   movmeanCrop = movmean(CROP_AGHA(i,2:end), smoothing_int);
   plot(YEARS, movmeanCrop,'-k', 'LineWidth',2.5, 'Color', lineColor(1,:)) 
   hold on
   plot(YEARS, movmeanCrop,'-k', 'LineWidth',1, 'Color', faceColor(1,:)) 
   
   movmeanManure = movmean(MANURE_AGHA(i,2:end), smoothing_int);
   plot(YEARS,movmeanManure,'-k', 'LineWidth', 2.5, 'Color', lineColor(2,:)) 
   hold on
   plot(YEARS,movmeanManure,'-k', 'LineWidth',1, 'Color', faceColor(2,:)) 
   
   movmeanFertilizer = movmean(FERT_AGHA(i,2:end), smoothing_int);
   plot(YEARS, movmeanFertilizer,'-k', 'LineWidth', 2.5, 'Color', lineColor(3,:)) 
   hold on
   plot(YEARS,movmeanFertilizer,'-k', 'LineWidth', 1, 'Color', faceColor(3,:)) 
    
  if i == 1 || i == 4 || i == 7
       ylim([0, 30])
       yticks([0, 15, 30])
  else
       ylim([0, 30])
       yticks([])
   end

   set(gca,'FontSize',fontSize_p,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   set(gca,'XMinorTick','on','YMinorTick','on')
   set(gca,'TickLength',[0.03, 0])

end

figure(1)
set(gcf, 'Position',plot_dim)
Figfolderpath = [OUTPUT_folderName,'Regional_Figures/HUC_PUE_grid_panel_median.png'];
print('-dpng','-r600',[Figfolderpath])

figure(2)
set(gcf, 'Position',plot_dim)
Figfolderpath = [OUTPUT_folderName,'Regional_Figures/Component_grid_timeseries_median.png'];
print('-dpng','-r600',[Figfolderpath])