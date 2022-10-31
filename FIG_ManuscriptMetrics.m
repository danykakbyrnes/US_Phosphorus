clc, clear all

INPUT_folderName = '../INPUTS_050522/'; 
OUTPUT_folderName = '../OUTPUTS/TREND_P_Version_1.2/';

% Loading Files
load([OUTPUT_folderName,'PSurplus_kgha.mat'])
load([OUTPUT_folderName,'Deposition_kgha.mat'])
load([OUTPUT_folderName,'Livestock_kgha.mat'])
load([OUTPUT_folderName,'Livestock_mass.mat'])
load([OUTPUT_folderName,'Fertilizer_kgha.mat'])
load([OUTPUT_folderName,'Crop_kgha.mat'])
load([OUTPUT_folderName,'Crop_mass.mat'])
load([OUTPUT_folderName,'Detergent_kgha.mat'])
load([OUTPUT_folderName,'Population_kgha.mat'])

% Opening the text file
fileID = fopen([OUTPUT_folderName,'ManuscriptMetrics.txt'],'w');

%% Section 3.1.1 Atmospheric Deposition
NEState = [9, 23, 25, 33, 34, 36, 42, 44, 50]; 
Year = [1930:2017];
StateIDs = []; 

for i = 1:length(County1)
    countid_temp = County1{i};
    
    if length(countid_temp) > 5
        StateIDs(i,1) = str2num(countid_temp(2:3));
    else
        StateIDs(i,1) = str2num(countid_temp(2));
    end
end
% County
Hi_ATMDep_County= Deposition_export(:,find(strcmp(County1,'x34019'))); % Multiple counties h
Hi_ATMDep_County_max = max(Hi_ATMDep_County);
year_Hi_ATMDep_County = Year(find(Hi_ATMDep_County == Hi_ATMDep_County_max));

% Region
ATM_NEState = Deposition_export(:,ismember(StateIDs, NEState));
ATM = quantile(ATM_NEState, [0.25, 0.5, 0.75],2);
ATM_max_IQR = max(ATM);
year_ATM_max_IQR = Year(find(ATM(:,2) == ATM_max_IQR(2)));

% Trend
year_idx = find(Year == 1990); 
ATM_TRENDState_1930 = quantile(Deposition_export(1,:), [0.25, 0.5, 0.75],2);
ATM_TRENDState_1990 = quantile(Deposition_export(year_idx,:), [0.25, 0.5, 0.75],2);
ATM_TRENDState_2017 = quantile(Deposition_export(end,:), [0.25, 0.5, 0.75],2);


% Printing results
fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'     3.1.1 Atmospheric Deposition \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'Year and Rate of high deposition: %d, %0.2f \n',year_Hi_ATMDep_County, Hi_ATMDep_County_max);
fprintf(fileID,'NE Year and rate of high deposition: %d, %0.2f (%0.2f -  %0.2f) \n',year_ATM_max_IQR, ATM_max_IQR(2),ATM_max_IQR(1),ATM_max_IQR(3));
fprintf(fileID,'1930 Median and IQR: %0.2f (%0.2f -  %0.2f) \n',ATM_TRENDState_1930(2), ATM_TRENDState_1930(1), ATM_TRENDState_1930(3));
fprintf(fileID,'1990 Median and IQR: %0.2f (%0.2f -  %0.2f) \n',ATM_TRENDState_1990(2), ATM_TRENDState_1990(1), ATM_TRENDState_1990(3));
fprintf(fileID,'2017 Median and IQR: %0.2f (%0.2f -  %0.2f) \n\n',ATM_TRENDState_2017(2), ATM_TRENDState_2017(1), ATM_TRENDState_2017(3));

%% Section 3.1.2 Livestock
median_lvst = median(Livestock_export,2);
lm = fitlm([1930:2017],median_lvst);
p_Val = lm.Coefficients.pValue(2);

National_livestock = sum(Livestock_sum,2)/sum(AREA); 
lm = fitlm([1930:2017],National_livestock);
slope = lm.Coefficients.Estimate(2); 
p_Val_2 = lm.Coefficients.pValue(2);

LVSKTTrend_1930 = quantile(Livestock_export(1,:), [0.25, 0.5, 0.75,0.90],2);
LVSKTTrend_2017 = quantile(Livestock_export(end,:), [0.25, 0.5, 0.75,0.90],2);

