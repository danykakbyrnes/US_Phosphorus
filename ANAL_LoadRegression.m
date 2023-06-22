clc, clear, close all

%% This script is used to run regression of watersheds between watershed metrics and loads. 

OUTPUT_folderName = '../OUTPUTS/ExportRatios/';
load([OUTPUT_folderName, 'MetricTable.mat'])

% Removing past LU.
MetricTable = removevars(MetricTable, ["NLCD_Urb_01","NLCD_Ag_01","NLCD_For_01","NLCD_Barr_01","NLCD_Wtlnd_01","NLCD_Shrub_01","NLCD_Grass_01","NLCD_Water_01","NLCD_Urb_06","NLCD_Ag_06","NLCD_For_06","NLCD_Barr_06","NLCD_Wtlnd_06","NLCD_Shrub_06","NLCD_Grass_06","NLCD_Water_06", "HDEN_1950","HDEN_1960","HDEN_1970","HDEN_1980","HDEN_1990","HDEN_2000"]);

for i = 12:width(MetricTable)
    
    var = MetricTable{:,i};
    lm = fitlm(var, MetricTable.Load_2010);

    m = lm.Coefficients.Estimate(2);
    b = lm.Coefficients.Estimate(1);

    y_model = m*[0,max(var)] + b; 
   
    subplot(1,2,1)
    plot([0,max(var)], y_model,'k--')
    hold on

    scatter(var, MetricTable.Load_2010, 20,'filled')
    ColName = MetricTable.Properties.VariableNames{i}; 
    ylabel('Load (kg-N ha^-^1 y^-^1)')
    xlabel(ColName)
    hold off
    
    title(['R^2 =', num2str(lm.Rsquared.Ordinary), ', pVal = ', num2str(lm.Coefficients.pValue(2))])

   subplot(1,2,2)
   plot([0,max(var)], y_model,'k--')
   hold on
    
   scatter(var, MetricTable.Load_2010, 20,'filled')
   ColName = MetricTable.Properties.VariableNames{i}; 
   ylabel('Load (kg-N ha^-^1 y^-^1)')
   xlabel(ColName)
   hold off
   xlim([0,2])
   set(gcf,'position',[100,100,700,300])

   Figfolderpath = [OUTPUT_folderName,'regressionFigures/LMRg_',ColName,'.png'];
   print('-dpng','-r600',Figfolderpath)
end

% Multiple regression analysis
X = [MetricTable.CLAYSILTAVE, MetricTable.NLCD_Ag_11,...
MetricTable.NLCD_Wtlnd_11, MetricTable.PDEN_2010_BLOCK,...
MetricTable.wwtp_dens];

mdl = fitlm(X, MetricTable.Load_2010);

Load_mean = mean(MetricTable.Load_2010);
Load_minmax = [min(MetricTable.Load_2010), max(MetricTable.Load_2010)];
Load_median = median(MetricTable.Load_2010);
Load_quantile = quantile(MetricTable.Load_2010, [0.25,0.75]);

% Opening the text file
fileID = fopen([OUTPUT_folderName,'MeanMedianLoad.txt'],'w');
fprintf(fileID,'2010 Mean P Load (min-max): %0.2f (%0.2f - %0.2f)\n',Load_mean, Load_minmax);
fprintf(fileID,'2010 Median P Load (IQR): %0.2f (%0.2f -  %0.2f) \n',Load_median, Load_quantile);
fclose(fileID);