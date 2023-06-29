clc, clear

%% Calculating PUE at the gridscale.

% Read in gif files
INPUTfilepath = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded\'];
OUTPUTfilepath = '..\OUTPUTS\CropFertRatio\';
YEARS = 1930:2017;

cropFolder = 'CropUptake_Agriculture_Agriculture_LU';
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';

delete(gcp('nocreate')); % Close any pools that might already be running
parpool('local',6);
[~,georef] = readgeoraster([INPUTfilepath,cropFolder,'\CropUptake_Ag_1930.tif']);
Rinfo = geotiffinfo([INPUTfilepath,cropFolder,'\CropUptake_Ag_1930.tif']);

% calculate PUE and save the tif file

parfor i = 1:length(YEARS)
   
    YEAR_i = YEARS(i);
    
    file_fert_i = dir([INPUTfilepath, fertilizerFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Fertilizer_i,~] = readgeoraster([INPUTfilepath, fertilizerFolder,'\',file_fert_i.name]);
   
    file_crop_i = dir([INPUTfilepath, cropFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Crop_i,~] = readgeoraster([INPUTfilepath, cropFolder,'\',file_crop_i.name]);
    
    % Convert ints32 to doubles. 
    Fertilizer_i = double(Fertilizer_i);
    Crop_i = double(Crop_i);

    % Calculating PUE with integers. 
    CF_ratio = Crop_i ./Fertilizer_i;
    CF_ratio(isinf(CF_ratio)) = 0;
    
    geotiffwrite([OUTPUTfilepath, '\CFR_', num2str(YEAR_i),'.tif'], CF_ratio, ...
    georef, 'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));

end
delete(gcp('nocreate')); % Close any pools that were running