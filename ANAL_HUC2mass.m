% ------------------------------------------------------------------------
% Total mass for each component for the HUC2
% ------------------------------------------------------------------------
% ########################################################################
clc, clear, close all

%% Aesthetics of figures

smoothing_int = [5 5];

fontSize_p = 10;
plot_dim_1 = [400,400,375,280];
plot_dim_3 = [400,400,520,500];
mSize = 36; 

colourPalette = [1,102,94;
                216,179,101; 
                 90,180,172;
                 140,81,10]./255;
c = [119, 184, 136]./255;

%% Setting up filepaths
INPUT_folderName = '../INPUTS_103122/'; 
TRENDOUTPUT_folderName = '../../3 TREND_Nutrients/TREND_Nutrients/OUTPUTS/TREND_P_Version_1.2/';
OUTPUT_folderName = '../OUTPUTS/HUC2/';  

load([TRENDOUTPUT_folderName,'Livestock_mass.mat'])
load([TRENDOUTPUT_folderName,'Fertilizer_ag_mass.mat'])
load([TRENDOUTPUT_folderName, 'Crop_mass.mat'])
load([OUTPUT_folderName, 'HUC2_AgLandUse_ha.mat'])

%% Converting the xCountyID to a number
for i = 1:length(County1)
   County1_i = County1{i};
   County_shp(i,1) = str2num(County1_i(2:end));
end

county = shaperead([INPUT_folderName, '0 General Data/countyScale/countyToHUC2.shp']);

countyCell = struct2cell(county);
unHUC = unique(countyCell(12,:));
unHUC = fliplr(unHUC);

%%
for i = 1:length(unHUC)
    
    idxCounty = find(strcmp(countyCell(12,:),  unHUC{i}));
    iCounty_ID = countyCell(8,idxCounty);
    iCounty_ID = str2num(cell2mat(iCounty_ID'));
    
    idx = ismember(County_shp,iCounty_ID);
    
    Crop_i = sum(Crop_sum(:, idx),2);
    Livestock_i = sum(Livestock_sum(:, idx),2);
    Fertilizer_i = sum(Fert_ag(:,idx),2);
        
  figure(1) 
   color_pick = [153, 114, 14;
                 4, 166, 41; 
                 5, 19, 206]./255;
   subplot(3,3,i)
   movmeanManure = movmean(Livestock_i,smoothing_int);
   plot([1930:2017],movmeanManure,'-k', 'LineWidth',2, 'Color',color_pick(1,:)) 
   hold on
   
   movmeanCrop = movmean(Crop_i,smoothing_int);
   plot([1930:2017],movmeanCrop,'-k', 'LineWidth',2, 'Color',color_pick(2,:)) 
   
   movmeanFertilizer = movmean(Fertilizer_i,smoothing_int);
   plot([1930:2017],movmeanFertilizer,'-k', 'LineWidth',2,'Color',color_pick(3,:)) 
    
%   if i == 2
%        ylim([0, 30])
%        yticks([0, 15, 30])
%    else
%        ylim([0, 20])
%        yticks([0, 10, 20])
%    end

   set(gca,'FontSize',10,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])    
    
%% 
r_idx = find(HUCAgHA(:,1) == str2num(unHUC{i}));

LU_i = HUCAgHA(r_idx,2:end);

Livestock_i = Livestock_i./LU_i';
Crop_i = Crop_i./LU_i';
Fertilizer_i = Fertilizer_i./LU_i';

   figure(2)
   subplot(3,3,i)
   movmeanManure = movmean(Livestock_i,smoothing_int);
   plot([1930:2017],movmeanManure,'-k', 'LineWidth',2, 'Color',color_pick(1,:)) 
   hold on
   
   movmeanCrop = movmean(Crop_i,smoothing_int);
   plot([1930:2017],movmeanCrop,'-k', 'LineWidth',2, 'Color',color_pick(2,:)) 
   
   movmeanFertilizer = movmean(Fertilizer_i,smoothing_int);
   plot([1930:2017],movmeanFertilizer,'-k', 'LineWidth',2,'Color',color_pick(3,:)) 
   
  if i == 2
       ylim([0, 40])
       yticks([0, 20, 40])
   else
       ylim([0, 20])
       yticks([0, 10, 20])
   end
end