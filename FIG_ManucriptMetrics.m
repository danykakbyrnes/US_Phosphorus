clc, clear

% Folder names and filespaths
OUTPUT_folderName = '..\OUTPUTS\';

% Filepath of files to load
TRENDOUTPUT_folderName = '..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\TREND_P_Version_1.2\';
QuadrantINPUTfolderName = '..\OUTPUTS\Quadrants\';
HUCINPUTfilepath = '..\OUTPUTS\HUC2\';
PUEINPUTfilepath = ['..\OUTPUTS\PUE\'];
INPUTfilepath = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUT\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded (2023-11-18)\'];
    fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
    livestockFolder = 'Lvst_Agriculture_LU';
    agSFolder = 'Ag_Surplus';

%% Calculating metrics for the paper
fileID = fopen([OUTPUT_folderName,'ManuscriptMetrics.txt'],'w');
fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'     Results (Section 3) \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');
%% Section 3.1
% -------------------------------------------------------------------------
% Section 3.1 Inputs 
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% Fertilizer 
% -------------------------------------------------------------------------
load([OUTPUT_folderName, 'Component Timeseries\ComponentQuantiles.mat']) %Fertilizer_quantiles','Crop_quantiles','','AgSurplus_quantiles')
YEAR = 1930:2017; 
idx_maxfert = find(Fertilizer_quantiles(3,:) > max(Fertilizer_quantiles(3,:)));
idx_1977 = find(YEAR == 1977);
idx_1980 = find(YEAR == 1980);
TS5_lm = fitlm([1930:2017],Fertilizer_quantiles(1,:));
TS25_lm = fitlm([1930:2017],Fertilizer_quantiles(2,:));
TS50_lm = fitlm([1930:2017],Fertilizer_quantiles(3,:));
TS75_lm = fitlm([1930:2017],Fertilizer_quantiles(4,:));
TS90_lm = fitlm([1930:2017],Fertilizer_quantiles(5,:));
TS50_lm_1980 = fitlm([1980:2017], Fertilizer_quantiles(3,idx_1980:end));

Fert_Mean_HUC2 = readtable([HUCINPUTfilepath, 'Fert_meanHUC2Components.txt']);
Lvstk_Mean_HUC2 = readtable([HUCINPUTfilepath, 'Lvsk_meanHUC2Components.txt']);
 
fprintf(fileID,'3.1 3.1 Agricultural Phosphorus Usages across the Contiguous United States \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');
fprintf(fileID,'Fertilizer \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');
fprintf(fileID,'Median fertilizer 1930: %.2f (IQR: %.2f-%.1f) \n',Fertilizer_quantiles(3,1),Fertilizer_quantiles(2,1),Fertilizer_quantiles(4,1));
fprintf(fileID,'Median fertilizer 1980: %.1f (IQR: %.1f-%.1f) \n',Fertilizer_quantiles(3,idx_1980),Fertilizer_quantiles(2,idx_1977),Fertilizer_quantiles(4,idx_1980));
fprintf(fileID,'Median fertilizer 2017: %.1f (IQR: %.1f-%.1f) \n\n',Fertilizer_quantiles(3,end),Fertilizer_quantiles(2,end),Fertilizer_quantiles(4,end));
%fprintf(fileID,'5th perc. slope: %.3f (p val = %.3f) \n',TS5_lm.Coefficients.Estimate(2), TS5_lm.Coefficients.pValue(1));
%fprintf(fileID,'25th perc. slope: %.3f (p val = %.3f) \n',TS25_lm.Coefficients.Estimate(2), TS25_lm.Coefficients.pValue(1));
%fprintf(fileID,'Median slope: %.3f (p val   = %.3f) \n',TS50_lm.Coefficients.Estimate(2), TS50_lm.Coefficients.pValue(1));
%fprintf(fileID,'75th perc. slope: %.3f (p val = %.3f) \n',TS75_lm.Coefficients.Estimate(2), TS75_lm.Coefficients.pValue(1));
%fprintf(fileID,'95th perc. slope: %.3f (p val = %.3f) \n',TS90_lm.Coefficients.Estimate(2), TS90_lm.Coefficients.pValue(1));
%fprintf(fileID,'Median slope (1980-2017): %.3f (p val   = %.3f) \n\n',TS50_lm_1980.Coefficients.Estimate(2), TS50_lm_1980.Coefficients.pValue(1));

