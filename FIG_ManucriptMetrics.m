clc, clear

% Folder names and filespaths
OUTPUT_folderName = getenv('OUTPUT');

% Filepath of files to load
QuadrantINPUT_folderName = getenv('QUADRANT_ANALYSIS');
RegionalINPUT_filepath = getenv('REGIONAL_ANALYSIS');
PUEINPUT_filepath = getenv('PHOS_USE_EFFICIENCY');
TRENDfilepath = getenv('POSTPROCESSED_TREND');
CUMSUM_folderName = getenv('CUMULATIVE_PHOS');

fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
livestockFolder = 'Lvst_Agriculture_LU';
agSFolder = 'Ag_Surplus';

%% Calculating metrics for the paper
fileID = fopen([OUTPUT_folderName,'ManuscriptMetrics.txt'],'w');
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
idx_1980 = find(YEAR == 1980);


fprintf(fileID,['3.1 Agricultural Phosphorus Usages across the ' ...
    'Contiguous United States \n']); 
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'Fertilizer \n'); 
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'FERT - National median 1930: %.2f (IQR: %.2f-%.1f) \n', ...
    Fertilizer_quantiles(3,1), ...
    Fertilizer_quantiles(2,1), ...
    Fertilizer_quantiles(4,1));
fprintf(fileID,'FERT - National median peaked in %.4d: %.3f (IQR: %.3f-%.3f) \n', ...
    YEAR(find(Fertilizer_quantiles(3,:) == max(Fertilizer_quantiles(3,:)))),...
    Fertilizer_quantiles(3,find(Fertilizer_quantiles(3,:) == max(Fertilizer_quantiles(3,:)))), ...
    Fertilizer_quantiles(2,find(Fertilizer_quantiles(3,:) == max(Fertilizer_quantiles(3,:)))), ...
    Fertilizer_quantiles(4,find(Fertilizer_quantiles(3,:) == max(Fertilizer_quantiles(3,:)))));
fprintf(fileID,'FERT - National median 1980: %.1f (IQR: %.1f-%.1f) \n', ...
    Fertilizer_quantiles(3,idx_1980),Fertilizer_quantiles(2,idx_1980), ...
    Fertilizer_quantiles(4,idx_1980));
fprintf(fileID,'FERT - National median 2017: %.1f (IQR: %.1f-%.1f) \n\n', ...
    Fertilizer_quantiles(3,end), ...
    Fertilizer_quantiles(2,end), ...
    Fertilizer_quantiles(4,end));
% -------------------------------------------------------------------------
% Crop
% -------------------------------------------------------------------------
fprintf(fileID,'Crop \n');
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'CROP - National median 1930: %.1f (IQR: %.3f-%.3f) \n', ...
    Crop_quantiles(3,1), ...
    Crop_quantiles(2,1), ...
    Crop_quantiles(4,1));
fprintf(fileID,'CROP - National median  2017: %.1f (IQR: %.3f-%.3f) \n\n', ...
    Crop_quantiles(3,end), ...
    Crop_quantiles(2,end), ...
    Crop_quantiles(4,end));

% -------------------------------------------------------------------------
% Livestock
% -------------------------------------------------------------------------
fprintf(fileID,'Manure \n'); 
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'MANU - National median 1930: %.1f (5th-95th: %.1f-%.1f) \n', ...
    Livestock_quantiles(3,1), ...
    Livestock_quantiles(1,1), ...
    Livestock_quantiles(5,1));
fprintf(fileID,'MANU - National median 1980: %.1f (5th-95th: %.1f-%.1f) \n', ...
    Livestock_quantiles(3,idx_1980), ...
    Livestock_quantiles(1,idx_1980), ...
    Livestock_quantiles(5,idx_1980));
fprintf(fileID,'MANU - National median 2017: %.1f (5th-95th: %.1f-%.1f) \n\n', ...
    Livestock_quantiles(3,end), ...
    Livestock_quantiles(1,end), ...
    Livestock_quantiles(5,end));

%% ------------------------------------------------------------------------
% 3.2 Phosphorus use efficiency
% -------------------------------------------------------------------------
% National PUE metrics
PUE_Median_Region = readtable([RegionalINPUT_filepath, ...
    'PUE_medianRegion.txt']);

