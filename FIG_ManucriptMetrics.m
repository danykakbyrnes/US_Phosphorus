clc, clear

%% Folder names and filespaths
OUTPUT_folderName = '..\OUTPUTS\';
INPUT_folderName = '..\INPUTS_051523\';
TRENDOUTPUT_folderName = '..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\TREND_P_Version_1.2\';

%% Calculating metrics for the paper
fileID = fopen([OUTPUT_folderName,'ManuscriptMetrics.txt'],'w');
fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'     Results (Section 3) \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');
%% Section 3.1
% -------------------------------------------------------------------------
% Section 3.1.3 Crop Uptake
% -------------------------------------------------------------------------

load([OUTPUT_folderName, 'Component Timeseries\ComponentQuantiles.mat']) %Fertilizer_quantiles','Crop_quantiles','','AgSurplus_quantiles')
TS5_lm = fitlm([1930:2017],Crop_quantiles(1,:));
TS25_lm = fitlm([1930:2017],Crop_quantiles(2,:));
TS50_lm = fitlm([1930:2017],Crop_quantiles(3,:));
TS75_lm = fitlm([1930:2017],Crop_quantiles(4,:));
TS90_lm = fitlm([1930:2017],Crop_quantiles(5,:));

% Getting total fraction of crop uptake that is in the midwest. This can be
% done with county mass since it's a fraction of mass and the boundaries
% are clean. 
CR = shaperead([INPUT_folderName, '0 General Data\CensusRegions\CensusRegions_5070_20230122.shp']);
CR = struct2cell(CR);
CR = CR(9:11,:)';

load([TRENDOUTPUT_folderName, 'Crop_mass.mat'])

StateID_Northeast = [9,23,25,33,34,36, 42,44,50]; 
StateID_Midwest = [17,18,19,20,26,27,29,31,38,39,46,55]; 
StateID_South = [1,5,10,11,12,13,21,22,24,28,37,40,45,47,48,51,54]; 
StateID_West = [4,6,8,16,30,32,35,41,49,53,56];
StateID_Eastern = [StateID_Northeast, StateID_South];

for i = 1:length(County1)
    County_temp = County1{i};
    if length(County_temp) == 6
        State_temp = County_temp(2:3);
    elseif length(County_temp) == 5
        State_temp = County_temp(2);
    end
    StateID(i) = str2num(State_temp);
end

idx_Northeast = find(ismember(StateID, StateID_Northeast));
idx_Midwest = find(ismember(StateID, StateID_Midwest));
idx_South = find(ismember(StateID, StateID_South));
idx_West = find(ismember(StateID, StateID_West));
idx_East = find(ismember(StateID, StateID_Eastern));

Crop_Regions_1930 = [sum(Crop_sum(1, idx_Northeast)); 
                     sum(Crop_sum(1, idx_Midwest));
                     sum(Crop_sum(1, idx_South));
                     sum(Crop_sum(1, idx_West))]./sum(Crop_sum(1,:));

Crop_Regions_2017 = [sum(Crop_sum(end, idx_Northeast)); 
                     sum(Crop_sum(end, idx_Midwest));
                     sum(Crop_sum(end, idx_South));
                     sum(Crop_sum(end, idx_West))]./sum(Crop_sum(end,:));

Crop_Regions_1930_norm = [sum(Crop_sum(1, idx_Northeast))./[CR{1,3}]; 
                     sum(Crop_sum(1, idx_Midwest))./[CR{2,3}];
                     sum(Crop_sum(1, idx_South))./[CR{3,3}];
                     sum(Crop_sum(1, idx_West))./[CR{4,3}]];

Crop_Regions_2017_norm = [sum(Crop_sum(end, idx_Northeast))./[CR{1,3}]; 
                     sum(Crop_sum(end, idx_Midwest))./[CR{2,3}];
                     sum(Crop_sum(end, idx_South))./[CR{3,3}];
                     sum(Crop_sum(end, idx_West))./[CR{4,3}]];

% Special case
Eastern_Crop_Regions_norm = [sum(Crop_sum(1, idx_Northeast))./[CR{3,3}+CR{1,3}];
                             sum(Crop_sum(end, idx_Northeast))./[CR{3,3}+CR{1,3}]];


