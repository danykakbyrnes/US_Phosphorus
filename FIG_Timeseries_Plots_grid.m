clc, clear, close all
% ------------------------------------------------------------------------
% MAKING COMPONENT AND SURPLUS TIMESERIES TIMESERIES FOR FIGURE 1
%   Read in each tif file, vetorize and take the median, and quanties per
%   year. 
% ------------------------------------------------------------------------
runTiffs = 1;
% Read in tif files
INPUTfilepath = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded (2023-07-25)\'];
INPUTfilepath2 = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\',...
    'Grid_TREND_P_Version_1\TREND-P Agriculture Surplus\'];
INPUTfilepathPUE = '..\OUTPUTS\PUE\';

OUTPUT_folderName = '..\OUTPUTS\Component Timeseries\';
YEARS = 1930:2017;

cropFolder = 'CropUptake_Agriculture_Agriculture_LU';
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
livestockFolder = 'Lvst_Agriculture_LU';

% Aesthetic attributes
% Plot Specs
fontSize_p = 13;
xticks_p = [1930, 1980, 2017];
plot_dim = [50,50,200,190];

%% Running Code

if runTiffs == 1
% Reading in Manure Files 
Livestock_quantiles = zeros(5,length(YEARS));
for i = 1:length(YEARS)
    YEAR_i = YEARS(i);
    file_lvsk_i = dir([INPUTfilepath, livestockFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Tif_i,~] = readgeoraster([INPUTfilepath, livestockFolder,'\',file_lvsk_i.name]);
    
    % Converting the file
    Tif_i = single(Tif_i); 
    
    Tif_i(Tif_i == 0) = NaN; 
    Tif_linear = Tif_i(:); 
        
    QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
    
    Livestock_quantiles(:,i) = QLV;
end

%% Reading in Fetilizer Files 
Fertilizer_quantiles = zeros(5,length(YEARS));
for i = 1:length(YEARS)
    YEAR_i = YEARS(i);
    file_fert_i = dir([INPUTfilepath, fertilizerFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Tif_i,~] = readgeoraster([INPUTfilepath, fertilizerFolder,'\',file_fert_i.name]);
    
    % Converting the file
    Tif_i = single(Tif_i); 
    
    Tif_i(Tif_i == 0) = NaN; 
    Tif_linear = Tif_i(:); 
        
    QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
    
    Fertilizer_quantiles(:,i) = QLV;
end

%% Reading in Crop Files 
Crop_quantiles = zeros(5,length(YEARS));
for i = 1:length(YEARS)
    YEAR_i = YEARS(i);
    file_fert_i = dir([INPUTfilepath, cropFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Tif_i,~] = readgeoraster([INPUTfilepath, cropFolder,'\',file_fert_i.name]);
    
    % Converting the file
    Tif_i = single(Tif_i); 
    
    Tif_i(Tif_i == 0) = NaN; 
    Tif_linear = Tif_i(:); 
        
    QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
    
    Crop_quantiles(:,i) = QLV;
end

%% Reading in Ag Surplus Files 
AgSurplus_quantiles = zeros(5,length(YEARS));
for i = 1:length(YEARS)
    YEAR_i = YEARS(i);
    file_agsur_i = dir([INPUTfilepath2,'\*_',num2str(YEAR_i),'.tif']);
    [Tif_i,~] = readgeoraster([INPUTfilepath2,'\',file_agsur_i.name]);
    
    % Converting the file
    Tif_i = single(Tif_i); 
    
    Tif_linear = Tif_i(:); 
        
    QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
    
    AgSurplus_quantiles(:,i) = QLV;
end

save([OUTPUT_folderName, '\ComponentQuantiles.mat'],'Fertilizer_quantiles','Crop_quantiles','Livestock_quantiles','AgSurplus_quantiles')


%% PUE
PUE_quantiles = zeros(5,length(YEARS));
for i = 1:length(YEARS)
    YEAR_i = YEARS(i);
    file_pue_i = dir([INPUTfilepathPUE,'\*_',num2str(YEAR_i),'.tif']);
    [Tif_i,~] = readgeoraster([INPUTfilepathPUE,'\',file_pue_i.name]);
    
    % Converting the file    
    Tif_linear = Tif_i(:); 
        
    QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
    
    PUE_quantiles(:,i) = QLV;
end

save([OUTPUT_folderName, '\ComponentQuantiles.mat'],'Fertilizer_quantiles','Crop_quantiles','Livestock_quantiles','AgSurplus_quantiles','PUE_quantiles')
end

%% Timeseries plots
load([OUTPUT_folderName, '\ComponentQuantiles.mat'])

%% Livestock

figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

% Setting up the 5-95th percentile band
Y = [Livestock_quantiles(5,:), fliplr(Livestock_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#dcdcec')

hold on

% Setting up the 25th-75th percentile
Y = [Livestock_quantiles(4,:), fliplr(Livestock_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#acacd2')

% Plotting Median   
plot([1930:2017],Livestock_quantiles(3,:),'Color','#6a51a3','LineWidth',2)

xlim([1930,2017])
xticks(xticks_p)
ylim([0,40])
yticks([0,20,40])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])
Figfolderpath = [OUTPUT_folderName,'Livestock_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'Livestock_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% Fertilizer

figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

% Setting up the 5-95th percentile band
Y = [Fertilizer_quantiles(5,:), fliplr(Fertilizer_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#fee6da')

hold on

% Setting up the 25th-75th percentile
Y = [Fertilizer_quantiles(4,:), fliplr(Fertilizer_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#fcb296')

% Plotting Median
plot([1930:2017],Fertilizer_quantiles(3,:),'Color','#d32020','LineWidth',2)

xlim([1930,2017])
xticks(xticks_p)
ylim([0,30])
yticks([0,15,30])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])
Figfolderpath = [OUTPUT_folderName,'Fertilizer_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'Fertilizer_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% Crop Uptake

figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

% Setting up the 5-95th percentile band
Y = [Crop_quantiles(5,:), fliplr(Crop_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#d8f0d2')

hold on

% Setting up the 25th-75th percentile
Y = [Crop_quantiles(4,:), fliplr(Crop_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#a1d99b')

% Plotting Median
plot([1930:2017],Crop_quantiles(3,:),'Color','#43ac5e','LineWidth',2)

xlim([1930,2017])
xticks(xticks_p)
ylim([0,30])
yticks([0,15,30])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])
Figfolderpath = [OUTPUT_folderName,'Crop_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'Crop_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% Ag surplus

figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

% Setting up the 5-95th percentile band
Y = [AgSurplus_quantiles(5,:), fliplr(AgSurplus_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#AADEE4')

hold on

% Setting up the 25th-75th percentile
Y = [AgSurplus_quantiles(4,:), fliplr(AgSurplus_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#7CCDD6')

% Plotting Median
plot([1930:2017],AgSurplus_quantiles(3,:),'Color','#2C7FB8','LineWidth',2)

xlim([1930,2017])
xticks(xticks_p)
ylim([-15,30])
yticks([-15, 0, 15, 30])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])
Figfolderpath = [OUTPUT_folderName,'AgSurp_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'AgSurp_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% PUE
figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

% Setting up the 5-95th percentile band
Y = [PUE_quantiles(5,:), fliplr(PUE_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#fddcbc')

hold on

% Setting up the 25th-75th percentile
Y = [PUE_quantiles(4,:), fliplr(PUE_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'LineStyle','none', 'FaceColor', '#fd9243')

% Plotting Median
plot([1930:2017], PUE_quantiles(3,:),'Color','#7f2704','LineWidth',2)

xlim([1930,2017])
xticks(xticks_p)
ylim([0,2])
yticks([0, 1, 2])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])
Figfolderpath = [OUTPUT_folderName,'PUE_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_folderName,'PUE_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all