% Regional Indexes for PUE
REG_1_idx = find(PUE_Median_Region.REG == 1);
REG_2_idx = find(PUE_Median_Region.REG == 2);
REG_3_idx = find(PUE_Median_Region.REG == 3);
REG_4_idx = find(PUE_Median_Region.REG == 4);
REG_5_idx = find(PUE_Median_Region.REG == 5);
REG_6_idx = find(PUE_Median_Region.REG == 6);
REG_7_idx = find(PUE_Median_Region.REG == 7);
REG_8_idx = find(PUE_Median_Region.REG == 8);
REG_9_idx = find(PUE_Median_Region.REG == 9);

fprintf(fileID,'3.2 Phosphorus use efficiency \n'); 
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']);
fprintf(fileID,'Region 6: 2017: %.3f \n', ...
    PUE_Median_Region{REG_6_idx, end});
fprintf(fileID,'Region 7, 8 and 9: 2017: %.1f, %.1f, and %.1f \n', ...
    [PUE_Median_Region{REG_7_idx, end}, ...
    PUE_Median_Region{REG_8_idx, end}, ...
    PUE_Median_Region{REG_9_idx, end}]);

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

fprintf(fileID,'Region 7 2017 PUE: %.3f \n', ...
    PUE_Median_Region{REG_7_idx, end});

fprintf(fileID,'Region 8 2017 PUE: %.3f \n', ...
    PUE_Median_Region{REG_8_idx, end});

fprintf(fileID,'Region 2 2017 PUE: %.3f \n', ...
    PUE_Median_Region{REG_2_idx, end});

fprintf(fileID,'Region 3 2017 PUE: %.3f \n', ...
    PUE_Median_Region{REG_3_idx, end});
%% ------------------------------------------------------------------------
% 3.3 Annual phosphorus surplus 
% -------------------------------------------------------------------------
AgS_Median_Region = readtable([RegionalINPUT_filepath, ...
    'Ag_Surplus_medianRegion.txt']);

% Regional Indexes for Ag Surplus
REG_1_idx = find(AgS_Median_Region.REG == 1);
REG_2_idx = find(AgS_Median_Region.REG == 2);
REG_3_idx = find(AgS_Median_Region.REG == 3);
REG_4_idx = find(AgS_Median_Region.REG == 4);
REG_5_idx = find(AgS_Median_Region.REG == 5);
REG_6_idx = find(AgS_Median_Region.REG == 6);
REG_7_idx = find(AgS_Median_Region.REG == 7);
REG_8_idx = find(AgS_Median_Region.REG == 8);
REG_9_idx = find(AgS_Median_Region.REG == 9);

fprintf(fileID,'3.3 Annual phosphorus surplus\n');
fprintf(fileID,['----------------------------------------------------' ...
    '-----------------------------------------\n']); 
fprintf(fileID,'Median Ag Surplus 1930: %.3f (IQR: %.3f-%.3f) \n', ...
    AgSurplus_quantiles(3,1), ...
    AgSurplus_quantiles(2,1), ...
    AgSurplus_quantiles(4,1));
fprintf(fileID,'Median Ag Surplus Peaked in %.4d: %.3f (IQR: %.3f-%.3f) \n', ...
    YEAR(find(AgSurplus_quantiles(3,:) == max(AgSurplus_quantiles(3,:)))),...
    AgSurplus_quantiles(3,find(AgSurplus_quantiles(3,:) == max(AgSurplus_quantiles(3,:)))), ...
    AgSurplus_quantiles(2,find(AgSurplus_quantiles(3,:) == max(AgSurplus_quantiles(3,:)))), ...
    AgSurplus_quantiles(4,find(AgSurplus_quantiles(3,:) == max(AgSurplus_quantiles(3,:)))));
fprintf(fileID,'Median Ag Surplus 2017: %.3f (IQR: %.3f-%.3f) \n\n', ...
    AgSurplus_quantiles(3,end), ...
    AgSurplus_quantiles(2,end), ...
    AgSurplus_quantiles(4,end));

fprintf(fileID,'Region 5 Dec. in PS from 1980 to 2017: %.2f\n', ...
    AgS_Median_Region{REG_5_idx,idx_1980+1} - AgS_Median_Region{REG_5_idx, end});
fprintf(fileID,'Region 6 Dec. in PS from 1980 to 2017: %.2f\n\n', ...
    AgS_Median_Region{REG_6_idx,idx_1980+1} - AgS_Median_Region{REG_6_idx, end});

%% -------------------------------------------------------------------------
% 3.4 Cumulative Agricultural Surplus 
% -------------------------------------------------------------------------
% Regional Cumulative Ag surplus. The format of the text file is different
% than other files because it was run seperately.
CS_Median_Region = readtable([RegionalINPUT_filepath, 'CumSum_medianRegion.txt']);

