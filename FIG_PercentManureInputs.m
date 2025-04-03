clc, clear

%% Finding the distribution of dominant manure inputs (vs. tot fertilizer) 
% Filepaths
OUTPUTfilepath = '..\OUTPUTS\PUE_drivers\';
trendINPUTfilepath = ['..\..\3_TREND_Nutrients\TREND_Nutrients\OUTPUT\',...
    'Grid_TREND_P_Version_1\TREND-P_Postpocessed_Gridded_2023-11-18\'];

% Figure aesthetics 
fontSize_p = 11;
fontSize_p2 = 8; 
plot_dim = [200,200,400,200];
plot_dim_2 = [200,200,350,425];
mSize = 4; 

% Loading in the files
PUEfilepath = '..\OUTPUTS\PUE\PUE_2017.tif';

fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU\';
livestockFolder = 'Lvst_Agriculture_LU\';

[PUE2017,~] = readgeoraster(PUEfilepath);

[LVSTK2017,georef] = readgeoraster([trendINPUTfilepath,livestockFolder,...
                               'Lvst_2017.tif']);
Rinfo = geotiffinfo([trendINPUTfilepath,livestockFolder,...
                               'Lvst_2017.tif']);
[FERT2017,~] = readgeoraster([trendINPUTfilepath,fertilizerFolder,...
                              'Fertilizer_Ag_2017.tif']);

% Manipuating the data
PUE2017_v = double(PUE2017(:));
LVSTK2017_v = double(LVSTK2017(:));
FERT2017_v = double(FERT2017(:));

% Removing the cells with no data because of no agricultural land
DisnanIDX = (PUE2017_v == 0 | isnan(PUE2017_v));
PUE2017_v = PUE2017_v(DisnanIDX < 1, :);
LVSTK2017_v = LVSTK2017_v(DisnanIDX < 1, :);
FERT2017_v = FERT2017_v(DisnanIDX < 1, :);

% Removing the boxes that have no quadrant in 
D = [PUE2017_v, LVSTK2017_v, FERT2017_v,...
                      LVSTK2017_v./(FERT2017_v+LVSTK2017_v)];

%% FIGURE X: PUE vs. % manure
close all
%binscatter(D(:,1), D(:,4), [40 80], ...
%    'ShowEmptyBins', 'on')
hexscatter(D(:,1), D(:,4), ...
    'res', [80,40],...
    'showZeros', 1)

xlabel('PUE [-]')
xlim([0,2])
ylim([0,1])
ylabel('Manure to Total Input Ratio')

colorMap = [15,37,30;
            64, 150, 122;
            249, 255, 253]./255;
map = interp1([0;50;100], colorMap,linspace(100,0,248),'pchip');
colormap(map);
%colormap summer
colorbar;
caxis([0, 8*10^4]);

box on
set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3, ...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'}, ...
    {'k','k','k'});
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

set(gcf,'position',plot_dim_2)

Figfolderpath = [OUTPUTfilepath,'manure_totalInput_hexplot.png'];
print('-dpng','-r600',[Figfolderpath])