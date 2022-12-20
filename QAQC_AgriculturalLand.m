clc, clear, close all

OUTPUT_folderName = '../OUTPUTS/HUC2/';  
load([OUTPUT_folderName, 'HUC2_AgLandUse.mat']  )
meanHarvCropland = readmatrix([OUTPUT_folderName,'HUC2_Cropland.xlsx'],'Sheet', 'mean');
medianHarvCropland = readmatrix([OUTPUT_folderName,'HUC2_Cropland.xlsx'],'Sheet', 'median');

for i = 1:9
   figure(1)
    subplot(3,3,i)
    scatter(meanHarvCropland(i,2:end), HUCLU(i,2:end),'o','filled'),
    hold on
    plot([0,max(HUCLU(i,2:end))], [0,max(HUCLU(i,2:end))])
    if i == 2
        title('Mean Hav. Area vs. DS LU')
    elseif i == 4
        ylabel('Downscaled LU')
    elseif i == 8
        xlabel('Mean Harvested Cropland')
    end
    
    figure(2)
    subplot(3,3,i)
    scatter(medianHarvCropland(i,2:end), HUCLU(i,2:end),'o','filled'),
    hold on
    plot([0,max(HUCLU(i,2:end))], [0,max(HUCLU(i,2:end))])
    if i == 2
        title('Median Hav. Area vs. DS LU')
    elseif i == 4
        ylabel('Downscaled LU')
    elseif i == 8
        xlabel('Median Harvested Cropland ')
    end
    
end
figure(1)
legend('Year', '1:1', 'Location', 'eastoutside')
figure(2)
legend('Year', '1:1', 'Location', 'eastoutside')