fprintf(fileID,'Regional Mean Fertilizer \n');
fprintf(fileID,'---------------------------------------------------------------------------------------------\n');
fREGA_idx = find(Fert_Mean_HUC2.REG == 17);
fREGB_idx = find(Fert_Mean_HUC2.REG == 14);
fREGC_idx = find(Fert_Mean_HUC2.REG == 12);
fREGD_idx = find(Fert_Mean_HUC2.REG == 10);
fREGE_idx = find(Fert_Mean_HUC2.REG == 8);
fREGF_idx = find(Fert_Mean_HUC2.REG == 7);
fREGG_idx = find(Fert_Mean_HUC2.REG == 3);
fREGH_idx = find(Fert_Mean_HUC2.REG == 2);
fREGI_idx = find(Fert_Mean_HUC2.REG == 1);
fprintf(fileID,'Region (A) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Fert_Mean_HUC2{fREGA_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (B) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Fert_Mean_HUC2{fREGB_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (C) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Fert_Mean_HUC2{fREGC_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (D) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Fert_Mean_HUC2{fREGD_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (E) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Fert_Mean_HUC2{fREGE_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (F) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Fert_Mean_HUC2{fREGF_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (G) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Fert_Mean_HUC2{fREGG_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (H) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Fert_Mean_HUC2{fREGH_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (I) 1930: %.3f, 1980: %.3f, 2017: %.3f \n\n',Fert_Mean_HUC2{fREGI_idx, [2,idx_1980+1,end]});

% -------------------------------------------------------------------------
% Livestock
% -------------------------------------------------------------------------
TS5_lm = fitlm([1930:2017],Livestock_quantiles(1,:));
TS25_lm = fitlm([1930:2017],Livestock_quantiles(2,:));
TS50_lm = fitlm([1930:2017],Livestock_quantiles(3,:));
TS75_lm = fitlm([1930:2017],Livestock_quantiles(4,:));
TS90_lm = fitlm([1930:2017],Livestock_quantiles(5,:));

fprintf(fileID,'Manure \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Median manure 1930: %.1f (5th-95th: %.1f-%.1f) \n',Livestock_quantiles(3,1),Livestock_quantiles(1,1),Livestock_quantiles(5,1));
fprintf(fileID,'Median manure 1980: %.1f (5th-95th: %.1f-%.1f) \n',Livestock_quantiles(3,idx_1980),Livestock_quantiles(1,idx_1980),Livestock_quantiles(5,idx_1980));
fprintf(fileID,'Median manure 2017: %.1f (5th-95th: %.1f-%.1f) \n\n',Livestock_quantiles(3,end),Livestock_quantiles(1,end),Livestock_quantiles(5,end));
%fprintf(fileID,'5th perc. slope: %.3f (p val = %.3f) \n',TS5_lm.Coefficients.Estimate(2), TS5_lm.Coefficients.pValue(1));
%fprintf(fileID,'25th perc. slope: %.3f (p val = %.3f) \n',TS25_lm.Coefficients.Estimate(2), TS25_lm.Coefficients.pValue(1));
%fprintf(fileID,'Median slope: %.3f (p val = %.3f) \n',TS50_lm.Coefficients.Estimate(2), TS50_lm.Coefficients.pValue(1));
%fprintf(fileID,'75th perc. slope: %.3f (p val = %.3f) \n',TS75_lm.Coefficients.Estimate(2), TS75_lm.Coefficients.pValue(1));
%fprintf(fileID,'95th perc. slope: %.3f (p val = %.3f) \n\n',TS90_lm.Coefficients.Estimate(2), TS90_lm.Coefficients.pValue(1));

