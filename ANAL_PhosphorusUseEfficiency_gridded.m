clc, clear

%% Calculating PUE at the gridscale.

% Read in gif files
INPUTfilepath = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded\'];
OUTPUTfilepath = '..\OUTPUTS\PUE\';
YEARS = [1930:2017];

livestockFolder = 'CropUptake_Agriculture_Agriculture_LU';
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
cropFolder = 'Lvst_Agriculture_LU';

delete(gcp('nocreate')); % Close any pools that might already be running
parpool('local',4);

Rinfo = geotiffinfo([INPUTfilepath,'Lvst_BeefCattle_Agriculture_LU\BeefCattle_1930.tif']);

% calculate PUE and save the tif file

for i = 1:length(YEARS)
   
    YEAR_i = YEARS(i);
    %PUE_fert = Crop_var./allFetilizer;
    file_lvsk_i = dir([INPUTfilepath, livestockFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Livestock_i,~] = readgeoraster([INPUTfilepath, livestockFolder,'\',file_lvsk_i.name]);
    
    file_fert_i = dir([INPUTfilepath, fertilizerFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Fertilizer_i,~] = readgeoraster([INPUTfilepath, fertilizerFolder,'\',file_fert_i.name]);
    
    Inputs = Livestock_i + Fertilizer_i;
    
    file_crop_i = dir([INPUTfilepath, livestockFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Crop_i,~] = readgeoraster([INPUTfilepath, livestockFolder,'\',file_crop_i.name]);

    PUE = Crop_i ./Inputs;
    
    geotiffwrite([OUTPUTfilepath, '\PUE_', num2str(YEAR_i),'.tif'], PUE, ...
    georef, 'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));

end

