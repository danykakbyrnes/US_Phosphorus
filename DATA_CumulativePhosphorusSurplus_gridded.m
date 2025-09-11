clc, clear

%% Creating TIFF files of Cumulative P Surplus at the gridscale. 
loadenv('.env')
% Getting filepaths form .env file
INPUT_filepath = getenv('POSTPROCESSED_TREND');
OUTPUT_filepath = getenv('CUMULATIVE_PHOS');

cropFolder = 'CropUptake_Agriculture_Agriculture_LU\';
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU\';
livestockFolder = 'Lvst_Agriculture_LU\';
csFolder = 'PUE/';

YEARS = 1930:2017;

% Getting metadata for TIFF files
[~,georef] = readgeoraster([INPUT_filepath,livestockFolder,'Lvst_1930.tif']);
Rinfo = geotiffinfo([INPUT_filepath,livestockFolder,'Lvst_1930.tif']);

CumulativeP = zeros(georef.RasterSize);
CumulativeP = single(CumulativeP);

mkdir([OUTPUT_filepath])

for i = 1:length(YEARS)
    YEAR_i = YEARS(i);
    file_lvsk_i = dir([INPUT_filepath, livestockFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Livestock_i,~] = readgeoraster([INPUT_filepath, livestockFolder,'\',file_lvsk_i.name]);
    
    file_fert_i = dir([INPUT_filepath, fertilizerFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Fertilizer_i,~] = readgeoraster([INPUT_filepath, fertilizerFolder,'\',file_fert_i.name]);
    
    file_crop_i = dir([INPUT_filepath, cropFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Crop_i,~] = readgeoraster([INPUT_filepath, cropFolder,'\',file_crop_i.name]);
    
    CumulativeP = CumulativeP + (Livestock_i + Fertilizer_i - Crop_i);

   exportCumSum = CumulativeP; 
   exportCumSum(exportCumSum == 0) = NaN; 
    geotiffwrite([OUTPUT_filepath, '\CumSum_', num2str(YEAR_i),'.tif'], exportCumSum, ...
    georef, 'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));
end