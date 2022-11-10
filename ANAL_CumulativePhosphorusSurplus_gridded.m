clc, clear

%% Calculating PUE at the gridscale.
% Read in gif files
INPUTfilepath = ['..\..\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\',...
    'Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded\'];
OUTPUTfilepath = '..\OUTPUTS\Cumulative Phosphorus\';
YEARS = 1930:2017;

cropFolder = 'CropUptake_Agriculture_Agriculture_LU';
fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU';
livestockFolder = 'Lvst_Agriculture_LU';

[~,georef] = readgeoraster([INPUTfilepath,'Lvst_BeefCattle_Agriculture_LU\BeefCattle_1930.tif']);
Rinfo = geotiffinfo([INPUTfilepath,'Lvst_BeefCattle_Agriculture_LU\BeefCattle_1930.tif']);

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
    
    % Convert ints32 to doubles. 
    Livestock_i = single(Livestock_i)./1000;
    Fertilizer_i = single(Fertilizer_i)./1000;
    Crop_i = single(Crop_i)./1000;

    CumulativeP = CumulativeP + (Livestock_i + Fertilizer_i - Crop_i); 

   exportCumSum = CumulativeP; 
   exportCumSum(exportCumSum == 0) = NaN; 
    geotiffwrite([OUTPUTfilepath, '\CumSum_', num2str(YEAR_i),'.tif'], exportCumSum, ...
    georef, 'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));
end