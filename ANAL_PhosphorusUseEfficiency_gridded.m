clc, clear

%% Calculating PUE at the gridscale.

% Read in gif files
INPUTfilepath = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded\'];
OUTPUTfilepath = '..\OUTPUTS\PUE\';
YEARS = 1930:2017;

livestockFolder = 'CropUptake_Agriculture_Agriculture_LU';
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
cropFolder = 'Lvst_Agriculture_LU';

delete(gcp('nocreate')); % Close any pools that might already be running
parpool('local',12);

Rinfo = geotiffinfo([INPUTfilepath,'Lvst_BeefCattle_Agriculture_LU\BeefCattle_1930.tif']);

% calculate PUE and save the tif file

parfor i = 1:length(YEARS)
   
    YEAR_i = YEARS(i);
    %PUE_fert = Crop_var./allFetilizer;
    file_lvsk_i = dir([INPUTfilepath, livestockFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Livestock_i,~] = readgeoraster([INPUTfilepath, livestockFolder,'\',file_lvsk_i.name]);
    
    file_fert_i = dir([INPUTfilepath, fertilizerFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Fertilizer_i,~] = readgeoraster([INPUTfilepath, fertilizerFolder,'\',file_fert_i.name]);
    
    Inputs = Livestock_i + Fertilizer_i;
    
    Inputs(find(Inputs == 0)) = NaN; 
    
    file_crop_i = dir([INPUTfilepath, livestockFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Crop_i,~] = readgeoraster([INPUTfilepath, livestockFolder,'\',file_crop_i.name]);
    
    % Convert ints32 to doubles. 
    Livestock_i = single(Livestock_i);
    Fertilizer_i = single(Fertilizer_i);
    Crop_i = single(Crop_i);

    % Calculating PUE with integers. 
    PUE = Crop_i ./Inputs;
    
    PUE = PUE*1000;

    geotiffwrite([OUTPUTfilepath, '\PUE_', num2str(YEAR_i),'.tif'], int32(PUE), ...
    georef, 'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));

end