fprintf(fileID,'Regional Mean Manure \n');
fprintf(fileID,'---------------------------------------------------------------------------------------------\n');
mREGA_idx = find(Lvstk_Mean_HUC2.REG == 17);
mREGB_idx = find(Lvstk_Mean_HUC2.REG == 14);
mREGC_idx = find(Lvstk_Mean_HUC2.REG == 12);
mREGD_idx = find(Lvstk_Mean_HUC2.REG == 10);
mREGE_idx = find(Lvstk_Mean_HUC2.REG == 8);
mREGF_idx = find(Lvstk_Mean_HUC2.REG == 7);
mREGG_idx = find(Lvstk_Mean_HUC2.REG == 3);
mREGH_idx = find(Lvstk_Mean_HUC2.REG == 2);
mREGI_idx = find(Lvstk_Mean_HUC2.REG == 1);
fprintf(fileID,'Region (A) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Lvstk_Mean_HUC2{mREGA_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (B) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Lvstk_Mean_HUC2{mREGB_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (C) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Lvstk_Mean_HUC2{mREGC_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (D) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Lvstk_Mean_HUC2{mREGD_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (E) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Lvstk_Mean_HUC2{mREGE_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (F) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Lvstk_Mean_HUC2{mREGF_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (G) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Lvstk_Mean_HUC2{mREGG_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (H) 1930: %.3f, 1980: %.3f, 2017: %.3f \n',Lvstk_Mean_HUC2{mREGH_idx, [2,idx_1980+1,end]});
fprintf(fileID,'Region (I) 1930: %.3f, 1980: %.3f, 2017: %.3f \n\n',Lvstk_Mean_HUC2{mREGI_idx, [2,idx_1980+1,end]});


TS5_lm = fitlm([1930:2017], Crop_quantiles(1,:));
TS25_lm = fitlm([1930:2017], Crop_quantiles(2,:));
TS50_lm = fitlm([1930:2017], Crop_quantiles(3,:));
TS75_lm = fitlm([1930:2017], Crop_quantiles(4,:));
TS90_lm = fitlm([1930:2017], Crop_quantiles(5,:));

fprintf(fileID,'Crop \n');
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');
fprintf(fileID,'Median crop uptake 1930: %.3f (IQR: %.3f-%.3f) \n',Crop_quantiles(3,1),Crop_quantiles(2,1),Crop_quantiles(4,1));
fprintf(fileID,'Median crop uptake 2017: %.3f (IQR: %.3f-%.3f) \n',Crop_quantiles(3,end),Crop_quantiles(2,end),Crop_quantiles(4,end));
%fprintf(fileID,'5th perc. slope: %.3f (p val = %.3f) \n',TS5_lm.Coefficients.Estimate(2), TS5_lm.Coefficients.pValue(1));
%fprintf(fileID,'25th perc. slope: %.3f (p val = %.3f) \n',TS25_lm.Coefficients.Estimate(2), TS25_lm.Coefficients.pValue(1));
fprintf(fileID,'Median slope: %.3f (p val = %.3f) \n\n',TS50_lm.Coefficients.Estimate(2), TS50_lm.Coefficients.pValue(1));
%fprintf(fileID,'75th perc. slope: %.3f (p val = %.3f) \n',TS75_lm.Coefficients.Estimate(2), TS75_lm.Coefficients.pValue(1));
%fprintf(fileID,'95th perc. slope: %.3f (p val = %.3f) \n\n',TS90_lm.Coefficients.Estimate(2), TS90_lm.Coefficients.pValue(1));

