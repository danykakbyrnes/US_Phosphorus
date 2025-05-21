clc, clear

% Folder names and filespaths
OUTPUT_folderName = '..\OUTPUTS\';

% Filepath of files to load
QuadrantINPUTfolderName = '..\OUTPUTS\Quadrants\';
HUCINPUTfilepath = '..\OUTPUTS\HUC2\';
PUEINPUTfilepath = ['..\OUTPUTS\PUE\'];
INPUTfilepath = ['..\..\3_TREND_Nutrients\TREND_Nutrients\OUTPUT\',...
    'Grid_TREND_P_Version_1\TREND-P_Postpocessed_Gridded_2023-11-18\'];
    fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
    livestockFolder = 'Lvst_Agriculture_LU';
    agSFolder = 'Ag_Surplus';

%% Calculating metrics for the paper
fileID = fopen([OUTPUT_folderName,'ManuscriptMetrics_20250521.txt'],'w');
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'     Results (Section 3) \n'); 
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n\n']);
%% Section 3.1
% -------------------------------------------------------------------------
% Phosphorus component fluxes
% -------------------------------------------------------------------------
load([OUTPUT_folderName, 'Component_Timeseries\ComponentQuantiles.mat'])
YEAR = 1930:2017; 
idx_1977 = find(YEAR == 1977);
idx_1980 = find(YEAR == 1980);


fprintf(fileID,['3.1 Agricultural Phosphorus Usages across the ' ...
    'Contiguous United States \n']); 
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'Fertilizer \n'); 
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'FERT: National median 1930: %.2f (IQR: %.2f-%.1f) \n', ...
    Fertilizer_quantiles(3,1), ...
    Fertilizer_quantiles(2,1), ...
    Fertilizer_quantiles(4,1));
fprintf(fileID,'FERT: National median 1980: %.1f (IQR: %.1f-%.1f) \n', ...
    Fertilizer_quantiles(3,idx_1980),Fertilizer_quantiles(2,idx_1977), ...
    Fertilizer_quantiles(4,idx_1980));
fprintf(fileID,'FERT: National median 2017: %.1f (IQR: %.1f-%.1f) \n\n', ...
    Fertilizer_quantiles(3,end), ...
    Fertilizer_quantiles(2,end), ...
    Fertilizer_quantiles(4,end));

% -------------------------------------------------------------------------
% Livestock
% -------------------------------------------------------------------------
fprintf(fileID,'Manure \n'); 
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'Median manure 1930: %.1f (5th-95th: %.1f-%.1f) \n', ...
    Livestock_quantiles(3,1), ...
    Livestock_quantiles(1,1), ...
    Livestock_quantiles(5,1));
fprintf(fileID,'Median manure 1980: %.1f (5th-95th: %.1f-%.1f) \n', ...
    Livestock_quantiles(3,idx_1980), ...
    Livestock_quantiles(1,idx_1980), ...
    Livestock_quantiles(5,idx_1980));
fprintf(fileID,'Median manure 2017: %.1f (5th-95th: %.1f-%.1f) \n\n', ...
    Livestock_quantiles(3,end), ...
    Livestock_quantiles(1,end), ...
    Livestock_quantiles(5,end));

fprintf(fileID,'Crop \n');
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'Median crop uptake 1930: %.3f (IQR: %.3f-%.3f) \n', ...
    Crop_quantiles(3,1), ...
    Crop_quantiles(2,1), ...
    Crop_quantiles(4,1));
fprintf(fileID,'Median crop uptake 2017: %.3f (IQR: %.3f-%.3f) \n', ...
    Crop_quantiles(3,end), ...
    Crop_quantiles(2,end), ...
    Crop_quantiles(4,end));

%% ------------------------------------------------------------------------
% 3.2 Phosphorus use efficiency
% -------------------------------------------------------------------------
% National PUE metrics
PUE_Median_HUC2 = readtable([HUCINPUTfilepath, ...
    'PUE_medianHUC2_fromgrid.txt']);

% Regional Indexes for PUE
REG_1_idx = find(PUE_Median_HUC2.REG == 17);
REG_2_idx = find(PUE_Median_HUC2.REG == 14);
REG_3_idx = find(PUE_Median_HUC2.REG == 12);
REG_4_idx = find(PUE_Median_HUC2.REG == 10);
REG_5_idx = find(PUE_Median_HUC2.REG == 8);
REG_6_idx = find(PUE_Median_HUC2.REG == 7);
REG_7_idx = find(PUE_Median_HUC2.REG == 3);
REG_8_idx = find(PUE_Median_HUC2.REG == 2);
REG_9_idx = find(PUE_Median_HUC2.REG == 1);

fprintf(fileID,'3.2 Phosphorus use efficiency \n'); 
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']);
fprintf(fileID,'Region 6: 2017: %.3f \n', ...
    PUE_Median_HUC2{REG_6_idx, end});
