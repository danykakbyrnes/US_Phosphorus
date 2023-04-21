clc, clear, close all

%% This script is used to run regression of watersheds between watershed metrics and loads. 

OUTPUT_folderName = '../OUTPUTS/ExportRatios/';
load([OUTPUT_folderName, 'MetricTable.mat'])


for i = 7:width(MetricTable)
    
    lm = fitlm(MetricTable.Load_2010, MetricTable{:,i});

    m = lm.Coefficients.Estimate(2);
    b = lm.Coefficients.Estimate(1);

    y_model = m*[0,max(MetricTable.Load_2010)] + b; 
    
    plot([0,max(MetricTable.Load_2010)], y_model,'k--')
    hold on

    scatter(MetricTable.Load_2010, MetricTable{:,i}, 20,'filled')
    ColName = MetricTable.Properties.VariableNames{i}; 
    xlabel('Load (kg-N ha^-^1 y^-^1)')
    ylabel(ColName)
    hold off
    
   
end