clc, clear, close all
% ------------------------------------------------------------------------
% MAKING HUC TIMESERIES FOR FIGURE 4. This uses the mean PUE of all 
% gridcells 
% ------------------------------------------------------------------------
smoothing_int = [5 5];

fontSize_p = 10;
plot_dim_1 = [400,400,375,280];
plot_dim_3 = [100,100,520,500];
mSize = 36; 

colourPalette = [1,102,94;
                216,179,101; 
                 90,180,172;
                 140,81,10]./255;
c = [119, 184, 136]./255;

%% Opening files
YEARS = 1930:2017;
OUTPUT_folderName = '../OUTPUTS/HUC2/';  

MANURE_AGHA = readmatrix([OUTPUT_folderName, 'Lvsk_meanHUC2Components.txt']);
MANURE_AGHA = sortrows(MANURE_AGHA,'descend');

FERT_AGHA = readmatrix([OUTPUT_folderName, 'Fert_meanHUC2Components.txt']);
FERT_AGHA = sortrows(FERT_AGHA,'descend');

CROP_AGHA = readmatrix([OUTPUT_folderName, 'Crop_meanHUC2Components.txt']);
CROP_AGHA = sortrows(CROP_AGHA,'descend');

COMB_AGHA = readmatrix([OUTPUT_folderName, 'Crop_meanHUC2Components.txt']);
COMB_AGHA = sortrows(COMB_AGHA,'descend');

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

save([OUTPUT_folderName, 'HUC2_AgLandUse.mat'],'HUCLU')
%save([OUTPUT_folderName, 'HUC2_AgLandUse_ha.mat'],'HUCAgHA')


%% Calculating PUE and combined inputs
HUC_PUE = readmatrix([OUTPUT_folderName, 'PUE_meanHUC2_fromgrid.txt']);
HUC_PUE = sortrows(HUC_PUE,1,'descend');
for i = 1:height(HUC_PUE)
% FIGURE 1: TIMESERIES OF PUE ACROSS HUC REGIONS

   figure(1) 
   subplot(3,3,i)
   
  yyaxis right % marked right but will be labeled left
   hold on
    movmeanPUE = movmean(HUC_PUE(i,2:end),smoothing_int);
    plot([1930:2017], movmeanPUE, '-k', 'LineWidth',4)
    plot([1930:2017], movmeanPUE, ':w', 'LineWidth',3)
    xlim([1930,2017])
   if i <= 6
       xticks([])
   else
       xticks([1950,2000])
   end

   box on
   set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])    

     yyaxis left
    movmeanAGLAND = movmean(HUCLU(i,2:end),smoothing_int);
    area([1930:2017]', [movmeanAGLAND]', 'LineStyle', 'none', 'FaceColor', c)
    %colororder(c)

    %hl=gca;
    %l_yaxis = hl.YTickLabel;
    yyaxis right
    %hr=gca;
    %r_yaxis = hr.YTickLabel;
    %hr.YTickLabel = l_yaxis;
    ylim([0.1,1.75])
    yticks([])

    yyaxis left
    %hl.YTickLabel = r_yaxis;
    
    ylim([0,0.75])
    yticks([]) 
    
   box on
   set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])    
   
%% FIGURE 2: MANURE INPUT VERSUS PUE

   figure(2) 
   subplot(3,3,i)
    scatter(MANURE_AGHA(i,2:end),HUC_PUE(i,2:end),mSize,[1930:2017],'filled', 'MarkerEdgeColor','k')
   
   set(gca,'FontSize',fontSize_p,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   box on
   
   if any(i == [1:6])
       ylim([0.5, 1.5])
   elseif any(i == [7:9])
       ylim([0.2, 0.8])
       yticks([0.2, 0.5, 0.8])
   end

   colormap(summer)


%% FIGURE 3: FERTILZER INPUT VERSUS PUE

   figure(3)
   subplot(3,3,i)
   scatter(FERT_AGHA(i,2:end),HUC_PUE(i,2:end),mSize,[1930:2017],'filled', 'MarkerEdgeColor','k')
   
   set(gca,'FontSize',fontSize_p,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   box on
   
   if any(i == [1:6])
       ylim([0.5, 1.5])
   elseif any(i == [7:9])
       ylim([0.2, 0.8])
       yticks([0.2, 0.5, 0.8])
   end

   colormap(summer)


%% FIGURE 4: CROP UPTAKE VERSUS PUE
   figure(4) 
   subplot(3,3,i)
   
   %figure('Renderer', 'painters', 'Position', [100 100 200 150])
    scatter(CROP_AGHA(i,2:end),HUC_PUE(i,2:end),mSize,[1930:2017],'filled', 'MarkerEdgeColor','k')
   
   set(gca,'FontSize',fontSize_p,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   box on
   colormap(summer)


%% FIGURE 5: COMBINED INPUTS VERSUS PUE

   figure(5) 
   subplot(3,3,i)

    scatter(COMB_AGHA(i,2:end),HUC_PUE(i,2:end),mSize,[1930:2017],'filled', 'MarkerEdgeColor','k')
   
   set(gca,'FontSize',fontSize_p,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   box on
   
   colormap(summer)

%% FIGURE 6: MANURE, FERTILIZER, AND CROP TIMESERIES
   figure(6) 
   color_pick = [153, 114, 14;
                 4, 166, 41; 
                 5, 19, 206]./255;
   subplot(3,3,i)
   movmeanMeanure = movmean(MANURE_AGHA(i,2:end),smoothing_int);
   plot([1930:2017],movmeanMeanure,'-k', 'LineWidth',2, 'Color',color_pick(1,:)) 
   hold on
   
   movmeanCrop = movmean(CROP_AGHA(i,2:end),smoothing_int);
   plot([1930:2017],movmeanCrop,'-k', 'LineWidth',2, 'Color',color_pick(2,:)) 
   
   movmeanFertilizer = movmean(FERT_AGHA(i,2:end),smoothing_int);
   plot([1930:2017],movmeanFertilizer,'-k', 'LineWidth',2,'Color',color_pick(3,:)) 
    
  if i == 2
       ylim([0, 30])
       yticks([0, 15, 30])
   else
       ylim([0, 20])
       yticks([0, 10, 20])
   end

   set(gca,'FontSize',10,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   
end

figure(1)
set(gcf, 'Position',plot_dim_3)
Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/HUC_PUE_grid_panel_mean.png'];
print('-dpng','-r600',[Figfolderpath])
    
% figure(2)
% set(gcf, 'Position',plot_dim_3)
% Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/LV_PUE_grid_panel_mean.png'];
% print('-dpng','-r600',[Figfolderpath])
% 
% figure(3)
% set(gcf, 'Position',plot_dim_3)
% Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/FERT_PUE_grid_panel_mean.png'];
% print('-dpng','-r600',[Figfolderpath])
% 
% figure(4)
% set(gcf, 'Position',plot_dim_3)
% Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/CROP_PUE_grid_panel_mean.png'];
% print('-dpng','-r600',[Figfolderpath])

% figure(5)
% set(gcf, 'Position',plot_dim_3)
% Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/COMB_PUE_grid_panel.png'];
% print('-dpng','-r600',[Figfolderpath])

figure(6)
set(gcf, 'Position',plot_dim_3)
Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/Component_grid_timeseries_mean.png'];
print('-dpng','-r600',[Figfolderpath])