fprintf(fileID,'Region 7 and 9: 2017: %.3f and %.3f \n', ...
    [PUE_Median_HUC2{REG_7_idx, end}, ...
    PUE_Median_HUC2{REG_9_idx, end}]);

fprintf(fileID,'Median PUE 2017: %.3f (IQR: %.3f-%.3f) \n\n', ...
    PUE_quantiles(3,end), ...
    PUE_quantiles(2,end), ...
    PUE_quantiles(4,end));

fprintf(fileID,'Median PUE 1930: %.3f (IQR: %.3f-%.3f) \n', ...
    PUE_quantiles(3,1), ...
    PUE_quantiles(2,1), ...
    PUE_quantiles(4,1));

fprintf(fileID,'Median PUE 1980: %.3f (IQR: %.3f-%.3f) \n', ...
    PUE_quantiles(3,idx_1980), ...
    PUE_quantiles(2,idx_1980), ...
    PUE_quantiles(4,idx_1980));

fprintf(fileID,'Median PUE 2017: %.3f (IQR: %.3f-%.3f) \n\n', ...
    PUE_quantiles(3,end), ...
    PUE_quantiles(2,end), ...
    PUE_quantiles(4,end));

fprintf(fileID,'Regional Median PUE\n\n');

fprintf(fileID,'Region 1: 1930: %.3f, 1980: %.3f, 2017: %.3f \n', ...
    PUE_Median_HUC2{REG_1_idx, [2,idx_1980+1,end]});

fprintf(fileID,'Region 2: 1930: %.3f, 1980: %.3f, 2017: %.3f \n', ...
    PUE_Median_HUC2{REG_2_idx, [2,idx_1980+1,end]});

fprintf(fileID,'Region 3: 1930: %.3f, 1980: %.3f, 2017: %.3f \n', ...
    PUE_Median_HUC2{REG_3_idx, [2,idx_1980+1,end]});

fprintf(fileID,'Region 4: 1930: %.3f, 1980: %.3f, 2017: %.3f \n', ...
    PUE_Median_HUC2{REG_4_idx, [2,idx_1980+1,end]});

fprintf(fileID,'Region 5: 1930: %.3f, 1980: %.3f, 2017: %.3f \n', ...
    PUE_Median_HUC2{REG_5_idx, [2,idx_1980+1,end]});

fprintf(fileID,'Region 6: 1930: %.3f, 1980: %.3f, 2017: %.3f \n', ...
    PUE_Median_HUC2{REG_6_idx, [2,idx_1980+1,end]});

fprintf(fileID,'Region 7: 1930: %.3f, 1980: %.3f, 2017: %.3f \n', ...
    PUE_Median_HUC2{REG_7_idx, [2,idx_1980+1,end]});

fprintf(fileID,'Region 8: 1930: %.3f, 1980: %.3f, 2017: %.3f \n', ...
    PUE_Median_HUC2{REG_8_idx, [2,idx_1980+1,end]});

fprintf(fileID,'Region 9: 1930: %.3f, 1980: %.3f, 2017: %.3f \n\n', ...
    PUE_Median_HUC2{REG_9_idx, [2,idx_1980+1,end]});

%% ------------------------------------------------------------------------
% 3.3 Annual phosphorus surplus 
% -------------------------------------------------------------------------
AgS_Median_HUC2 = readtable([HUCINPUTfilepath, ...
    'Ag_Surplus_medianHUC2Components.txt']);

% Regional Indexes for Ag Surplus
REG_1_idx = find(AgS_Median_HUC2.REG == 17);
REG_2_idx = find(AgS_Median_HUC2.REG == 14);
REG_3_idx = find(AgS_Median_HUC2.REG == 12);
REG_4_idx = find(AgS_Median_HUC2.REG == 10);
REG_5_idx = find(AgS_Median_HUC2.REG == 8);
REG_6_idx = find(AgS_Median_HUC2.REG == 7);
REG_7_idx = find(AgS_Median_HUC2.REG == 3);
REG_8_idx = find(AgS_Median_HUC2.REG == 2);
REG_9_idx = find(AgS_Median_HUC2.REG == 1);

fprintf(fileID,'3.3 Annual phosphorus surplus\n');
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'Median Ag Surplus 1930: %.3f (IQR: %.3f-%.3f) \n', ...
    AgSurplus_quantiles(3,1), ...
    AgSurplus_quantiles(2,1), ...
    AgSurplus_quantiles(4,1));
fprintf(fileID,'Median Ag Surplus 1980: %.3f (IQR: %.3f-%.3f) \n', ...
    AgSurplus_quantiles(3,idx_1980), ...
    AgSurplus_quantiles(2,idx_1980), ...
    AgSurplus_quantiles(4,idx_1980));
fprintf(fileID,'Median Ag Surplus 2017: %.3f (IQR: %.3f-%.3f) \n\n', ...
    AgSurplus_quantiles(3,end), ...
    AgSurplus_quantiles(2,end), ...
    AgSurplus_quantiles(4,end));

