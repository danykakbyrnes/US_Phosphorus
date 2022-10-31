% ------------------------------------------------------------------------
% PHOSPHORUS USE EFFICIENCY -- Version 2
% ------------------------------------------------------------------------
% ########################################################################
clc, clear

INPUT_folderName = '../INPUTS_102122/'; 
OUTPUT_folderName = '../OUTPUTS/TREND_P_Version_1.2/';

% Read in files required
load([INPUT_folderName,'2 Livestock and Crop/AgricultureCensusData_P.mat'])
HarvestedCropland = AgrCensusData_out(find(AgrCensusData_out.ID == 1061),:);
CroplandPasture = AgrCensusData_out(find(AgrCensusData_out.ID == 1057),:);
NonCroplandPasture = AgrCensusData_out(find(AgrCensusData_out.ID == 1060),:);

% Converting Pasture back to acres. 
CroplandPasture{:,3:end} = CroplandPasture{:,3:end}./907.18474;
NonCroplandPasture{:,3:end} = NonCroplandPasture{:,3:end}./453.59;
TotalPasture = CroplandPasture;
TotalPasture{:,3:end} = [CroplandPasture{:,3:end} + NonCroplandPasture{:,3:end}];

HarvestedCropland(1,:) = []; % Removing 1929
HarvestedCropland(:,1:2) = []; % Removing code and year
TotalPasture(1,:) = []; % Removing 1929
TotalPasture(:,1:2) = [];  % Removing code and year

County_harv = HarvestedCropland.Properties.VariableNames; 
clearvars AgrCensusData_out Cv Cl_out Cl_in Cc AgrTemp

load([OUTPUT_folderName, 'Fertilizer_ag_mass.mat'])
load([OUTPUT_folderName, 'Livestock_mass.mat'])
%load([OUTPUT_folderName, 'Crop_mass.mat'])
% Crop_var = Crop_sum; 
load([OUTPUT_folderName, 'Crop_nopast_mass.mat'])
Crop_var = Crop_sum_nopast;
% Removing the CountyID x. 
for i = 1:length(County1)
    temp = County1{i};
    County_num(i) = str2num(temp(2:end)); 
    temp = County_harv{i};
    County_harvnum(i) = str2num(temp(2:end)); 
end

% Sorting the matrices so they all have the same order of counties. 
[County_num, idx] = sort(County_num);
Fert_ag = Fert_ag(:,idx);
Livestock_sum = Livestock_sum(:,idx);
Crop_var = Crop_var(:, idx); 

% Harvested area in HA
[County_harvnum, idx] = sort(County_harvnum);
HarvestedCropland_area = HarvestedCropland{:,idx}*0.404686; % acres to ha
TotalPasture_area = TotalPasture{:,idx}*0.404686; % acres to ha

% Combining all types of fertilizer
allFetilizer = Fert_ag + Livestock_sum;

Fert_ag(Fert_ag == 0) = NaN; 
Livestock_sum(Livestock_sum == 0) = NaN; 
allFetilizer(allFetilizer == 0) = NaN; 

% Open shapefiles
CountyShape = shaperead([INPUT_folderName,'0 General Data/CountyShapefiles/County_TotalArea_5070_20220902.shp']);
CountyShape = rmfield(CountyShape,{'ALAND','AWATER'});

% Calculating Metrics
PUE_infert = Crop_var./Fert_ag;
PUE_manure = Crop_var./Livestock_sum;
PUE_fert = Crop_var./allFetilizer;
Manure_Harvest = Livestock_sum./HarvestedCropland_area;
Fertilizer_Harvest = Fert_ag./HarvestedCropland_area;
Crop_Harvest = Crop_var./HarvestedCropland_area;
Comb_Harvest = (Livestock_sum+Fert_ag)./HarvestedCropland_area;

NationalPUE_all = median(PUE_fert,2,'omitnan');
NationalPUE_fert = median(PUE_infert,2,'omitnan');
NationalPUE_manure = median(PUE_manure,2,'omitnan');

IQR = quantile(PUE_fert,[0.25,0.75],2);

