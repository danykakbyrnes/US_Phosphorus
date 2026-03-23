clc, clear

%% Calculating PUE at the gridscale.
loadenv('.env')
% Getting filepaths form .env file
INPUT_filepath = getenv('POSTPROCESSED_TREND');
OUTPUT_filepath = getenv('PHOS_USE_EFFICIENCY');

cropFolder = 'Crop_and_Pasture_P_Uptake/';
fertilizerFolder = 'Farm_P_Fertilizer/';
livestockFolder = 'Livestock_Waste_P_All/';
mkdir([OUTPUT_filepath])

YEARS = 1930:2017;
workers = 8; % Changed based on your available CPU cores

% Getting metadata for TIFF files
[~,georef] = readgeoraster([INPUT_filepath,livestockFolder,'Livestock_1930.tif']);
Rinfo = geotiffinfo([INPUT_filepath,livestockFolder,'Livestock_1930.tif']);

% Calculate PUE and save the TIFF file
delete(gcp('nocreate')); % Close any pools that might already be running
parpool('local', workers);
parfor i = 1:length(YEARS)
   
    YEAR_i = YEARS(i);
    
    file_lvsk_i = dir([INPUT_filepath, livestockFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Livestock_i,~] = readgeoraster([INPUT_filepath, livestockFolder,'\',file_lvsk_i.name]);
    
    file_fert_i = dir([INPUT_filepath, fertilizerFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Fertilizer_i,~] = readgeoraster([INPUT_filepath, fertilizerFolder,'\',file_fert_i.name]);
    
    file_crop_i = dir([INPUT_filepath, cropFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Crop_i,~] = readgeoraster([INPUT_filepath, cropFolder,'\',file_crop_i.name]);

    % Calculating PUE with integers. 
    PUE = Crop_i ./(Livestock_i + Fertilizer_i);
    PUE(isinf(PUE)) = NaN;
    
    geotiffwrite([OUTPUT_filepath, '\PUE_', num2str(YEAR_i),'.tif'], PUE, ...
    georef, 'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));

end
delete(gcp('nocreate')); % Close any pools that were running