fprintf(fileID,'Region 5 Dec. in PS from 1980 to 2017: %.2f\n', ...
    AgS_Median_HUC2{REG_5_idx,idx_1980+1} - AgS_Median_HUC2{REG_5_idx, end});
fprintf(fileID,'Region 6 Dec. in PS from 1980 to 2017: %.2f\n\n', ...
    AgS_Median_HUC2{REG_6_idx,idx_1980+1} - AgS_Median_HUC2{REG_6_idx, end});

%% -------------------------------------------------------------------------
% 3.4 Cumulative Agricultural Surplus 
% -------------------------------------------------------------------------
% Regional Cumulative Ag surplus. The format of the text file is different
% than other files because it was run seperately.
CSfilepath =  ['..\OUTPUTS\Cumulative_Phosphorus\'];
CS_Median_HUC2 = readtable([HUCINPUTfilepath, 'CumSum_medianHUC2_fromgrid.txt']);

% Regional Indexes for PUE
REG_1_idx = find(CS_Median_HUC2.REG == 17);
REG_2_idx = find(CS_Median_HUC2.REG == 14);
REG_3_idx = find(CS_Median_HUC2.REG == 12);
REG_4_idx = find(CS_Median_HUC2.REG == 10);
REG_5_idx = find(CS_Median_HUC2.REG == 8);
REG_6_idx = find(CS_Median_HUC2.REG == 7);
REG_7_idx = find(CS_Median_HUC2.REG == 3);
REG_8_idx = find(CS_Median_HUC2.REG == 2);
REG_9_idx = find(CS_Median_HUC2.REG == 1);

AgS_REG_3_idx = find(AgS_Median_HUC2.REG == 12);
AgS_REG_6_idx = find(AgS_Median_HUC2.REG == 7);

fprintf(fileID,'3.4 Cumulative Agricultural Surplus\n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Region 7 (2017): %.1f \n', ...
    CS_Median_HUC2{REG_7_idx, end});
fprintf(fileID,'Region 8 (2017): %.1f \n', ...
    CS_Median_HUC2{REG_8_idx, end});

fprintf(fileID, 'Region 3 (2017) surplus and cumu surplus: %.2f kg/ha/y, %.2f kg/ha \n', ...
    [AgS_Median_HUC2{AgS_REG_3_idx, end}, ...
    CS_Median_HUC2{REG_3_idx, end}]);
fprintf(fileID,'Region 6 (2017) surplus and cumu surplus: %.2f kg/ha/y, %.2f kg/ha \n', ...
    [AgS_Median_HUC2{AgS_REG_6_idx, end}, ...
    CS_Median_HUC2{REG_6_idx, end}]);

% Reading in agricultural surplus 2017
[AgSurp_tif,~] = readgeoraster([INPUTfilepath,agSFolder,'\AgSurplus_2017.tif']);

% Calculating the area with negative phosphorus surplus
idx_pos = find(AgSurp_tif > 0); % Ag Surp has 0 values for non-ag land
idx_neg = find(AgSurp_tif < 0);

Neg_AgLand = length(idx_neg)/(length(idx_pos)+length(idx_neg));
Pos_AgLand = length(idx_pos)/(length(idx_pos)+length(idx_neg));

% Cumulative P Surplus in 2017
[CS_2017,~] = readgeoraster([CSfilepath,'CumSum_2017.tif']);
CS_2017_v = CS_2017(:);
CS_2017_v(isnan(CS_2017_v)) = []; % Removing all non-ag land. 

Pos_CS_2017 = sum(CS_2017_v > 0)/length(CS_2017_v)*100;
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

fprintf(fileID,'Percent of area with Positive CS 2017: %.1f \n', Pos_CS_2017);
fprintf(fileID,'Percent of area with Negative CS 2017: %.1f \n', Neg_CS_2017);
fprintf(fileID,'Percent of aPS grids with Negative aPS: %.1f %% \n', Neg_AgLand*100);
fprintf(fileID,'Percent of land with Neg aPS with positive CS in 2017: %.1f %%\n\n', Neg_AG_Pos_CS*100);

%% -------------------------------------------------------------------------
% Section 3.5 Toward a holistic approach for landscape socio-environmental evaluation
% -------------------------------------------------------------------------
load([QuadrantINPUTfolderName,'QuadrantMapping.mat']) % D
load([QuadrantINPUTfolderName,'Lvstk_Fert_Ratio_Grid.mat']) %Lvsk_Fert_Quadrant

% Cleaning the quadrant data to only include land use that hae data in it.
DisnanIDX = [(D(:,5) == 0) + (D(:,6) == 0)];
D = D(DisnanIDX < 1, :);

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

fprintf(fileID,'Section 3.5 Toward a holistic approach for landscape socio-environmental evaluation\n'); 
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