fprintf(fileID,'Agriculture Surplus \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Median Ag Surplus 1930: %.3f (IQR: %.3f-%.3f) \n',AgSurplus_quantiles(3,1), AgSurplus_quantiles(2,1), AgSurplus_quantiles(4,1));
fprintf(fileID,'Median Ag Surplus 1980: %.3f (IQR: %.3f-%.3f) \n',AgSurplus_quantiles(3,idx_1980), AgSurplus_quantiles(2,idx_1980), AgSurplus_quantiles(4,idx_1980));
fprintf(fileID,'Median Ag Surplus 2017: %.3f (IQR: %.3f-%.3f) \n\n',AgSurplus_quantiles(3,end), AgSurplus_quantiles(2,end), AgSurplus_quantiles(4,end));

%% Calculating PUE at the gridscale.
% Reading in the three components
[Livestock_tif,~] = readgeoraster([INPUTfilepath, livestockFolder,'\Lvst_2017.tif']);
[Fertilizer_tif,~] = readgeoraster([INPUTfilepath, fertilizerFolder,'\Fertilizer_Ag_2017.tif']);
[AgSurp_tif,~] = readgeoraster([INPUTfilepath,agSFolder,'\AgSurplus_2017.tif']);

idx_pos = find(AgSurp_tif > 0); % Ag Surp has 0 values for non-ag land
idx_neg = find(AgSurp_tif < 0);

Pos_agSurp_FracLivestock = sum(Livestock_tif(idx_pos) > Fertilizer_tif(idx_pos))/size(idx_pos,1)*100;
Neg_agSurp_FracFertilizer = sum(Livestock_tif(idx_neg) < Fertilizer_tif(idx_neg))/size(idx_pos,1)*100;

Neg_AgLand = length(idx_neg)/(length(idx_pos)+length(idx_neg));
Pos_AgLand = length(idx_pos)/(length(idx_pos)+length(idx_neg));

fprintf(fileID,'Fraction of Positive Ag Surplus grids with mostly manure inputs: %.1f (mostly Fert: %.1f) \n',Pos_agSurp_FracLivestock, 100-Pos_agSurp_FracLivestock);
fprintf(fileID,'Fraction of Negative Ag Surplus grids with mostly fertilizer inputs: %.1f (mostly Manure: %.1f) \n\n',Neg_agSurp_FracFertilizer, 100-Neg_agSurp_FracFertilizer);

[PUE_1930,~] = readgeoraster([PUEINPUTfilepath,'PUE_1930.tif']);
[PUE_1980,~] = readgeoraster([PUEINPUTfilepath,'PUE_1980.tif']);
[PUE_2017,~] = readgeoraster([PUEINPUTfilepath,'PUE_2017.tif']);

fprintf(fileID,'US PUE \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Median PUE 1930: %.3f (IQR: %.3f-%.3f) \n',PUE_quantiles(3,1),PUE_quantiles(2,1),PUE_quantiles(4,1));
fprintf(fileID,'Median PUE 1980: %.3f (IQR: %.3f-%.3f) \n',PUE_quantiles(3,idx_1980),PUE_quantiles(2,idx_1980),PUE_quantiles(4,idx_1980));
fprintf(fileID,'Median PUE 2017: %.3f (IQR: %.3f-%.3f) \n\n',PUE_quantiles(3,end),PUE_quantiles(2,end),PUE_quantiles(4,end));

%% Section 3.2
% -------------------------------------------------------------------------
% Section 3.2 Phosphorus Use Efficiency and Relevant to Regional Nutrient Management
% -------------------------------------------------------------------------
PUE_HUC2 = readtable([HUCINPUTfilepath, 'PUE_medianHUC2_fromgrid.txt']);

load([HUCINPUTfilepath, 'HUC2_AgLandUse.mat']) %HUCLU
Fert_Median_HUC2 = readtable([HUCINPUTfilepath, 'Fert_medianHUC2Components.txt']);
Lvstk_Median_HUC2 = readtable([HUCINPUTfilepath, 'Lvsk_meanHUC2Components.txt']);
Crop_Median_HUC2 = readtable([HUCINPUTfilepath, 'Crop_meanHUC2Components.txt']);
% Region 17 = Region A
% Region 14 = Region B
% Region 12 = Region C
% Region 10 = Region D
% Region 8 = Region E
% Region 7 = Region F
% Region 3 = Region G
% Region 2 = Region H
% Region 1 = Region I

