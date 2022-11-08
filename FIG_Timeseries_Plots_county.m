clc, clear, close all
% ------------------------------------------------------------------------
% MAKING TIMESERIES FOR FIGURE 1
% ------------------------------------------------------------------------
% ########################################################################

OUTPUT_folderName = '../OUTPUTS/TREND_P_Version_1.2/';  

load([OUTPUT_folderName, 'PSurplus_kgha.mat'])
load([OUTPUT_folderName, 'Livestock_kgha.mat'])
load([OUTPUT_folderName,'Livestock_mass.mat'])

load([OUTPUT_folderName, 'Fertilizer_kgha.mat'])
load([OUTPUT_folderName,'Fertilizer_mass.mat'])

load([OUTPUT_folderName, 'Crop_kgha.mat'])
load([OUTPUT_folderName, 'Crop_mass.mat'])

load([OUTPUT_folderName, 'Deposition_kgha.mat'])
load([OUTPUT_folderName, 'AtmsphericDeposition_mass.mat'])

load([OUTPUT_folderName, 'Detergent_kgha.mat'])
load([OUTPUT_folderName, 'Population_kgha.mat'])

% Plot Specs
fontSize_p = 12;
xticks_p = [1930, 1980, 2017];
plot_dim = [50,50,200,190];

%% Atmospheric Deposition
figure(1) 

quantiles_AtmDepo_export = quantile(Deposition_export,[0.25, 0.75],2);
median_AtmDepo_export = nanmedian(Deposition_export,2);
national_Deposition = sum(AtmosphericDeposition_P_m,2)/(1e+9);

area([1930:2017],quantiles_AtmDepo_export,'LineStyle','none')
newcolors = [{'#ffffff', '#b3cde3'}];%1,1,1;0.9922, 0.7451, 0.6471];
colororder(newcolors)   
hold on

plot([1930:2017],median_AtmDepo_export,'Color','#8856a7','LineWidth',2)

xlim([1930,2017])
%xticks([1930, 1970, 2010])
xticks(xticks_p)
yticks([0,0.2])
figure(1) 

% hold on
% 
% yyaxis right
% plot([1930:2017],national_Deposition,'-k','LineWidth',1)
% ylim([0,0.085])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

