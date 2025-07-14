clc, clear, close all
% ------------------------------------------------------------------------
% MAKING COMPONENT AND SURPLUS TIMESERIES TIMESERIES FOR FIGURE 1
%   Read in each tif file, vetorize and take the median, and quanties per
%   year. 
% ------------------------------------------------------------------------
runTiffs = 1 ;
% Read in tif files
TREND_filepath = getenv('POSTPROCESSED_TREND');
PUEINPUT_filepath = getenv('PHOS_USE_EFFICIENCY');
OUTPUT_filepath = getenv('COMPONENT_TIMESERIES');

cropFolder = 'CropUptake_Agriculture_Agriculture_LU\';
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU/';
livestockFolder = 'Lvst_Agriculture_LU/';
agsurplusFolder = 'Ag_Surplus/';

YEARS = 1930:2017;
% Aesthetic attributes
% Plot Specs
fontSize_p = 7;
median_LW = 1;
xticks_p = [1930, 1970, 2010];
xtick_len = 0.5;
plot_dim = [50,50,130,120];
plot_dim2 = [50,50,250,225];

%% Running Code

if runTiffs == 1
    % Reading in Manure Files 
    Livestock_quantiles = zeros(5,length(YEARS));
    Livestock_average = zeros(1,length(YEARS));
    for i = 1:length(YEARS)
        YEAR_i = YEARS(i);
        file_lvsk_i = dir([TREND_filepath, livestockFolder,'*_',num2str(YEAR_i),'.tif']);
        [Tif_i,~] = readgeoraster([TREND_filepath, livestockFolder,file_lvsk_i.name]);
        
        % Converting the file
        Tif_i = single(Tif_i); 
        
        Tif_i(Tif_i == 0) = NaN; 
        Tif_linear = Tif_i(:); 
            
        QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
        
        Livestock_quantiles(:,i) = QLV;
        Livestock_average(1,i) = mean(Tif_linear,'omitnan');
    end
    
    %% Reading in Fetilizer Files 
    Fertilizer_quantiles = zeros(5,length(YEARS));
    Fertilizer_average = zeros(1,length(YEARS));
    
    for i = 1:length(YEARS)
        YEAR_i = YEARS(i);
        file_fert_i = dir([TREND_filepath, fertilizerFolder,'*_',num2str(YEAR_i),'.tif']);
        [Tif_i,~] = readgeoraster([TREND_filepath, fertilizerFolder,file_fert_i.name]);
        
        % Converting the file
        Tif_i = single(Tif_i); 
        
        Tif_i(Tif_i == 0) = NaN; 
        Tif_linear = Tif_i(:); 
            
        QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
        
        Fertilizer_quantiles(:,i) = QLV;
        Fertilizer_average(1,i) = mean(Tif_linear, 'omitnan');
    end
    
    %% Reading in Crop Files 
    Crop_quantiles = zeros(5,length(YEARS));
    Crop_average = zeros(1,length(YEARS));
    for i = 1:length(YEARS)
        YEAR_i = YEARS(i);
        file_fert_i = dir([TREND_filepath, cropFolder,'*_',num2str(YEAR_i),'.tif']);
        [Tif_i,~] = readgeoraster([TREND_filepath, cropFolder,file_fert_i.name]);
        
        % Converting the file
        Tif_i = single(Tif_i); 
        
        Tif_i(Tif_i == 0) = NaN; 
        Tif_linear = Tif_i(:); 
            
        QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
        
        Crop_quantiles(:,i) = QLV;
        Crop_average(1,i) = mean(Tif_linear, 'omitnan');
    end
    
    %% Reading in Ag Surplus Files 
    AgSurplus_quantiles = zeros(5,length(YEARS));
    for i = 1:length(YEARS)
        YEAR_i = YEARS(i);
        file_agsur_i = dir([TREND_filepath,agsurplusFolder,'*_',num2str(YEAR_i),'.tif']);
        [Tif_i,~] = readgeoraster([TREND_filepath,agsurplusFolder,file_agsur_i.name]);
        
        % Converting the file
        Tif_i = single(Tif_i); 
        
        Tif_i(Tif_i == 0) = NaN; 
        Tif_linear = Tif_i(:); 
            
        QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
        
        AgSurplus_quantiles(:,i) = QLV;
    end
    
    save([OUTPUT_filepath, '\ComponentQuantiles.mat'], ...
        'Fertilizer_quantiles','Crop_quantiles', ...
        'Livestock_quantiles','AgSurplus_quantiles')
    
    
    %% PUE
    PUE_quantiles = zeros(5,length(YEARS));
    for i = 1:length(YEARS)
        YEAR_i = YEARS(i);
        file_pue_i = dir([PUEINPUT_filepath,'\*_',num2str(YEAR_i),'.tif']);
        [Tif_i,~] = readgeoraster([PUEINPUT_filepath,'\',file_pue_i.name]);
        
        % Converting the file    
        Tif_linear = Tif_i(:); 
            
        QLV = quantile(Tif_linear, [0.05, 0.25,0.5,0.75, 0.95]);
        
        PUE_quantiles(:,i) = QLV;
    end
    PUE_mean = Crop_average./(Fertilizer_average+Livestock_average);
    save([OUTPUT_filepath, 'PUE_mean.mat'],'PUE_mean')
    
    save([OUTPUT_filepath, 'ComponentQuantiles.mat'],'Fertilizer_quantiles', ...
        'Crop_quantiles','Livestock_quantiles','AgSurplus_quantiles', ...
        'PUE_quantiles')
end

%% Timeseries plots
load([OUTPUT_filepath, 'ComponentQuantiles.mat'])

%% Livestock

figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

Color = [];

% Setting up the 5-95th percentile band
Y = [Livestock_quantiles(5,:), fliplr(Livestock_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor', '#807BB7', 'FaceColor', '#bcbddc')


hold on

% Setting up the 25th-75th percentile
Y = [Livestock_quantiles(4,:), fliplr(Livestock_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor','#acacd2', 'FaceColor', '#807dba')

% Plotting Median   
plot([1930:2017],Livestock_quantiles(3,:),'Color','#54278f','LineWidth',median_LW)

% Editing the Axes
xlim([1929,2018])
xticks(xticks_p)
ylim([0,40])
yticks([0,20,40])

h = gca; % Get axis to modify
set(h,'TickLength',[0.022, 0.001])
set(h,'XMinorTick','on','YMinorTick','off')
h.XAxis.MinorTickValues = 1930:10:2017; % Minor ticks which don't line up with majors
set(h,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(h,'XColor',[0,0,0])
set(h,'YColor',[0,0,0])
set(h,'ZColor',[0,0,0])
box('on')

% Saving the figure
set(gcf,'position',plot_dim)
Figfolderpath = [OUTPUT_filepath,'Livestock_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_filepath,'Livestock_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% Fertilizer

figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

% Setting up the 5-95th percentile band
Y = [Fertilizer_quantiles(5,:), fliplr(Fertilizer_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor','#FBA683', 'FaceColor', '#fcbba1')

hold on

% Setting up the 25th-75th percentile
Y = [Fertilizer_quantiles(4,:), fliplr(Fertilizer_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor','#fb6a4a', 'FaceColor', '#fb6a4a')

% Plotting Median
plot([1930:2017],Fertilizer_quantiles(3,:),'Color','#d32020','LineWidth',median_LW)

% Editing the Axes
xlim([1929,2018])
xticks(xticks_p)
ylim([0,30])
yticks([0,15,30])

h = gca; % Get axis to modify
set(h,'TickLength',[0.022, 0.001])
set(h,'XMinorTick','on','YMinorTick','off')
h.XAxis.MinorTickValues = 1930:10:2017; % Minor ticks which don't line up with majors
set(h,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(h,'XColor',[0,0,0])
set(h,'YColor',[0,0,0])
set(h,'ZColor',[0,0,0])
box('on')

% Saving the figure
set(gcf,'position',plot_dim)
Figfolderpath = [OUTPUT_filepath,'Fertilizer_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_filepath,'Fertilizer_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])

close all

%% Crop Uptake

figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

% Setting up the 5-95th percentile band
Y = [Crop_quantiles(5,:), fliplr(Crop_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor','#60A659', 'FaceColor', '#60A659')

hold on

% Setting up the 25th-75th percentile
Y = [Crop_quantiles(4,:), fliplr(Crop_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor','#59A662', 'FaceColor', '#59A662')

% Plotting Median
plot([1930:2017],Crop_quantiles(3,:),'Color','#26472A','LineWidth',median_LW)

% Editing the Axes
xlim([1929,2018])
xticks(xticks_p)
ylim([0,30])
yticks([0,15,30])

h = gca; % Get axis to modify
set(h,'TickLength',[0.022, 0.001])
set(h,'XMinorTick','on','YMinorTick','off')
h.XAxis.MinorTickValues = 1930:10:2017; % Minor ticks which don't line up with majors
set(h,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(h,'XColor',[0,0,0])
set(h,'YColor',[0,0,0])
set(h,'ZColor',[0,0,0])
box('on')

% Saving the figure
set(gcf,'position',plot_dim)
Figfolderpath = [OUTPUT_filepath,'Crop_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_filepath,'Crop_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% Ag surplus

figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

% Setting up the 5-95th percentile band
Y = [AgSurplus_quantiles(5,:), fliplr(AgSurplus_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor','#8dccd3', 'FaceColor', '#8dccd3')

hold on

% Setting up the 25th-75th percentile
Y = [AgSurplus_quantiles(4,:), fliplr(AgSurplus_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor','#539fa8', 'FaceColor', '#539fa8')

% Plotting Median
plot([1930:2017],AgSurplus_quantiles(3,:),'Color','#1a5e66','LineWidth',median_LW)

% Editing the Axes
xlim([1929,2018])
xticks(xticks_p)
ylim([-10,30])
yticks([-10, 0, 10, 20 30])

h = gca; % Get axis to modify
set(h,'TickLength',[0.022, 0.001])
set(h,'XMinorTick','on','YMinorTick','off')
h.XAxis.MinorTickValues = 1930:10:2017; % Minor ticks which don't line up with majors
set(h,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(h,'XColor',[0,0,0])
set(h,'YColor',[0,0,0])
set(h,'ZColor',[0,0,0])
box('on')

% Saving the figure
set(gcf,'position',plot_dim)
Figfolderpath = [OUTPUT_filepath,'AgSurp_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_filepath,'AgSurp_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% PUE
figure(1) 
X = [[1930:2017], fliplr([1930:2017])];

% Setting up the 5-95th percentile band
Y = [PUE_quantiles(5,:), fliplr(PUE_quantiles(1,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor','#FFA54D', 'FaceColor', '#FFA54D')

hold on

% Setting up the 25th-75th percentile
Y = [PUE_quantiles(4,:), fliplr(PUE_quantiles(2,:))];
pgon = polyshape(X,Y);
plot(pgon, 'EdgeColor','#FD7B1C', 'FaceColor', '#FD7B1C')

% Plotting Median
plot([1930:2017], PUE_quantiles(3,:),'Color','#7f2704','LineWidth',median_LW)

% Editing the Axes
xlim([1929,2018])
xticks(xticks_p)
ylim([0,2])
yticks([0, 1, 2])

h = gca; % Get axis to modify
set(h,'TickLength',[0.022, 0.001])
set(h,'XMinorTick','on','YMinorTick','off')
h.XAxis.MinorTickValues = 1930:10:2017; % Minor ticks which don't line up with majors
set(h,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(h,'XColor',[0,0,0])
set(h,'YColor',[0,0,0])
set(h,'ZColor',[0,0,0])
box('on')

% Saving the figure
set(gcf,'position',plot_dim)
Figfolderpath = [OUTPUT_filepath,'PUE_grid_TS.svg'];
print('-dsvg','-r600',[Figfolderpath])
Figfolderpath = [OUTPUT_filepath,'PUE_grid_TS.png'];
print('-dpng','-r600',[Figfolderpath])
close all

%% Supplemental Figure for mean and median PUE. 
plot([1930:2017], PUE_quantiles(3,:), 'LineWidth', 1)
hold on
plot([1930:2017], PUE_mean, 'LineWidth', 1)

% Create ylabel
ylabel('PUE [-]');
xlim([1930, 2017])

box('on');

% Create legend
legend1 = legend('Median PUE', 'Mean PUE')
set(legend1,'EdgeColor',[1 1 1]);

% set window size
set(gcf, 'Position',  [100, 100, 300, 250])

Figfolderpath = [OUTPUT_filepath,'PUE_meanNational.png'];
print('-dpng','-r600',[Figfolderpath])