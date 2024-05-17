clc, clear

% Read in gif files
PUEfilepath = '..\OUTPUTS\PUE\';
CUMSUMfilepath = '..\OUTPUTS\Cumulative Phosphorus\';
OUTPUTfilepath = '..\OUTPUTS\Quadrants\';
RasterINPUTfilepath = '..\..\3_TREND_Nutrients\TREND_Nutrients\OUTPUT\Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded (2023-11-18)\';

[D_empty,georef] = readgeoraster([RasterINPUTfilepath,'Surplus_P\Surplus_P_1930.tif']);
% Getting raster information
Rinfo = geotiffinfo([RasterINPUTfilepath,'Surplus_P\Surplus_P_1930.tif']);

loadstar_CumSum = 0; %median(D(:,1),'omitnan');
loadstar_PUE = 1;% median(D(:,3),'omitnan');

% binscatter(x,y)   
[PUE2017,~] = readgeoraster([PUEfilepath, 'PUE_2017.tif']);
[CS2017,~] = readgeoraster([CUMSUMfilepath,'CumSum_2017.tif']);

Q = zeros(size(CS2017));
for i = 1:numel(Q)
   
    if CS2017(i) > loadstar_CumSum
        if PUE2017(i) > loadstar_PUE
            Q(i)  = 1; 
        elseif PUE2017(i) <= loadstar_PUE
            Q(i)  = 4; 
        end
    elseif CS2017(i) <= loadstar_CumSum
        if PUE2017(i) > loadstar_PUE
            Q(i)  = 2;
        elseif PUE2017(i) <= loadstar_PUE
             Q(i)  = 3; 
        end
    end
end

outputFilename = 'QuadrantMap_2017.tif';
geotiffwrite([OUTPUTfilepath,outputFilename], Q, georef, ...
'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
'TiffTags',struct('Compression',Tiff.Compression.LZW));

%% 1980

[PUE1980,~] = readgeoraster([PUEfilepath, 'PUE_1980.tif']);
[CS1980,~] = readgeoraster([CUMSUMfilepath,'CumSum_1980.tif']);

PUE1980(find(PUE1980 > 2^20)) = 0;
CS1980(find(CS1980 > 2^20)) = 0;

Q = zeros(size(PUE1980));
for i = 1:numel(Q)
   
    if CS1980(i) > loadstar_CumSum
        if PUE1980(i) > loadstar_PUE
            Q(i)  = 1; 
        elseif PUE1980(i) <= loadstar_PUE
            Q(i)  = 4; 
        end
    elseif CS1980(i) <= loadstar_CumSum
        if PUE1980(i) > loadstar_PUE
            Q(i)  = 2;
        elseif PUE1980(i) <= loadstar_PUE
             Q(i)  = 3; 
        end
    end
end

outputFilename = 'QuadrantMap_1980.tif';
geotiffwrite([OUTPUTfilepath,outputFilename], Q, georef, ...
    'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));