% Region A-D
Reg_AC = [17, 14, 12];
RegionAC_LU = HUCLU(ismember(HUCLU(:,1), Reg_AC),[2:end]);
RegionAC_Crop = Crop_Median_HUC2{ismember(Crop_Median_HUC2{:,1}, Reg_AC),[2:end]};
RegionAC_Fert = Fert_Median_HUC2{ismember(Fert_Median_HUC2{:,1}, Reg_AC),[2:end]};
RegionAC_Lvstk = Lvstk_Median_HUC2{ismember(Lvstk_Median_HUC2{:,1}, Reg_AC),[2:end]};

% Region D-F
Reg_DF = [10, 8, 7];
RegionDF_LU = HUCLU(ismember(HUCLU(:,1), Reg_DF),[2:end]);
RegionDF_Crop = Crop_Median_HUC2{ismember(Crop_Median_HUC2{:,1}, Reg_DF),[2:end]};
RegionDF_Fert = Fert_Median_HUC2{ismember(Fert_Median_HUC2{:,1}, Reg_DF),[2:end]};
RegionDF_Lvstk = Lvstk_Median_HUC2{ismember(Lvstk_Median_HUC2{:,1}, Reg_DF),[2:end]};
RegionDF_Mean_LU_1930_2017 =  mean([RegionDF_LU(:,1),RegionDF_LU(:,end)]);
RegionDF_Min_LU_1930_2017 =  min(min(RegionDF_LU));

% Region G-H
Reg_GH = [3, 2];
RegionGH_LU = HUCLU(ismember(HUCLU(:,1), Reg_GH),[2:end]);
RegionGH_Crop = Crop_Median_HUC2{ismember(Crop_Median_HUC2{:,1}, Reg_GH),[2:end]};
RegionGH_Fert = Fert_Median_HUC2{ismember(Fert_Median_HUC2{:,1}, Reg_GH),[2:end]};
RegionGH_Lvstk = Lvstk_Median_HUC2{ismember(Lvstk_Median_HUC2{:,1}, Reg_GH),[2:end]};

% Region I
Reg_I = 1;
RegionI_LU = HUCLU(HUCLU(:,1) == Reg_I,[2:end]);
RegionI_Crop = Crop_Median_HUC2{ismember(Crop_Median_HUC2{:,1}, Reg_I),[2:end]};
RegionI_Fert = Fert_Median_HUC2{ismember(Fert_Median_HUC2{:,1}, Reg_I),[2:end]};
RegionI_Lvstk = Lvstk_Median_HUC2{ismember(Lvstk_Median_HUC2{:,1}, Reg_I),[2:end]};

RegionI_LU_1930_2017 = [RegionI_LU(1),RegionI_LU(end)];

fprintf(fileID,'Regional PUE and Components \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Region D-F Minumum Ag Land: %.1f\n', RegionDF_Min_LU_1930_2017*100);
fprintf(fileID,'Region I Ag Land: %.3f and %.3f \n\n', RegionI_LU_1930_2017*100);

