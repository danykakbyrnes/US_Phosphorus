clc, clear, close all

% Classifying each gridcell into a quadrant
loadenv('.env')

% Getting filepaths form .env file
OUTPUTfilepath = getenv('QUADRANT_ANALYSIS');
TRENDfilepath = getenv('POSTPROCESSED_TREND');
PUEFolder = getenv('PHOS_USE_EFFICIENCY');
CUMSUMFolder = getenv('CUMULATIVE_PHOS');

fertilizerFolder = 'Fertilizer_Agriculture_Agriculture_LU/';
livestockFolder = 'Lvst_Agriculture_LU/';

% These data (PUE + SURPcumu) has NaN for all cells that are not ag land. 
% Reading in 2017 data.
[PUE2017,~] = readgeoraster([PUEFolder, 'PUE_2017.tif']); % single
[CS2017,~] = readgeoraster([CUMSUMFolder, 'CumSum_2017.tif']); % single
[LVSTK2017,~] = readgeoraster([TRENDfilepath,livestockFolder,...
                               'Lvst_2017.tif']);
[FERT2017,~] = readgeoraster([TRENDfilepath,fertilizerFolder,...
                              'Fertilizer_Ag_2017.tif']);

PUE2017_v = PUE2017(:);
CS2017_v = CS2017(:);
LVSTK2017_v = double(LVSTK2017(:));
FERT2017_v = double(FERT2017(:));

% Reading in 1980 data.
[PUE1980,~] = readgeoraster([PUEFolder, 'PUE_1980.tif']); % single
[CS1980,~] = readgeoraster([CUMSUMFolder, 'CumSum_1980.tif']); % single

PUE1980_v = PUE1980(:);
CS1980_v = CS1980(:);

[LVSTK1980,~] = readgeoraster([TRENDfilepath,livestockFolder,...
                                'Lvst_1980.tif']);
[FERT1980,~] = readgeoraster([TRENDfilepath,fertilizerFolder,...
                                'Fertilizer_Ag_1980.tif']);

LVSTK1980_v = double(LVSTK1980(:));
FERT1980_v = double(FERT1980(:));

clear PUE2017 CS2017 PUE1980 CS1980 LVSTK2017 FERT2017 LVSTK1980 FERT1980

% Creating a matrix with available data.
D = [CS1980_v, CS2017_v,PUE1980_v, PUE2017_v,...
    LVSTK1980_v./(FERT1980_v + LVSTK1980_v),...
    LVSTK2017_v./(FERT2017_v + LVSTK2017_v)]; 

% Setting the quadrant divisions.
loadstar_CumSum = 0;
loadstar_PUE = 1;

% Assigning the data into quadrants.
% 1980
for i = 1:length(D)
   
    if D(i,1) > loadstar_CumSum
        if D(i,3) > loadstar_PUE
            D(i,7)  = 1; 
        elseif D(i,3) <= loadstar_PUE
            D(i,7)  = 2; 
        end
    elseif D(i,1) <= loadstar_CumSum
        if D(i,3) > loadstar_PUE
            D(i,7)  = 4;
        elseif D(i,3) <= loadstar_PUE
            D(i,7)  = 3; 
        end
    end
end

% 2017
for i = 1:length(D)
   
    if D(i,2) > loadstar_CumSum
        if D(i,4) > loadstar_PUE
            D(i,8)  = 1; 
        elseif D(i,4) <= loadstar_PUE
            D(i,8)  = 2; 
        end
    elseif D(i,2) <= loadstar_CumSum
        if D(i,4) > loadstar_PUE
            D(i,8)  = 4;
        elseif D(i,4) <= loadstar_PUE
            D(i,8)  = 3; 
        end
    end
end

save([OUTPUTfilepath,'QuadrantMapping.mat'], 'D', '-v7.3')