% State changes
% New york
% Region
NYState = 36;
lvsk_State = Livestock_export(:,ismember(StateIDs, NYState));
quantile_NY_lvstk = quantile(lvsk_State, [0.25,0.5,0.75],2);
lm_NY = fitlm([1930:2017],quantile_NY_lvstk(:,2));
slope_NY = lm_NY.Coefficients.Estimate(2); 
p_Val_NY = lm_NY.Coefficients.pValue(2);

% Ohio, 39
OHState = 39;
lvsk_State = Livestock_export(:,ismember(StateIDs, OHState));
quantile_OH_lvstk = quantile(lvsk_State, [0.25,0.5,0.75],2);
lm_OH = fitlm([1930:2017],quantile_OH_lvstk(:,2));
slope_OH = lm_OH.Coefficients.Estimate(2); 
p_Val_OH = lm_OH.Coefficients.pValue(2);


% Indiana, 18
INState = 18;
lvsk_State = Livestock_export(:,ismember(StateIDs, INState));
quantile_IN_lvstk = quantile(lvsk_State, [0.25,0.5,0.75],2);
lm_IN = fitlm([1930:2017],quantile_IN_lvstk(:,2));
slope_IN = lm_IN.Coefficients.Estimate(2); 
p_Val_IN = lm_IN.Coefficients.pValue(2);

% Illinois, 17
IlState = 17;
lvsk_State = Livestock_export(:,ismember(StateIDs, IlState));
quantile_IL_lvstk = quantile(lvsk_State, [0.25,0.5,0.75],2);
lm_IL = fitlm([1930:2017],quantile_IL_lvstk(:,2));
slope_IL = lm_IL.Coefficients.Estimate(2); 
p_Val_IL = lm_IL.Coefficients.pValue(2);



fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'     3.1.3 Livestock \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'Median lvst p-val: %0.2f \n', p_Val);
fprintf(fileID,'National Norm input slope: %0.6f (p < %0.2f) \n', slope, p_Val_2);
fprintf(fileID,'NY Livestock Trend: %0.3f (p val < %0.5f)\n', slope_NY, p_Val_NY);
fprintf(fileID,'OH Livestock Trend: %0.3f (p val < %0.5f)\n', slope_OH, p_Val_OH);
fprintf(fileID,'IN Livestock Trend: %0.3f (p val < %0.5f)\n', slope_IN, p_Val_IN);
fprintf(fileID,'IL Livestock Trend: %0.3f (p val < %0.5f)\n\n', slope_IL, p_Val_IL);

fprintf(fileID,'1930 Median and IQR: %0.2f (%0.2f -  %0.2f) \n', LVSKTTrend_1930(2), LVSKTTrend_1930(1), LVSKTTrend_1930(3));
fprintf(fileID,'2017 Median and IQR: %0.2f (%0.2f -  %0.2f) \n', LVSKTTrend_2017(2), LVSKTTrend_2017(1), LVSKTTrend_2017(3));
fprintf(fileID,'90th percentile in 1930 and 2017: %0.2f, %0.2f\n\n', LVSKTTrend_1930(4), LVSKTTrend_2017(4));

%% Fertilizer
year_idx = find(Year == 1977); % histogram showed that most peaked in 1977
FERTQuantiles_1930 = quantile(Fertilizer_export(1,:), [0.25, 0.5, 0.75,0.90],2);
FERTQuantiles_2017 = quantile(Fertilizer_export(end,:), [0.25, 0.5, 0.75,0.90],2);
FERTQuantiles_1977 = quantile(Fertilizer_export(year_idx,:), [0.25, 0.5, 0.75],2);
% Percent counties with decreasing trend
year_idx = find(Year == 1980); % histogram showed that most peaked in 1977
pos_slope_all = 0; 
pos_slope_sig = 0; 
neg_slope_all = 0; 
neg_slope_sig = 0; 
for i = 1:size(Fertilizer_export,2)
    
    lm = fitlm(1980:2017, Fertilizer_export(year_idx:end,i));
    slope = lm.Coefficients.Estimate(2); 
    p_Val = lm.Coefficients.pValue(2);
    
    if slope > 0
        pos_slope_all = pos_slope_all+1;
        if p_Val < 0.05
            pos_slope_sig = pos_slope_sig+1;
        end
    elseif slope < 0 
        neg_slope_all = neg_slope_all+1;
        if p_Val < 0.05
            neg_slope_sig = neg_slope_sig+1;
        end
    end
    

end
pos_slope_all = pos_slope_all/size(Fertilizer_export,2); 
neg_slope_all = neg_slope_all/size(Fertilizer_export,2);
pos_slope_sig = pos_slope_sig/size(Fertilizer_export,2);
neg_slope_sig = neg_slope_sig/size(Fertilizer_export,2);


fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'     3.1.4 Fertilizer \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 

fprintf(fileID,'1930 Median and IQR: %0.2f (%0.2f -  %0.2f) \n', FERTQuantiles_1930(2), FERTQuantiles_1930(1), FERTQuantiles_1930(3));
fprintf(fileID,'1977 Median and IQR: %0.2f (%0.2f -  %0.2f) \n', FERTQuantiles_1977(2), FERTQuantiles_1977(1), FERTQuantiles_1977(3));
fprintf(fileID,'2017 Median and IQR: %0.2f (%0.2f -  %0.2f) \n\n', FERTQuantiles_2017(2), FERTQuantiles_2017(1), FERTQuantiles_2017(3));

fprintf(fileID,'Number of counties with positive trend [all (sig)]: %0.2f, %0.2f) \n', pos_slope_all, pos_slope_sig);
fprintf(fileID,'Number of counties with negative trend [all (sig)]: %0.2f, %0.2f) \n\n', neg_slope_all, neg_slope_sig);

%% Crop Uptake
MWStates = [38, 46, 31, 20, 27, 19, 29, 55, 17, 18, 26, 39]; 
CROP_MWState = sum(Crop_sum(:,ismember(StateIDs, MWStates)),2);
CROP_AllState = sum(Crop_sum(:,:),2);

Frac_CROPMWStats = CROP_MWState./CROP_AllState;

CROPQuantiles_1930 = quantile(Crop_export(1,:), [0.25, 0.5, 0.75,0.90],2);
CROPQuantiles_2017 = quantile(Crop_export(end,:), [0.25, 0.5, 0.75,0.90],2);


fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'     3.1.5 Crop Uptake \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 

fprintf(fileID,'1930 Median and IQR: %0.2f (%0.2f -  %0.2f) \n', CROPQuantiles_1930(2), CROPQuantiles_1930(1), CROPQuantiles_1930(3));
fprintf(fileID,'2017 Median and IQR: %0.2f (%0.2f -  %0.2f) \n', CROPQuantiles_2017(2), CROPQuantiles_2017(1), CROPQuantiles_2017(3));
fprintf(fileID,'1930 Fractin of Crop in MW: %0.2f \n', mean(Frac_CROPMWStats(1:5)));
fprintf(fileID,'2017 Fractin of Crop in MW: %0.2f \n\n', mean(Frac_CROPMWStats(end-4:end)));

%% Domestic Inputs
% Detergent
year_idx = find(Year == 1983); % histogram showed that most peaked in 1977

DETQuantiles_1930 = quantile(Detergent_export(1,:), [0.25, 0.5, 0.75,0.90],2);
DETQuantiles_2017 = quantile(Detergent_export(end,:), [0.25, 0.5, 0.75,0.90],2);
DETQuantiles_1983 = quantile(Detergent_export(year_idx,:), [0.25, 0.5, 0.75],2);


fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'     3.1.6 Domestic Inputs \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 

fprintf(fileID,'1930 Detergent Median and IQR: %0.2f (%0.2f -  %0.2f) \n', DETQuantiles_1930(2), DETQuantiles_1930(1), DETQuantiles_1930(3));
fprintf(fileID,'1983 Detergent Median and IQR: %0.2f (%0.2f -  %0.2f) \n', DETQuantiles_1983(2), DETQuantiles_1983(1), DETQuantiles_1983(3));
fprintf(fileID,'2017 Detergent Median and IQR: %0.2f (%0.2f -  %0.2f) \n\n', DETQuantiles_2017(2), DETQuantiles_2017(1), DETQuantiles_2017(3));

% Human inputs
%Population_export

Fraction_above1 = sum(Population_export(end,:) > 1)/size(Population_export,2);
HUMQuantiles_1930 = quantile(Population_export(1,:), [0.25, 0.5, 0.75,0.90],2);
HUMQuantiles_2017 = quantile(Population_export(end,:), [0.25, 0.5, 0.75,0.90],2);

fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 
fprintf(fileID,'     3.1.6 Human Inputs \n'); 
fprintf(fileID,'---------------------------------------------------------------------------------------------\n'); 

fprintf(fileID,'Fraction of counts above 1 kg-P ha yr: %0.2f \n',Fraction_above1);
fprintf(fileID,'2017 Human Median and IQR: %0.2f (%0.2f -  %0.2f) \n\n', HUMQuantiles_2017(2), HUMQuantiles_2017(1), HUMQuantiles_2017(3));


fclose(fileID);