% -------------------------------------------------------------------------
% Section 3.2.3 Cumulative Phosphorus Surplus
% -------------------------------------------------------------------------
CSfilepath =  ['..\OUTPUTS\Cumulative Phosphorus\'];
CS_HUC2 = readtable([HUCINPUTfilepath, 'CumSum_meanHUC2_fromgrid.txt']);

Neg_AgLand = length(idx_neg)/(length(idx_pos)+length(idx_neg));
Pos_AgLand = length(idx_pos)/(length(idx_pos)+length(idx_neg));

% Nationally Cumuliative P Surplus in 1980 and 2017

[CS_1980,~] = readgeoraster([CSfilepath,'CumSum_1980.tif']);
[CS_2017,~] = readgeoraster([CSfilepath,'CumSum_2017.tif']);

CS_1980_v = CS_1980(:);
CS_1980_v(isnan(CS_1980_v)) = []; % Removing all non-ag land. 
CS_2017_v = CS_2017(:);
CS_2017_v(isnan(CS_2017_v)) = []; % Removing all non-ag land. 

Pos_CS_1980 = sum(CS_1980_v > 0)/length(CS_1980_v)*100;
Pos_CS_2017 = sum(CS_2017_v > 0)/length(CS_2017_v)*100;
Neg_CS_1980 = sum(CS_1980_v < 0)/length(CS_1980_v)*100;
Neg_CS_2017 = sum(CS_2017_v < 0)/length(CS_2017_v)*100;

% For the fraction of land with negative CS, we want to just look at the
% year's productive land. Therefore, we want to remove all CS values that
% aren't in current year's production.
AgSurp_tif_v = AgSurp_tif(:);
CS_2017_v = CS_2017(:); 
idx = isnan(AgSurp_tif_v) + AgSurp_tif_v == 0; % Index for non-ag land and external US boundary land.
% Removing all grid cells that are not 2017 agricultural land. 
AgSurp_tif_v(idx) = [];
CS_2017_v(idx) = [];

% Finding the grids with negative PS and positive CS. 
binary_CS_2017 = CS_2017_v > 0;
binary_AgS_2017 = AgSurp_tif_v < 0;

% Adding them together, cell = 2, conditions are met.
binary_AgS_CS_2017 = binary_CS_2017 + binary_AgS_2017;

% Fraction of agricultural land that has negative CS and PS
Neg_AG_Pos_CS = sum(binary_AgS_CS_2017 == 2)./sum(binary_AgS_2017);

% Region 17 = Region A
% Region 14 = Region B
% Region 12 = Region C
% Region 10 = Region D
% Region 8 = Region E
% Region 7 = Region F
% Region 3 = Region G
% Region 2 = Region H
% Region 1 = Region I

fREGA_idx = find(CS_HUC2.REG == 17);
fREGB_idx = find(CS_HUC2.REG == 14);
fREGC_idx = find(CS_HUC2.REG == 12);
fREGD_idx = find(CS_HUC2.REG == 10);
fREGE_idx = find(CS_HUC2.REG == 8);
fREGF_idx = find(CS_HUC2.REG == 7);
fREGG_idx = find(CS_HUC2.REG == 3);
fREGH_idx = find(CS_HUC2.REG == 2);
fREGI_idx = find(CS_HUC2.REG == 1);

fprintf(fileID,'Regional Cumultive P Surplus \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Percent of area with Positive CS in 1980 and 2017: %.1f and %.1f \n', Pos_CS_1980, Pos_CS_2017);
fprintf(fileID,'Percent of area with Negative CS in 1980 and 2017: %.1f and %.1f \n', Neg_CS_1980, Neg_CS_2017);
fprintf(fileID,'Percent of aPS grids with Negative aPS: %.1f %% \n', Neg_AgLand*100);
fprintf(fileID,'Percent of Neg Ag land with positive CS in 2017: %.1f %%\n\n', Neg_AG_Pos_CS*100);

fprintf(fileID,'Region A (1980, 2017): %.3f and %.3f \n', CS_HUC2{fREGA_idx, [idx_1980+1, end]});
fprintf(fileID,'Region B (1980, 2017): %.3f and %.3f \n', CS_HUC2{fREGB_idx, [idx_1980+1, end]});
fprintf(fileID,'Region C (1980, 2017): %.3f and %.3f \n', CS_HUC2{fREGC_idx, [idx_1980+1, end]});
fprintf(fileID,'Region D (1980, 2017): %.3f and %.3f \n', CS_HUC2{fREGD_idx, [idx_1980+1, end]});
fprintf(fileID,'Region E (1980, 2017): %.3f and %.3f \n', CS_HUC2{fREGE_idx, [idx_1980+1, end]});
fprintf(fileID,'Region F (1980, 2017): %.3f and %.3f \n', CS_HUC2{fREGF_idx, [idx_1980+1, end]});
fprintf(fileID,'Region G (1980, 2017): %.3f and %.3f \n', CS_HUC2{fREGG_idx, [idx_1980+1, end]});
fprintf(fileID,'Region H (1980, 2017): %.3f and %.3f \n', CS_HUC2{fREGH_idx, [idx_1980+1, end]});
fprintf(fileID,'Region I (1980, 2017): %.3f and %.3f \n', CS_HUC2{fREGI_idx, [idx_1980+1, end]});


%% Section 3.2
% -------------------------------------------------------------------------
% Section 3.2 Limitations of Single Metrics in Landscape Socioeconomic and Environmental Analysis
% -------------------------------------------------------------------------

%% Section 3.3
% -------------------------------------------------------------------------
% Section 3.3 3.3 Toward a Holistic Approach for Landscape Socio-Environmental Evaluation
% -------------------------------------------------------------------------

load([QuadrantINPUTfolderName,'QuadrantMapping.mat']) % D
load([QuadrantINPUTfolderName,'Lvstk_Fert_Ratio_Grid.mat']) %Lvsk_Fert_Quadrant

D(D(:,5) == 0,:) = [];
D(D(:,6) == 0,:) = [];

Q2_1980 = D(find(D(:,5) == 2),:);
Q2_Q1 = D(find(D(:,5) == 2 & D(:,6) == 1),:);
Q2_Q2 = D(find(D(:,5) == 2 & D(:,6) == 2),:);

Perc_D2_D1 = size(Q2_Q1,1)/size(Q2_1980,1);
Perc_D2_D2 = size(Q2_Q2,1)/size(Q2_1980,1);

TotalNumelLand_1980 = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.QYear == 1980,:);
TotalNumelLand_2017 = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.QYear == 2017,:);

