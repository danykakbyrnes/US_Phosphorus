clc, clear

%% Calculating PUE at the gridscale.
loadenv('.env')
% Getting filepaths form .env file
INPUTfilepath = getenv('POSTPROCESSED_TREND');
OUTPUTfilepath = getenv('PHOS_USE_EFFICIENCY');

cropFolder = 'CropUptake_Agriculture_Agriculture_LU';
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
livestockFolder = 'Lvst_Agriculture_LU';

YEARS = 1930:2017;

% Getting metadata for TIFF files
[~,georef] = readgeoraster([INPUTfilepath,livestockFolder,'Lvst_1930.tif']);
Rinfo = geotiffinfo([INPUTfilepath,livestockFolder,'Lvst_1930.tif']);

% Calculate PUE and save the TIFF file
parpool('local', 12);
parfor i = 1:length(YEARS)
   
    YEAR_i = YEARS(i);
    %PUE_fert = Crop_var./allFetilizer;
    file_lvsk_i = dir([INPUTfilepath, livestockFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Livestock_i,~] = readgeoraster([INPUTfilepath, livestockFolder,'\',file_lvsk_i.name]);
    
    file_fert_i = dir([INPUTfilepath, fertilizerFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Fertilizer_i,~] = readgeoraster([INPUTfilepath, fertilizerFolder,'\',file_fert_i.name]);
    
    file_crop_i = dir([INPUTfilepath, cropFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Crop_i,~] = readgeoraster([INPUTfilepath, cropFolder,'\',file_crop_i.name]);

    % Calculating PUE with integers. 
    PUE = Crop_i ./(Livestock_i + Fertilizer_i);
    PUE(isinf(PUE)) = NaN;
    
    geotiffwrite([OUTPUTfilepath, '\PUE_', num2str(YEAR_i),'.tif'], PUE, ...
    georef, 'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));

end
delete(gcp('nocreate')); % Close any pools that were running