fprintf(fileID,'3.1.3 Crop Uptake \n');
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');
fprintf(fileID,'Median crop uptake 1930: %.3f (IQR: %.3f-%.3f) \n',Crop_quantiles(3,1),Crop_quantiles(2,1),Crop_quantiles(4,1));
fprintf(fileID,'Median crop uptake 2017: %.3f (IQR: %.3f-%.3f) \n',Crop_quantiles(3,end),Crop_quantiles(2,end),Crop_quantiles(4,end));
fprintf(fileID,'5th perc. slope: %.3f (p val = %.3f) \n',TS5_lm.Coefficients.Estimate(2), TS5_lm.Coefficients.pValue(1));
fprintf(fileID,'25th perc. slope: %.3f (p val = %.3f) \n',TS25_lm.Coefficients.Estimate(2), TS25_lm.Coefficients.pValue(1));
fprintf(fileID,'Median slope: %.3f (p val = %.3f) \n',TS50_lm.Coefficients.Estimate(2), TS50_lm.Coefficients.pValue(1));
fprintf(fileID,'75th perc. slope: %.3f (p val = %.3f) \n',TS75_lm.Coefficients.Estimate(2), TS75_lm.Coefficients.pValue(1));
fprintf(fileID,'95th perc. slope: %.3f (p val = %.3f) \n',TS90_lm.Coefficients.Estimate(2), TS90_lm.Coefficients.pValue(1));
fprintf(fileID,'1930 Crop Production (kg-P ha-tot yr) - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Crop_Regions_1930_norm);
fprintf(fileID,'1930 Crop Production (pct of total) - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Crop_Regions_1930);
fprintf(fileID,'2017 Crop Production (kg-P ha-tot yr) - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Crop_Regions_2017_norm);
fprintf(fileID,'2017 Crop Production (pct of total) - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Crop_Regions_2017);
fprintf(fileID,'Difference in Crop Production - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Crop_Regions_2017_norm - Crop_Regions_1930_norm);
fprintf(fileID,'1930 and 2017 Crop Production East US (kg-P ha-tot yr) - East: %.2f - %.2f \n\n',Eastern_Crop_Regions_norm);

% -------------------------------------------------------------------------
% Section 3.1.4 Fertilizer
% -------------------------------------------------------------------------

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

% Getting total fraction of fertilizer in the census regions. This can be
% done with county mass since it's a fraction of mass and the boundaries
% are clean. 

load([TRENDOUTPUT_folderName, 'Fertilizer_ag_mass.mat'])

Fertilizer_Regions_1930 = [sum(Fert_ag(1, idx_Northeast)); 
                     sum(Fert_ag(1, idx_Midwest));
                     sum(Fert_ag(1, idx_South));
                     sum(Fert_ag(1, idx_West))]./sum(Fert_ag(1,:));

Fertilizer_Regions_2017 = [sum(Fert_ag(end, idx_Northeast)); 
                     sum(Fert_ag(end, idx_Midwest));
                     sum(Fert_ag(end, idx_South));
                     sum(Fert_ag(end, idx_West))]./sum(Fert_ag(end,:));

Fertilizer_Regions_1930_norm = [sum(Fert_ag(1, idx_Northeast))./[CR{1,3}]; 
                     sum(Fert_ag(1, idx_Midwest))./[CR{2,3}]; 
                     sum(Fert_ag(1, idx_South))./[CR{3,3}]; 
                     sum(Fert_ag(1, idx_West))./[CR{4,3}]];

Fertilizer_Regions_1980_norm = [sum(Fert_ag(idx_1980, idx_Northeast))./[CR{1,3}]; 
                     sum(Fert_ag(idx_1980, idx_Midwest))./[CR{2,3}]; 
                     sum(Fert_ag(idx_1980, idx_South))./[CR{3,3}]; 
                     sum(Fert_ag(idx_1980, idx_West))./[CR{4,3}]];

Fertilizer_Regions_2017_norm = [sum(Fert_ag(end, idx_Northeast))./[CR{1,3}]; 
                     sum(Fert_ag(end, idx_Midwest))./[CR{2,3}]; 
                     sum(Fert_ag(end, idx_South))./[CR{3,3}]; 
                     sum(Fert_ag(end, idx_West))./[CR{4,3}]];

% Special case
Eastern_Fert_Regions_norm = [sum(Fert_ag(1, idx_Northeast))./[CR{3,3}+CR{1,3}];
                             sum(Fert_ag(end, idx_Northeast))./[CR{3,3}+CR{1,3}]];


fprintf(fileID,'3.1.5 Fertilizer \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');
fprintf(fileID,'Median fertilizer 1930: %.3f (IQR: %.3f-%.3f) \n',Fertilizer_quantiles(3,1),Fertilizer_quantiles(2,1),Fertilizer_quantiles(4,1));
fprintf(fileID,'Median fertilizer 1980: %.3f (IQR: %.3f-%.3f) \n',Fertilizer_quantiles(3,idx_1980),Fertilizer_quantiles(2,idx_1977),Fertilizer_quantiles(4,idx_1980));
fprintf(fileID,'Median fertilizer 2017: %.3f (IQR: %.3f-%.3f) \n',Fertilizer_quantiles(3,end),Fertilizer_quantiles(2,end),Fertilizer_quantiles(4,end));
fprintf(fileID,'5th perc. slope: %.3f (p val = %.3f) \n',TS5_lm.Coefficients.Estimate(2), TS5_lm.Coefficients.pValue(1));
fprintf(fileID,'25th perc. slope: %.3f (p val = %.3f) \n',TS25_lm.Coefficients.Estimate(2), TS25_lm.Coefficients.pValue(1));
fprintf(fileID,'Median slope: %.3f (p val   = %.3f) \n',TS50_lm.Coefficients.Estimate(2), TS50_lm.Coefficients.pValue(1));
fprintf(fileID,'75th perc. slope: %.3f (p val = %.3f) \n',TS75_lm.Coefficients.Estimate(2), TS75_lm.Coefficients.pValue(1));
fprintf(fileID,'95th perc. slope: %.3f (p val = %.3f) \n',TS90_lm.Coefficients.Estimate(2), TS90_lm.Coefficients.pValue(1));
fprintf(fileID,'Median slope (1980-2017): %.3f (p val   = %.3f) \n',TS50_lm_1980.Coefficients.Estimate(2), TS50_lm_1980.Coefficients.pValue(1));
fprintf(fileID,'1930 Fertilizer Use Region (kg-P ha-tot yr) - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Fertilizer_Regions_1930_norm);
fprintf(fileID,'1930 Fertilizer Use Region (pct of total) - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Fertilizer_Regions_1930);

fprintf(fileID,'1980 Fertilizer Use Region (kg-P ha-tot yr) - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Fertilizer_Regions_1980_norm);

fprintf(fileID,'2017 Fertilizer Use Region (kg-P ha-tot yr) - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Fertilizer_Regions_2017_norm);
fprintf(fileID,'2017 Fertilizer Use Region (pct of total) - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Fertilizer_Regions_2017);
fprintf(fileID,'Difference in Fertilizer Use - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Fertilizer_Regions_2017_norm - Fertilizer_Regions_1930_norm);
fprintf(fileID,'1930 and 2017 Fertilizer Use East US (kg-P ha-tot yr) - East: %.2f - %.2f \n\n',Eastern_Fert_Regions_norm);

% -------------------------------------------------------------------------
% Section 3.1.5 Livestock
% -------------------------------------------------------------------------
TS5_lm = fitlm([1930:2017],Livestock_quantiles(1,:));
TS25_lm = fitlm([1930:2017],Livestock_quantiles(2,:));
TS50_lm = fitlm([1930:2017],Livestock_quantiles(3,:));
TS75_lm = fitlm([1930:2017],Livestock_quantiles(4,:));
TS90_lm = fitlm([1930:2017],Livestock_quantiles(5,:));

% Getting total fraction of livestock census regions. This can be
% done with county mass since it's a fraction of mass and the boundaries
% are clean. 

load([TRENDOUTPUT_folderName, 'Livestock_mass.mat'])

Livestock_Regions_1930 = [sum(Livestock_sum(1, idx_Northeast))./[CR{1,3}]; 
                     sum(Livestock_sum(1, idx_Midwest))./[CR{2,3}]; 
                     sum(Livestock_sum(1, idx_South))./[CR{3,3}]; 
                     sum(Livestock_sum(1, idx_West))./[CR{4,3}]];


Livestock_Regions_2017 = [sum(Livestock_sum(end, idx_Northeast))./[CR{1,3}]; 
                     sum(Livestock_sum(end, idx_Midwest))./[CR{2,3}]; 
                     sum(Livestock_sum(end, idx_South))./[CR{3,3}]; 
                     sum(Livestock_sum(end, idx_West))./[CR{3,3}]]; 

fprintf(fileID,'3.1.5 Livestock \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Median manure 1930: %.3f (IQR: %.3f-%.3f) \n',Livestock_quantiles(3,1),Livestock_quantiles(2,1),Livestock_quantiles(4,1));
fprintf(fileID,'Median manure 2017: %.3f (IQR: %.3f-%.3f) \n',Livestock_quantiles(3,end),Livestock_quantiles(2,end),Livestock_quantiles(4,end));
fprintf(fileID,'5th perc. slope: %.3f (p val = %.3f) \n',TS5_lm.Coefficients.Estimate(2), TS5_lm.Coefficients.pValue(1));
fprintf(fileID,'25th perc. slope: %.3f (p val = %.3f) \n',TS25_lm.Coefficients.Estimate(2), TS25_lm.Coefficients.pValue(1));
fprintf(fileID,'Median slope: %.3f (p val = %.3f) \n',TS50_lm.Coefficients.Estimate(2), TS50_lm.Coefficients.pValue(1));
fprintf(fileID,'75th perc. slope: %.3f (p val = %.3f) \n',TS75_lm.Coefficients.Estimate(2), TS75_lm.Coefficients.pValue(1));
fprintf(fileID,'95th perc. slope: %.3f (p val = %.3f) \n',TS90_lm.Coefficients.Estimate(2), TS90_lm.Coefficients.pValue(1));
fprintf(fileID,'1930 Manure Region Pct of Total- NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n',Livestock_Regions_1930);
fprintf(fileID,'2017 Manure Region Pct of Total - NE: %.2f, MW: %.2f, S, %.2f, W: %.2 \n',Livestock_Regions_2017);
fprintf(fileID,'Difference in Manure Use Pct of Total - NE: %.2f, MW: %.2f, S, %.2f, W: %.2f \n\n',Livestock_Regions_2017 - Livestock_Regions_1930);

% -------------------------------------------------------------------------
% Section 3.1.6 Agriculture P Surplus
% -------------------------------------------------------------------------

fprintf(fileID,'3.1.6 Agriculture Surplus \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Median manure 1930: %.3f (IQR: %.3f-%.3f) \n',AgSurplus_quantiles(3,1),AgSurplus_quantiles(2,1),AgSurplus_quantiles(4,1));
fprintf(fileID,'Median manure 1980: %.3f (IQR: %.3f-%.3f) \n',AgSurplus_quantiles(3,idx_1980),AgSurplus_quantiles(2,idx_1980),AgSurplus_quantiles(4,idx_1980));
fprintf(fileID,'Median manure 2017: %.3f (IQR: %.3f-%.3f) \n',AgSurplus_quantiles(3,end),AgSurplus_quantiles(2,end),AgSurplus_quantiles(4,end));

% Reading in all tif files from 2017. 
%% Calculating PUE at the gridscale.
% Read in gif files
INPUTfilepath = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded\'];

PSfilepath = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\',...
    'Grid_TREND_P_Version_1\TREND-P Agriculture Surplus'];
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
livestockFolder = 'Lvst_Agriculture_LU';

% % Reading a dummy file
% [~,georef] = readgeoraster([INPUTfilepath,'Lvst_BeefCattle_Agriculture_LU\BeefCattle_1930.tif']);
% Rinfo = geotiffinfo([INPUTfilepath,'Lvst_BeefCattle_Agriculture_LU\BeefCattle_1930.tif']);\

% Reading in the three components
[Livestock_tif,~] = readgeoraster([INPUTfilepath, livestockFolder,'\Lvst_2017.tif']);
[Fertilizer_tif,~] = readgeoraster([INPUTfilepath, fertilizerFolder,'\Fertilizer_Ag_2017.tif']);
[AgSurp_tif,~] = readgeoraster([PSfilepath,'\AgSurplus_2017.tif']);

idx_pos = find(AgSurp_tif > 0);
idx_neg = find(AgSurp_tif < 0);

Pos_agSurp_FracLivestock = sum(Livestock_tif(idx_pos) > Fertilizer_tif(idx_pos))/size(idx_pos,1)*100;
Neg_agSurp_FracFertilizer = sum(Livestock_tif(idx_neg) < Fertilizer_tif(idx_neg))/size(idx_pos,1)*100;

fprintf(fileID,'Fraction of Positive Ag Surplus grids with mostly manure inputs: %.1f (mostly Fert: %.1f) \n',Pos_agSurp_FracLivestock, 100-Pos_agSurp_FracLivestock);
fprintf(fileID,'Fraction of Negative Ag Surplus grids with mostly fertilizer inputs: %.1f (mostly Manure: %.1f) \n\n',Neg_agSurp_FracFertilizer, 100-Neg_agSurp_FracFertilizer);

%% Section 3.2
% -------------------------------------------------------------------------
% Section 3.2 Phosphorus Use Efficiency and Relevant to Regional Nutrient Management
% -------------------------------------------------------------------------
INPUTfilepath = ['..\OUTPUTS\PUE\'];
[PUE_1930,~] = readgeoraster([INPUTfilepath,'PUE_1930.tif']);
[PUE_1980,~] = readgeoraster([INPUTfilepath,'PUE_1980.tif']);
[PUE_2017,~] = readgeoraster([INPUTfilepath,'PUE_2017.tif']);


%medianPUE = [median(PUE_1930(:),'omitnan'), median(PUE_1980(:),'omitnan'),...
%    median(PUE_2017(:),'omitnan')];


fprintf(fileID,'3.2 PUE \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Median PUE 1930: %.3f (IQR: %.3f-%.3f) \n',PUE_quantiles(3,1),PUE_quantiles(2,1),PUE_quantiles(4,1));
fprintf(fileID,'Median PUE 1980: %.3f (IQR: %.3f-%.3f) \n',PUE_quantiles(3,idx_1980),PUE_quantiles(2,idx_1980),PUE_quantiles(4,idx_1980));
fprintf(fileID,'Median PUE 2017: %.3f (IQR: %.3f-%.3f) \n',PUE_quantiles(3,end),PUE_quantiles(2,end),PUE_quantiles(4,end));


%% Section 3.2
% -------------------------------------------------------------------------
% Section 3.2 Phosphorus Use Efficiency and Relevant to Regional Nutrient Management
% -------------------------------------------------------------------------
INPUTfilepath = '..\OUTPUTS\Quadrants\Lvstk_Fert_Ratio_Grid_20230623.mat';

load(INPUTfilepath)

% Quadrant 1
Q1_LF_Quadrant = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.Q == 1,:);
Q1_LF_Quadrant_1980 = Q1_LF_Quadrant(Lvsk_Fert_Quadrant.QYear == 1980,:).LvstkFertFract;
Q1_LF_Quadrant_2017 = Q1_LF_Quadrant(Lvsk_Fert_Quadrant.QYear == 2017,:).LvstkFertFract;
Q1_frac_1980 = height(Q1_LF_Quadrant_1980)/height(Lvsk_Fert_Quadrant);
Q1_frac_2017 = height(Q1_LF_Quadrant_2017)/height(Lvsk_Fert_Quadrant);
Q1_ManureFert_1980 = quantile(Q1_LF_Quadrant_1980,[0.5, 0.25, 0.75]);
Q1_ManureFert_2017 = quantile(Q1_LF_Quadrant_2017,[0.5, 0.25, 0.75]);

% Quadrant 2
Q2_LF_Quadrant = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.Q == 2,:);
Q2_LF_Quadrant_1980 = Q2_LF_Quadrant(Lvsk_Fert_Quadrant.QYear == 1980,:).LvstkFertFract;
Q2_LF_Quadrant_2017 = Q2_LF_Quadrant(Lvsk_Fert_Quadrant.QYear == 2017,:).LvstkFertFract;
Q2_frac = height(Q2_LF_Quadrant)/height(Lvsk_Fert_Quadrant);
Q2_frac_1980 = height(Q2_LF_Quadrant_1980)/height(Lvsk_Fert_Quadrant);
Q2_frac_2017 = height(Q2_LF_Quadrant_2017)/height(Lvsk_Fert_Quadrant);
Q2_ManureFert_1980 = quantile(Q2_LF_Quadrant_1980,[0.5, 0.25, 0.75]);
Q2_ManureFert_2017 = quantile(Q2_LF_Quadrant_2017,[0.5, 0.25, 0.75]);

% Quadrant 3
Q3_LF_Quadrant = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.Q == 3,:);
Q3_LF_Quadrant_1980 = Q3_LF_Quadrant(Lvsk_Fert_Quadrant.QYear == 1980,:).LvstkFertFract;
Q3_LF_Quadrant_2017 = Q3_LF_Quadrant(Lvsk_Fert_Quadrant.QYear == 2017,:).LvstkFertFract;
Q3_frac_1980 = height(Q3_LF_Quadrant_1980)/height(Lvsk_Fert_Quadrant);
Q3_frac_2017 = height(Q3_LF_Quadrant_2017)/height(Lvsk_Fert_Quadrant);
Q3_ManureFert_1980 = quantile(Q3_LF_Quadrant_1980,[0.5, 0.25, 0.75]);
Q3_ManureFert_2017 = quantile(Q3_LF_Quadrant_2017,[0.5, 0.25, 0.75]);

% Quadrant 4
Q4_LF_Quadrant = Lvsk_Fert_Quadrant(Lvsk_Fert_Quadrant.Q == 4,:);
Q4_LF_Quadrant_1980 = Q4_LF_Quadrant(Lvsk_Fert_Quadrant.QYear == 1980,:).LvstkFertFract;
Q4_LF_Quadrant_2017 = Q4_LF_Quadrant(Lvsk_Fert_Quadrant.QYear == 2017,:).LvstkFertFract;
Q4_frac_1980 = height(Q4_LF_Quadrant_1980)/height(Lvsk_Fert_Quadrant);
Q4_frac_2017 = height(Q4_LF_Quadrant_2017)/height(Lvsk_Fert_Quadrant);
Q4_ManureFert_1980 = quantile(Q4_LF_Quadrant_1980,[0.5, 0.25, 0.75]);
Q4_ManureFert_2017 = quantile(Q4_LF_Quadrant_2017,[0.5, 0.25, 0.75]);

fprintf(fileID,'3.3 PUE + Cumulative Surplus \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n\n');    
fprintf(fileID,'Q1 Fraction 1980 and 2017: %.3f and %.3f \n', Q1_frac_1980, Q1_frac_2017)
fprintf(fileID,'Q2 Fraction 1980 and 2017: %.3f and %.3f \n', Q2_frac_1980, Q2_frac_2017)
fprintf(fileID,'Q3 Fraction 1980 and 2017: %.3f and %.3f \n', Q3_frac_1980, Q3_frac_2017)
fprintf(fileID,'Q4 Fraction 1980 and 2017: %.3f and %.3f \n\n', Q4_frac_1980, Q4_frac_2017)

fprintf(fileID,'Q1 Median Manure Fraction 1980: %.3f (IQR = %.3f - %.3f)\n', Q1_ManureFert_1980)
fprintf(fileID,'Q1 Median Manure Fraction 2017: %.3f (IQR = %.3f - %.3f)\n', Q1_ManureFert_2017)
fprintf(fileID,'Q2 Median Manure Fraction 1980: %.3f (IQR = %.3f - %.3f)\n', Q2_ManureFert_1980)
fprintf(fileID,'Q2 Median Manure Fraction 2017: %.3f (IQR = %.3f - %.3f)\n', Q2_ManureFert_2017)
fprintf(fileID,'Q3 Median Manure Fraction 1980: %.3f (IQR = %.3f - %.3f)\n', Q3_ManureFert_1980)
fprintf(fileID,'Q3 Median Manure Fraction 2017: %.3f (IQR = %.3f - %.3f)\n', Q3_ManureFert_2017)
fprintf(fileID,'Q4 Median Manure Fraction 1980: %.3f (IQR = %.3f - %.3f)\n', Q4_ManureFert_1980)
fprintf(fileID,'Q4 Median Manure Fraction 2017: %.3f (IQR = %.3f - %.3f)\n\n', Q4_ManureFert_2017)

fclose(fileID);