% Quadrant 1
Q1_LF_Quadrant = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.Q == 1,:);
Q1_LF_Quadrant_1980 = Q1_LF_Quadrant(Q1_LF_Quadrant.QYear == 1980,:).LvstkFertFract;
Q1_LF_Quadrant_2017 = Q1_LF_Quadrant(Q1_LF_Quadrant.QYear == 2017,:).LvstkFertFract;
Q1_frac_1980 = height(Q1_LF_Quadrant_1980)/height(TotalNumelLand_1980);
Q1_frac_2017 = height(Q1_LF_Quadrant_2017)/height(TotalNumelLand_2017);
Q1_ManureFert_1980 = quantile(Q1_LF_Quadrant_1980,[0.5, 0.25, 0.75]);
Q1_ManureFert_2017 = quantile(Q1_LF_Quadrant_2017,[0.5, 0.25, 0.75]);

% Quadrant 2
Q2_LF_Quadrant = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.Q == 2,:);
Q2_LF_Quadrant_1980 = Q2_LF_Quadrant(Q2_LF_Quadrant.QYear == 1980,:).LvstkFertFract;
Q2_LF_Quadrant_2017 = Q2_LF_Quadrant(Q2_LF_Quadrant.QYear == 2017,:).LvstkFertFract;
Q2_frac = height(Q2_LF_Quadrant)/height(Lvsk_Fert_Quadrant);
Q2_frac_1980 = height(Q2_LF_Quadrant_1980)/height(TotalNumelLand_1980);
Q2_frac_2017 = height(Q2_LF_Quadrant_2017)/height(TotalNumelLand_2017);
Q2_ManureFert_1980 = quantile(Q2_LF_Quadrant_1980,[0.5, 0.25, 0.75]);
Q2_ManureFert_2017 = quantile(Q2_LF_Quadrant_2017,[0.5, 0.25, 0.75]);

