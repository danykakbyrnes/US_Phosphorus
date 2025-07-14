clc, clear

% Read in gif files
OUTPUTfilepath = getenv('QUADRANT_ANALYSIS');
TRENDfilepath = getenv('POSTPROCESSED_TREND');
PUEFolder = getenv('PHOS_USE_EFFICIENCY');
CUMSUMFolder = getenv('CUMULATIVE_PHOS');

% Getting metadata for TIFF files
[~,georef] = readgeoraster([TRENDfilepath,'Lvst_Agriculture_LU/Lvst_1930.tif']);
Rinfo = geotiffinfo([TRENDfilepath,'Lvst_Agriculture_LU/Lvst_1930.tif']);

% Setting bounds of quadrant
loadstar_CumSum = 0; 
loadstar_PUE = 1;

[PUE2017,~] = readgeoraster([PUEfilepath, 'PUE_2017.tif']);
[CS2017,~] = readgeoraster([CUMSUMfilepath,'CumSum_2017.tif']);

[PUE1980,~] = readgeoraster([PUEfilepath, 'PUE_1980.tif']);
[CS1980,~] = readgeoraster([CUMSUMfilepath,'CumSum_1980.tif']);

PUE2017(find(PUE2017 > 2^20)) = 0;
CS2017(find(CS2017 > 2^20)) = 0;

PUE1980(find(PUE1980 > 2^20)) = 0;
CS1980(find(CS1980 > 2^20)) = 0;

% Making the grid cells the same between 1980 and 2017
nanMask = isnan(PUE2017) | isnan(CS2017) | isnan(PUE1980) | isnan(CS1980);

% Apply the mask to all rasters at once
PUE2017(nanMask) = NaN;
CS2017(nanMask) = NaN;
PUE1980(nanMask) = NaN;
CS1980(nanMask) = NaN;

% 2017
Q = zeros(size(CS2017));
for i = 1:numel(Q)
   
    if CS2017(i) > loadstar_CumSum
        if PUE2017(i) > loadstar_PUE
            Q(i)  = 1; 
        elseif PUE2017(i) <= loadstar_PUE
            Q(i)  = 2; 
        end
    elseif CS2017(i) <= loadstar_CumSum
        if PUE2017(i) > loadstar_PUE
            Q(i)  = 4;
        elseif PUE2017(i) <= loadstar_PUE
             Q(i)  = 3; 
        end
    end
end

outputFilename = 'QuadrantMap_2017.tif';
geotiffwrite([OUTPUTfilepath,outputFilename], Q, georef, ...
    'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));

% 1980
Q = zeros(size(PUE1980));
for i = 1:numel(Q)
   
    if CS1980(i) > loadstar_CumSum
        if PUE1980(i) > loadstar_PUE
            Q(i)  = 1; 
        elseif PUE1980(i) <= loadstar_PUE
            Q(i)  = 2; 
        end
    elseif CS1980(i) <= loadstar_CumSum
        if PUE1980(i) > loadstar_PUE
            Q(i)  = 4;
        elseif PUE1980(i) <= loadstar_PUE
             Q(i)  = 3; 
        end
    end
end

outputFilename = 'QuadrantMap_1980.tif';
geotiffwrite([OUTPUTfilepath,outputFilename], Q, georef, ...
    'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));