% Regional Indexes for PUE
REG_1_idx = find(CS_Median_Region.REG == 1);
REG_2_idx = find(CS_Median_Region.REG == 2);
REG_3_idx = find(CS_Median_Region.REG == 3);
REG_4_idx = find(CS_Median_Region.REG == 4);
REG_5_idx = find(CS_Median_Region.REG == 5);
REG_6_idx = find(CS_Median_Region.REG == 6);
REG_7_idx = find(CS_Median_Region.REG == 7);
REG_8_idx = find(CS_Median_Region.REG == 8);
REG_9_idx = find(CS_Median_Region.REG == 9);

AgS_REG_3_idx = find(AgS_Median_Region.REG == 12);
AgS_REG_6_idx = find(AgS_Median_Region.REG == 7);

fprintf(fileID,'3.4 Cumulative Agricultural Surplus\n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Region 7 (2017): %.1f \n', ...
    CS_Median_Region{REG_7_idx, end});
fprintf(fileID,'Region 8 (2017): %.1f \n', ...
    CS_Median_Region{REG_8_idx, end});

fprintf(fileID, 'Region 3 (2017) surplus and cumu surplus: %.2f kg/ha/y, %.2f kg/ha \n', ...
    [AgS_Median_Region{AgS_REG_3_idx, end}, ...
    CS_Median_Region{REG_3_idx, end}]);
fprintf(fileID,'Region 6 (2017) surplus and cumu surplus: %.2f kg/ha/y, %.2f kg/ha \n', ...
    [AgS_Median_Region{AgS_REG_6_idx, end}, ...
    CS_Median_Region{REG_6_idx, end}]);

% Reading in agricultural surplus 2017
[AgSurp_tif,~] = readgeoraster([TRENDfilepath,agSFolder,'\AgSurplus_2017.tif']);

% Calculating the area with negative phosphorus surplus
idx_pos = find(AgSurp_tif > 0); % Ag Surp has 0 values for non-ag land
idx_neg = find(AgSurp_tif < 0);

Neg_AgLand = length(idx_neg)/(length(idx_pos)+length(idx_neg));
Pos_AgLand = length(idx_pos)/(length(idx_pos)+length(idx_neg));

% Cumulative P Surplus in 2017
[CS_2017,~] = readgeoraster([CUMSUM_folderName,'CumSum_2017.tif']);
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

% Finding the grids with Ag surplus data, with negative PS and positive CS. 
binary_CS_2017 = CS_2017_v > 0;
binary_AgS_2017 = AgSurp_tif_v < 0;

% Adding them together, cell = 2, conditions are met.
binary_AgS_CS_2017 = binary_CS_2017 + binary_AgS_2017;

% Fraction of agricultural land that has negative CS and PS
Neg_AG_Pos_CS = sum(binary_AgS_CS_2017 == 2)./sum(binary_AgS_2017);

fprintf(fileID,'Percent of area with CS with Positive CS 2017: %.1f \n', Pos_CS_2017);
fprintf(fileID,'Percent of area with CS with Negative CS 2017: %.1f \n', Neg_CS_2017);
fprintf(fileID,'Percent of aPS grids with Negative aPS: %.1f %% \n', Neg_AgLand*100);
fprintf(fileID,'Percent of land with Neg aPS with positive CS in 2017: %.1f %%\n\n', Neg_AG_Pos_CS*100);

%% -------------------------------------------------------------------------
% Section 3.5 Toward a holistic approach for landscape socio-environmental evaluation
% -------------------------------------------------------------------------
load([QuadrantINPUT_folderName,'QuadrantMapping.mat']) % D
Reg_Quadrants = readmatrix([QuadrantINPUT_folderName,'Regional_Quadrants_2017.txt']);
% Cleaning the quadrant data to only include land use that hae data in it.
DisnanIDX = isnan(D(:,3)) + isnan(D(:,4));
leaveOut = D(DisnanIDX ~= 0, :);
D = D(DisnanIDX == 0, :);

% Calculating the quadrant changes based on total land in 1980
quadrantChangeMatrix = zeros(4,4);
for i = 1:4  % 2017 quadrants (rows)
    for j = 1:4  % 1980 quadrants (columns)
        quadrantChangeMatrix(i,j) = sum(D(:,7) == j & D(:,8) == i);
        
        % Proportion of each 1980 quadrant moved to each 2017 quadrant 
        % quadrantChangeMatrix(i,j) = (sum(D(:,7) == j & D(:,8) == i) ...
        %    ./sum(D(:,7) == j))*100;
    end