CountyInorganicFertPUE = CountyShape; 
CountyManurePUE = CountyShape; 
CountyFertilizerPUE = CountyShape;
HarvestedCropland = CountyShape;
PastureLand = CountyShape;
Manure_AGHA = CountyShape;
Fertilzer_AGHA = CountyShape;
Comb_AGHA = CountyShape;
Crop_AGHA = CountyShape; 

for i = 1:length(CountyShape)
    CountyNum_shp = str2num(CountyShape(i).GEOID);
    idx = find(County_num == CountyNum_shp);
    if isempty(idx)
        i
    end
    
    InorgColInsrt = [PUE_infert(:,idx)]'; 
    ManureColInsrt = [PUE_manure(:,idx)]'; 
    FertColInsrt = [PUE_fert(:,idx)]'; 
    HarvColInsrt =  [HarvestedCropland_area(:,idx)]';
    PastColInsrt =  [TotalPasture_area(:,idx)]'; 
    ManureAGHAInsrt =  [Manure_Harvest(:,idx)]'; 
    FertilizerAGHAInsrt =  [Fertilizer_Harvest(:,idx)]'; 
    CropAGHAInsrt =  [Crop_Harvest(:,idx)]'; 
    CombAGHAInsrt =  [Comb_Harvest(:,idx)]'; 
    

%     % Adding harvested area to to the shapefile
%     CountyInorganicFertPUE(i).HarvAREA_HA = HarvestedCropland(idx);
%     CountyManurePUE(i).HarvAREA_HA = HarvestedCropland(idx);  
%     CountyFertilizerPUE(i).HarvAREA_HA = HarvestedCropland(idx);
    
    for j = 1:length(InorgColInsrt)
        CountyInorganicFertPUE(i).(['Y',num2str(1929+j)]) = InorgColInsrt(j);
        CountyManurePUE(i).(['Y',num2str(1929+j)]) = ManureColInsrt(j);
        CountyFertilizerPUE(i).(['Y',num2str(1929+j)]) = FertColInsrt(j);
        HarvestedCropland(i).(['Y',num2str(1929+j)]) = HarvColInsrt(j)/(CountyShape(i).AREATOTAL/10000);
        PastureLand(i).(['Y',num2str(1929+j)]) = PastColInsrt(j)/(CountyShape(i).AREATOTAL/10000);
        Manure_AGHA(i).(['Y',num2str(1929+j)]) = ManureAGHAInsrt(j);
        Fertilzer_AGHA(i).(['Y',num2str(1929+j)]) = FertilizerAGHAInsrt(j);
        Crop_AGHA(i).(['Y',num2str(1929+j)]) = CropAGHAInsrt(j);
        Comb_AGHA(i).(['Y',num2str(1929+j)]) = CombAGHAInsrt(j);
    end
end

'Saving shapefiles'
shapewrite(CountyInorganicFertPUE,  [OUTPUT_folderName, 'PUE/Inorganic_Fert_PUE.shp'])
shapewrite(CountyManurePUE, [OUTPUT_folderName, 'PUE/Manure_PUE.shp'])
shapewrite(CountyFertilizerPUE, [OUTPUT_folderName, 'PUE/Total_PUE.shp'])
shapewrite(HarvestedCropland, [OUTPUT_folderName, 'PUE/Cropland_Fraction.shp'])
shapewrite(PastureLand, [OUTPUT_folderName, 'PUE/Pastureland_Fraction.shp'])
shapewrite(Manure_AGHA, [OUTPUT_folderName, 'PUE/Manure_AgLand.shp'])
shapewrite(Fertilzer_AGHA, [OUTPUT_folderName, 'PUE/Fertilizer_AgLand.shp'])
shapewrite(Crop_AGHA, [OUTPUT_folderName, 'PUE/Crop_AgLand.shp'])
shapewrite(Comb_AGHA, [OUTPUT_folderName, 'PUE/Comb_AgLand.shp'])

% Generating table of PUE values for plotting 
save([OUTPUT_folderName,'PUE/PUE_all.mat'],'PUE_fert','County_num')
