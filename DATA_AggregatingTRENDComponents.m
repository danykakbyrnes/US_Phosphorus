%% Aggregating the raw gTREND files
% We use the raw gTREND components and aggregate the different components
% into groups that we use for analysis.

clc, clear
loadenv('.env')

% Read in gif files
INPUT_filepath = getenv('TREND_INPUT');
OUTPUT_filepath =  getenv('POSTPROCESSED_TREND');

YEARS = [1930:2017];
workers = 12; % Changed based on your available CPU cores

% Initializing the rasters.
[D_empty,georef] = readgeoraster([INPUT_filepath,'Farm_P_Fertilizer\Fertilizer_Ag_1930.tif']);
D_empty(~isnan(D_empty)) = 0;

% Getting raster information
Rinfo = geotiffinfo([INPUT_filepath,'Farm_P_Fertilizer\Fertilizer_Ag_1930.tif']);

%% Livestock -- Aggregating all livestock types
% Creating an empty raster. 
folderName = 'Livestock_Waste_P_All\';
mkdir([OUTPUT_filepath, folderName])
    
delete(gcp('nocreate')); % Close any pools that might already be running
parpool('local',workers);

files = dir([INPUT_filepath,folderName, '\*.tif']);

parfor i = 1:length(files)
[A,~] = readgeoraster([INPUT_filepath, folderName,'\',files(i).name]);
geotiffwrite([OUTPUT_filepath, folderName,'\',files(i).name], A, georef, ...
'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
'TiffTags',struct('Compression',Tiff.Compression.LZW));
end

%% Crop Uptake 
folderName = 'Crop_and_Pasture_P_Uptake\';
mkdir([OUTPUT_filepath, folderName])
    
delete(gcp('nocreate')); % Close any pools that might already be running
parpool('local',workers);

files = dir([INPUT_filepath,folderName, '\*.tif']);

parfor i = 1:length(files)
[A,~] = readgeoraster([INPUT_filepath, folderName,'\',files(i).name]);
geotiffwrite([OUTPUT_filepath, folderName,'\',files(i).name], A, georef, ...
'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
'TiffTags',struct('Compression',Tiff.Compression.LZW));
end

%% Agriculture Fertilizer
% Agricultural fertilizer does not need aggregation. We are just moving it
% to the project folder. 
folderName = 'Farm_P_Fertilizer'; 
mkdir([OUTPUT_filepath, folderName])

delete(gcp('nocreate')); % Close any pools that might already be running
parpool('local',workers);

files = dir([INPUT_filepath,folderName, '\*.tif']);

parfor i = 1:length(files)
[A,~] = readgeoraster([INPUT_filepath, folderName,'\',files(i).name]);
geotiffwrite([OUTPUT_filepath, folderName,'\',files(i).name], A, georef, ...
'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
'TiffTags',struct('Compression',Tiff.Compression.LZW));
end

%% Agricultural P Surplus

folderName = 'Ag_Surplus';
mkdir([OUTPUT_filepath, folderName])

SURP_INPUTS_files = [{'Farm_P_Fertilizer'};
                    {'Livestock_Waste_P_All'}];
SURP_OUTPUT_files = 'Crop_and_Pasture_P_Uptake';

for i = 1:length(YEARS)
YEAR_i = YEARS(i); 
D = D_empty;
for j = 1:length(SURP_INPUTS_files)
    folder_j = SURP_INPUTS_files{j}; 
   
    % Summing fertilizer and manure inputs
    file_j = dir([OUTPUT_filepath, folder_j,'\*_',num2str(YEAR_i),'.tif']);
    [A,~] = readgeoraster([OUTPUT_filepath, folder_j,'\',file_j.name]);
    D = A + D;
end

% Removing P from crop uptake
file_j = dir([OUTPUT_filepath, SURP_OUTPUT_files,'\*_',num2str(YEAR_i),'.tif']);
    [A,~] = readgeoraster([OUTPUT_filepath, SURP_OUTPUT_files,'\',file_j.name]);
    D = D - A; 

geotiffwrite([OUTPUT_filepath, folderName,'\','Ag_Surplus_',...
num2str(YEAR_i),'.tif'], D, georef, ...
    'GeoKeyDirectoryTag',Rinfo.GeoTIFFTags.GeoKeyDirectoryTag, ...
    'TiffTags',struct('Compression',Tiff.Compression.LZW));
end
delete(gcp('nocreate')); % Close pools