end
total_1980_cells = size(D, 1);  % Total number of grid cells in 1980
quadrantChangeMatrix = (quadrantChangeMatrix ./ total_1980_cells) * 100;

Q2_Q1_med_2017 = median(D(find(D(:,7) == 2 & D(:,8) == 1),6));
Q2_Q2_med_2017 = median(D(find(D(:,7) == 2 & D(:,8) == 2),6));

Q3_Q1_med_2017 = median(D(find(D(:,7) == 3 & D(:,8) == 1),6));
Q3_Q2_med_2017 = median(D(find(D(:,7) == 3 & D(:,8) == 2),6));
Q3_Q3_med_2017 = median(D(find(D(:,7) == 3 & D(:,8) == 3),6));
Q3_Q4_med_2017 = median(D(find(D(:,7) == 3 & D(:,8) == 4),6));

Q1_Q1_med_2017 = median(D(find(D(:,7) == 1 & D(:,8) == 1),6));
Q1_Q2_med_2017 = median(D(find(D(:,7) == 1 & D(:,8) == 2),6));
Q1_Q4_med_2017 = median(D(find(D(:,7) == 1 & D(:,8) == 4),6));

Q4_Q2_med_2017 = median(D(find(D(:,7) == 4 & D(:,8) == 2),6));
Q4_Q3_med_2017 = median(D(find(D(:,7) == 4 & D(:,8) == 3),6));
Q4_Q4_med_2017 = median(D(find(D(:,7) == 4 & D(:,8) == 4),6));

Q1_frac_1980 = length(D(find(D(:,7) == 1)))./size(D,1)*100;
Q1_frac_2017 = length(D(find(D(:,8) == 1)))./size(D,1)*100;

Q2_frac_1980 = length(D(find(D(:,7) == 2)))./size(D,1)*100;
Q2_frac_2017 = length(D(find(D(:,8) == 2)))./size(D,1)*100;

Q3_frac_1980 = length(D(find(D(:,7) == 3)))./size(D,1)*100;
Q3_frac_2017 = length(D(find(D(:,8) == 3)))./size(D,1)*100;

Q4_frac_1980 = length(D(find(D(:,7) == 4)))./size(D,1)*100;
Q4_frac_2017 = length(D(find(D(:,8) == 4)))./size(D,1)*100;

fprintf(fileID,'Section 3.5 Toward a holistic approach for landscape socio-environmental evaluation\n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Q2 Fraction in 2017: %.3f \n', Q2_frac_2017);
fprintf(fileID,'Q1 Fraction on 2017: %.3f \n', Q1_frac_2017);
fprintf(fileID, 'Q4 proportion in Arid West (Reg 2) and Lower Miss. (Reg 5): %.3f and %.3f \n', Reg_Quadrants(2,5)/Reg_Quadrants(2,6), ...
    Reg_Quadrants(5,5)./Reg_Quadrants(5,6));
fprintf(fileID, 'Q3 proportion in Northern Plains (Reg 4): %.3f \n\n', Reg_Quadrants(4,4)./Reg_Quadrants(4,6));

fprintf(fileID,'Q2 Fraction in 1980 and 2017: %.3f \n', Q2_frac_1980, Q2_frac_2017);
fprintf(fileID,'Q1 Fraction in 1980 and 2017: %.3f \n', Q1_frac_1980, Q1_frac_2017);
fprintf(fileID,'Land going from Q2 to Q1: %.1f%% \n\n', quadrantChangeMatrix(1,2));
fprintf(fileID,'Propor. of MAN-derived P inputs in Q2 -> Q2: %.1f%% \n', Q2_Q2_med_2017);
fprintf(fileID,'Propor. of MAN-derived P inputs in Q1 -> Q2: %.1f%% \n\n', Q1_Q2_med_2017);

fprintf(fileID,'Q3 Fraction 1980 and 2017: %.3f and %.3f \n', Q3_frac_1980, Q3_frac_2017);
fprintf(fileID,'Land going from Q3 to Q2: %.1f%% \n', quadrantChangeMatrix(2,3));
fprintf(fileID,'Propor. of FERT-derived P inputs in Q3 -> Q2: %.1f%% \n', 1-Q3_Q2_med_2017);
fprintf(fileID,'Land going from Q4 to Q3: %.1f%% \n', quadrantChangeMatrix(3,4));
fprintf(fileID,'Q4 Fraction in 1980 and 2017: %.3f \n\n', Q4_frac_1980, Q4_frac_2017);

fclose(fileID);