% Quadrant 3
Q3_LF_Quadrant = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.Q == 3,:);
Q3_LF_Quadrant_1980 = Q3_LF_Quadrant(Q3_LF_Quadrant.QYear == 1980,:).LvstkFertFract;
Q3_LF_Quadrant_2017 = Q3_LF_Quadrant(Q3_LF_Quadrant.QYear == 2017,:).LvstkFertFract;
Q3_frac_1980 = height(Q3_LF_Quadrant_1980)/height(TotalNumelLand_1980);
Q3_frac_2017 = height(Q3_LF_Quadrant_2017)/height(TotalNumelLand_2017);
Q3_ManureFert_1980 = quantile(Q3_LF_Quadrant_1980,[0.5, 0.25, 0.75]);
Q3_ManureFert_2017 = quantile(Q3_LF_Quadrant_2017,[0.5, 0.25, 0.75]);

% Quadrant 4
Q4_LF_Quadrant = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.Q == 4,:);
Q4_LF_Quadrant_1980 = Q4_LF_Quadrant(Q4_LF_Quadrant.QYear == 1980,:).LvstkFertFract;
Q4_LF_Quadrant_2017 = Q4_LF_Quadrant(Q4_LF_Quadrant.QYear == 2017,:).LvstkFertFract;
Q4_frac_1980 = height(Q4_LF_Quadrant_1980)/height(TotalNumelLand_1980);
Q4_frac_2017 = height(Q4_LF_Quadrant_2017)/height(TotalNumelLand_2017);
Q4_ManureFert_1980 = quantile(Q4_LF_Quadrant_1980,[0.5, 0.25, 0.75]);
Q4_ManureFert_2017 = quantile(Q4_LF_Quadrant_2017,[0.5, 0.25, 0.75]);

fprintf(fileID,'3.3 PUE + Cumulative Surplus \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Q1 Fraction 1980 and 2017: %.3f and %.3f \n', Q1_frac_1980, Q1_frac_2017)
fprintf(fileID,'Q2 Fraction 1980 and 2017: %.3f and %.3f \n', Q2_frac_1980, Q2_frac_2017)
fprintf(fileID,'Q3 Fraction 1980 and 2017: %.3f and %.3f \n', Q3_frac_1980, Q3_frac_2017)
fprintf(fileID,'Q4 Fraction 1980 and 2017: %.3f and %.3f \n\n', Q4_frac_1980, Q4_frac_2017)

fprintf(fileID,'Fraction of Q2 going to Q1 in 2017 %.1f%% \n', Perc_D2_D1*100)
fprintf(fileID,'Fraction of Q2 going to Q2 in 2017 %.1f%% \n', Perc_D2_D2*100)

fprintf(fileID,'Q1 Median Manure Fraction 1980: %.2f (IQR = %.2f - %.2f)\n', Q1_ManureFert_1980*100)
fprintf(fileID,'Q1 Median Manure Fraction 2017: %.2f (IQR = %.2f - %.2f)\n', Q1_ManureFert_2017*100)
fprintf(fileID,'Q2 Median Manure Fraction 1980: %.2f (IQR = %.2f - %.2f)\n', Q2_ManureFert_1980*100)
fprintf(fileID,'Q2 Median Manure Fraction 2017: %.2f (IQR = %.2f - %.2f)\n', Q2_ManureFert_2017*100)
fprintf(fileID,'Q3 Median Manure Fraction 1980: %.2f (IQR = %.2f - %.2f)\n', Q3_ManureFert_1980*100)
fprintf(fileID,'Q3 Median Manure Fraction 2017: %.2f (IQR = %.2f - %.2f)\n', Q3_ManureFert_2017*100)
fprintf(fileID,'Q4 Median Manure Fraction 1980: %.2f (IQR = %.2f - %.2f)\n', Q4_ManureFert_1980*100)
fprintf(fileID,'Q4 Median Manure Fraction 2017: %.2f (IQR = %.2f - %.2f)\n', Q4_ManureFert_2017*100)

fclose(fileID);