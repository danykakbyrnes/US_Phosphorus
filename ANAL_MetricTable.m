clc, clear

%% This script is used add watershed metrics

%INPUT_folder = '../INPUTS_103122/';
metricINPUT_folder = 'B:/LabFiles/users/DanykaByrnes/4 Memoryscapes/INPUTS_050522/';
OUTPUT_folderName = '../OUTPUTS/ExportRatios/';

% Toggling MT rewrite
rewriteMetricTable = 1;

% Toggling Metrics
runRemoveER = 1; 
runLandUseMetrics = 0; 
runPopulationDensity = 0;
runTileDrainage = 0; 
runStaticParameters = 0; 

if rewriteMetricTable == 1
    opts = detectImportOptions([OUTPUT_folderName, 'ErRatio_20230309.txt']);
    opts = setvartype(opts, 'StreamgageNumber', 'char');  %or 'char' if you prefer
    opts = setvartype(opts, 'WatershedNumber', 'char');  %or 'char' if you prefer
    
    MetricTable = readtable([OUTPUT_folderName, 'ErRatio_20230309.txt'], opts);
    save([OUTPUT_folderName, 'MetricTable.mat'],'MetricTable')
else
    load([OUTPUT_folderName, 'MetricTable.mat'])
end

%% Removing ER NaN
if runRemoveER == 1
    MetricTable(isnan(MetricTable.ExportRatio_2010),:) = [];
    save([OUTPUT_folderName, 'MetricTable.mat'],'MetricTable')
end


%% Land use (NLCD)
if runLandUseMetrics == 1
    % Dataset 11: LandUse: Eight tables with land use and land cover data 
    % from NLCD (every five years, 2001-2011), and NWALT (every 10 years,
    %  1974-2012). NLCD: National Land Cover Database
    % NWALT: Wall-to-Wall Anthropogenic Land Use Trends
    
    load([metricINPUT_folder,...
        '1_GENERAL_DATA/Dataset11_LandUse/NLCD_LU_SUMMARY.mat'])
    
    load([OUTPUT_folderName, 'MetricTable.mat'])
       
    MetricTable = outerjoin(MetricTable, NLCD,'Type','left','MergeKey',1);
    
    save([OUTPUT_folderName, 'MetricTable.mat'],'MetricTable')
 end

%% Population Density
 if runPopulationDensity == 1
% Dataset 20: Population and Housing
load([OUTPUT_folderName, 'MetricTable.mat'])
load([metricINPUT_folder, '1_GENERAL_DATA/Dataset20_Population-Housing/swt_Population-Housing.mat'])
    
    try
    MetricTable = removevars(MetricTable, POP(:,[2:end]).Properties.VariableNames);
    catch
    end
    MetricTable = outerjoin(MetricTable, POP,'Type','left','MergeKey',1);

    save([OUTPUT_folderName, 'MetricTable.mat'],'MetricTable')

end

%% Tile Drainage.
% This was originally with the Conservation Practices but we are using the
% best available data 30m raster)

if runTileDrainage == 1
    % Dataset 5: Conservation Practice
load([metricINPUT_folder, '1_GENERAL_DATA/Dataset99_TileDrainge/swt_TD2012.mat'])
    
try
    MetricTable = removevars(MetricTable, TD(:,[2:end]).Properties.VariableNames);
catch
end

MetricTable = outerjoin(MetricTable, TD,'Type','left','MergeKey',1);

% TD per ag land
MetricTable.TD_AgLU = (MetricTable.TileDrain_pct./MetricTable.NLCD_Ag_11)*100;
MetricTable.TD_AgLU(isnan(MetricTable.TD_AgLU)) = 0; 

save([OUTPUT_folderName, 'MetricTable.mat'],'MetricTable')

end

%% Static Parameters
if runStaticParameters == 1
      load([OUTPUT_folderName, 'MetricTable.mat'])
    load([metricINPUT_folder, '1_GENERAL_DATA/Dataset24_Static/swt_Static_Metrics.mat'])
    
cols = [1,2,16,29,47:49,69,70];
STATIC_subset = STATIC(:,cols);
STATIC_subset.CLAYSILTAVE = STATIC_subset.CLAYAVE + STATIC_subset.SILTAVE;

try
    MetricTable = removevars(MetricTable, [STATIC_subset(:,[2:end]).Properties.VariableNames,{'AI'}]);
catch
end

MetricTable = outerjoin(MetricTable, STATIC_subset,'Type','left','MergeKey',1);

save([OUTPUT_folderName, 'MetricTable.mat'],'MetricTable')
    
end