set(gca,'FontSize',12,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Deposition_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Deposition_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% Livestock

figure(2) 
quantiles_Livestock_export = quantile(Livestock_export,[0.25, 0.75],2);
median_Livestock_export = nanmedian(Livestock_export,2);
national_Livestock = sum(Livestock_sum,2)/(1e+9);

area([1930:2017],quantiles_Livestock_export,'LineStyle','none')
newcolors = [{'#ffffff';'#dcdcec'}];
colororder(newcolors)
hold on

plot([1930:2017],median_Livestock_export,'Color','#6a51a3','LineWidth',2)

xlim([1930,2017])
%xticks([1930, 1970, 2010])
xticks(xticks_p)
ylim([0,10])
yticks([0, 5, 10])
figure(2) 

hold on

yyaxis right
plot([1930:2017],national_Livestock,'-k','LineWidth',1)

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Livestock_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Livestock_TS.png'];
print('-dpng','-r600',[Figfolderpath])

close all

%Livestock_export
% median_19301945 = median(Livestock_export(1:16,:),1); 
% median_20022017 = median(Livestock_export(end-14:end,:),1);
% [h,p] = kstest2(median_19301945,median_20022017)
% subplot(2,2,1)
% histogram(median_19301945, 'BinWidth',0.5)
% hold on
% histogram(median_20022017, 'BinWidth',0.5)
% 
% mean_19301945 = mean(Livestock_export(1:16,:),1); 
% mean_20022017 = mean(Livestock_export(end-14:end,:),1);
% [h,p] = kstest2(mean_19301945,mean_20022017)
% subplot(2,2,2)
% histogram(median_19301945, 'BinWidth',0.5)
% hold on
% histogram(median_20022017, 'BinWidth',0.5)
% legend('1930-1945', '2002-2017')

vect_19301945 = Livestock_export(1:16,:); vect_19301945 = vect_19301945(:); 
vect_20022017 = Livestock_export(end-14:end,:); vect_20022017 = vect_20022017(:); 
[h,p]  = kstest2(vect_19301945,vect_20022017)
%subplot(2,2,3)
histogram(vect_19301945, 'BinWidth',0.5)
hold on
histogram(vect_20022017, 'BinWidth',0.5)
xlim([0,20])
ylim([0,9000])

Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Livestock_Distributions.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% Fertilizer 
figure(3) 
quantiles_Fertilizer_export = quantile(Fertilizer_export,[0.25, 0.75],2);
median_Fertilizer_export = nanmedian(Fertilizer_export,2);
national_Fertilizer = sum(Fert_m,2)/(1e+9);

area([1930:2017],quantiles_Fertilizer_export,'LineStyle','none')
newcolors = [1,1,1;0.9922, 0.7451, 0.6471];
colororder(newcolors)
hold on

plot([1930:2017],median_Fertilizer_export,'Color','#d42020','LineWidth',2)

xlim([1930,2017])
%xticks([1930, 1970, 2010])
xticks(xticks_p)
ylim([0,10])
yticks([0, 5, 10])
figure(3) 
hold on

yyaxis right
plot([1930:2017],national_Fertilizer,'-k','LineWidth',1)
ylim([0,2.25])
yticks([0,1,2])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Fertilizer_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Fertilizer_TS.png'];
print('-dpng','-r600',[Figfolderpath])

close all

%% Population 
figure(4) 
quantiles_Population_export = quantile(Population_export,[0.25, 0.75],2);
median_Population_export = nanmedian(Population_export,2);

area([1930:2017],quantiles_Population_export,'LineStyle','none')
newcolors = [{'#ffffff','#c8ddf0'}];
%newcolors = [{'#ffffff','#bdbdbd'}];%

colororder(newcolors)
hold on
plot([1930:2017],median_Population_export,'Color','#2879b9','LineWidth',2)
%plot([1930:2017],median_Population_export,'Color','#424242','LineWidth',2)

xlim([1930,2017])
%xticks([1930, 1970, 2010])
xticks(xticks_p)
ylim([0, 0.5])
yticks([0, 0.5])
figure(4) 
set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Population_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Population_TS.png'];
print('-dpng','-r600',[Figfolderpath])

close all
%% Detergents 
figure(5) 
quantiles_Detergent_export = quantile(Detergent_export,[0.25, 0.75],2);
median_Detergent_export = nanmedian(Detergent_export,2);

area([1930:2017],quantiles_Detergent_export,'LineStyle','none')
newcolors = [{'#ffffff','#c8ddf0'}];
%newcolors = [{'#ffffff','#bdbdbd'}];
colororder(newcolors)
hold on
%plot([1930:2017],median_Detergent_export,'Color','#424242','LineWidth',2)
plot([1930:2017],median_Detergent_export,'Color','#2879b9','LineWidth',2)

xlim([1930,2017])
%xticks([1930, 1970, 2010])
xticks(xticks_p)
ylim([0, 0.5])
yticks([0, 0.5])
figure(5) 
set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Detergents_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/Detergents_TS.png'];
print('-dpng','-r600',[Figfolderpath])

close all
%% Crop Uptake 
figure(6) 
quantiles_Crop_export = quantile(Crop_export,[0.25, 0.75],2);
median_Crop_export = nanmedian(Crop_export,2);
national_Crop = sum(Crop_sum,2)/(1e+9);

area([1930:2017],quantiles_Crop_export,'LineStyle','none')
newcolors = [{'#ffffff','#caeac3'}];
colororder(newcolors)
hold on
plot([1930:2017],median_Crop_export,'Color','#2a924a','LineWidth',2)

xlim([1930,2017])
%xticks([1930, 1970, 2010])
xticks(xticks_p)
ylim([0,10])
yticks([0, 5, 10])
figure(6) 
hold on

yyaxis right
plot([1930:2017],national_Crop,'-k','LineWidth',1)
ylim([1,3.25])
yticks([0,1,2,3])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/CropUptake_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'TimeseriesPlot/Components/CropUptake_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all