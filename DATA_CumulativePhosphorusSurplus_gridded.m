clc, clear

%% Creating TIFF files of Cumulative P Surplus at the gridscale. 
loadenv('.env')
% Getting filepaths form .env file
INPUTfilepath = getenv('TREND_INPUT');
OUTPUTfilepath = getenv('CUMULATIVE_PHOS');

cropFolder = 'CropUptake_Agriculture_Agriculture_LU';
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
livestockFolder = 'Lvst_Agriculture_LU';

YEARS = 1930:2017;

% Getting metadata for TIFF files
[~,georef] = readgeoraster([INPUTfilepath,'Lvst_Agriculture_LU\Lvst_1930.tif']);
Rinfo = geotiffinfo([INPUTfilepath,'Lvst_Agriculture_LU\Lvst_1930.tif']);

CumulativeP = zeros(georef.RasterSize);
CumulativeP = single(CumulativeP);

for i = 1:length(YEARS)
    YEAR_i = YEARS(i);
    file_lvsk_i = dir([INPUTfilepath, livestockFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Livestock_i,~] = readgeoraster([INPUTfilepath, livestockFolder,'\',file_lvsk_i.name]);
    
    file_fert_i = dir([INPUTfilepath, fertilizerFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Fertilizer_i,~] = readgeoraster([INPUTfilepath, fertilizerFolder,'\',file_fert_i.name]);
    
    file_crop_i = dir([INPUTfilepath, cropFolder,'\*_',num2str(YEAR_i),'.tif']);
    [Crop_i,~] = readgeoraster([INPUTfilepath, cropFolder,'\',file_crop_i.name]);
    
    CumulativeP = CumulativeP + (Livestock_i + Fertilizer_i - Crop_i); 

   exportCumSum = CumulativeP; 
   exportCumSum(exportCumSum == 0) = NaN; 
    geotiffwrite([OUTPUTfilepath, '\CumSum_', num2str(YEAR_i),'.tif'], exportCumSum, ...
    georef, 'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));
end