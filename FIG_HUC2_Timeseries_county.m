clc, clear, close all
% ------------------------------------------------------------------------
% MAKING HUC TIMESERIES FOR FIGURE 4
% ------------------------------------------------------------------------
% ########################################################################

OUTPUT_folderName = '../OUTPUTS/HUC2/';  
%  'LivestokPUE', 'CropPUE', 'FertPUE')
% HUC_PUE = readmatrix([OUTPUT_folderName, 'HUC2_TotalPUE.xlsx'],'Sheet', 'Median');
% HUC_PUE = sortrows(HUC_PUE,'descend');

MANURE_AGHA = readmatrix([OUTPUT_folderName, 'Lvsk_meanHUC2Components.txt']);
MANURE_AGHA = sortrows(MANURE_AGHA,'ascend');

FERT_AGHA = readmatrix([OUTPUT_folderName, 'HUC2_Fertilizer_AGHA.xlsx'],'Sheet', 'Median');
FERT_AGHA = sortrows(FERT_AGHA,'descend');

COMB_AGHA = readmatrix([OUTPUT_folderName, 'HUC2_Comb_AGHA.xlsx'],'Sheet', 'Median');
COMB_AGHA = sortrows(COMB_AGHA,'descend');

CROP_AGHA = readmatrix([OUTPUT_folderName, 'HUC2_Crop_AGHA.xlsx'],'Sheet', 'Median');
CROP_AGHA = sortrows(CROP_AGHA,'descend');

smoothing_int = [5 5];
for i = 1:height(HUC_PUE)

   %figure('Renderer', 'painters', 'Position', [100 100 200 150])
   figure(1) 
   subplot(4,3,i)
   
   yyaxis right % marked right but will be labeled left
   hold on
    movmeanPUE = movmean(HUC_PUE(i,2:end),smoothing_int);
    plot([1930:2017], movmeanPUE, '-k', 'LineWidth',4)
    plot([1930:2017], movmeanPUE, ':w', 'LineWidth',3)
%     ylim([0.25,1.5])
%     xlim([1930,2017])
%     xticks([1930, 1970, 2017])
%     yticks([0,0.5,1, 1.5])
    ylim([0.1,1])
    xlim([1930,2017])
    %xticks([1930, 1970, 2017])
    %yticks([0,0.5, 1])
    yticks([])
   if i <= 6
       xticks([])
   else
       xticks([1930,1970,2010])
   end


    set(gca,'FontSize',12,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
    set(gca,'XColor',[0,0,0])
    set(gca,'YColor',[0,0,0])
    set(gca,'ZColor',[0,0,0])
    
   yyaxis left
   movmeanCROPLAND = movmean(CROPLAND(i,2:end),smoothing_int);
   %movmeanPASTURE = movmean(PASTURELAND(i,2:end),smoothing_int);
   area([1930:2017]', [movmeanCROPLAND]', 'LineStyle', 'none')
   c = [119, 184, 136; 235, 220, 155]./255;
   colororder(c)
   ylim([0,0.75])
   yticks([]) 
   
   set(gca,'FontSize',9,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])    
   box on

  
    %Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/',num2str(HUC_PUE(i,1)),'.svg'];
    %print('-dsvg','-r600',[Figfolderpath])
    
    %Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/',num2str(HUC_PUE(i,1)),'.png'];
    %print('-dpng','-r600',[Figfolderpath])
    
    %close all

   %figure('Renderer', 'painters', 'Position', [100 100 200 150])
   figure(2) 
   subplot(4,3,i)
    scatter(MANURE_AGHA(i,2:end),HUC_PUE(i,2:end),36,[1930:2017],'filled', 'MarkerEdgeColor','k')
   
   set(gca,'FontSize',12,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
    box on
    
   colormap(summer)
   % Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/LV_PUE_',num2str(HUC_PUE(i,1)),'.png'];
   % print('-dpng','-r600',[Figfolderpath])

    %close all

   %figure('Renderer', 'painters', 'Position', [100 100 200 150])
   figure(3)
   subplot(4,3,i)
    scatter(FERT_AGHA(i,2:end),HUC_PUE(i,2:end),36,[1930:2017],'filled', 'MarkerEdgeColor','k')
   
   set(gca,'FontSize',12,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
    box on
    
   colormap(summer)
   % Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/FERT_PUE_',num2str(HUC_PUE(i,1)),'.png'];
   % print('-dpng','-r600',[Figfolderpath])

   figure(4) 
   subplot(4,3,i)
   
   %figure('Renderer', 'painters', 'Position', [100 100 200 150])
    scatter(CROP_AGHA(i,2:end),HUC_PUE(i,2:end),36,[1930:2017],'filled', 'MarkerEdgeColor','k')
   
   set(gca,'FontSize',12,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
    box on
    
   colormap(summer)
   % Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/CROP_PUE_',num2str(HUC_PUE(i,1)),'.png'];
   % print('-dpng','-r600',[Figfolderpath])
   %       close all

   figure(5) 
   subplot(4,3,i)

   %figure('Renderer', 'painters', 'Position', [100 100 200 150])
    scatter(COMB_AGHA(i,2:end),HUC_PUE(i,2:end),36,[1930:2017],'filled', 'MarkerEdgeColor','k')
   
   set(gca,'FontSize',12,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
    box on

   colormap(summer)
   % Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/COMB_PUE_',num2str(HUC_PUE(i,1)),'.png'];
   % print('-dpng','-r600',[Figfolderpath])
    
   
   figure(6) 
   color_pick = [153, 114, 14;
                 4, 166, 41; 
                 5, 19, 206]./255;
   subplot(4,3,i)
   movmeanMeanure = movmean(MANURE_AGHA(i,2:end),smoothing_int);
   plot([1930:2017],movmeanMeanure,'-k', 'LineWidth',2, 'Color',color_pick(1,:)) 
   hold on
   
   movmeanCrop = movmean(CROP_AGHA(i,2:end),smoothing_int);
   plot([1930:2017],movmeanCrop,'-k', 'LineWidth',2, 'Color',color_pick(2,:)) 
   
   movmeanFertilizer = movmean(FERT_AGHA(i,2:end),smoothing_int);
   plot([1930:2017],movmeanFertilizer,'-k', 'LineWidth',2,'Color',color_pick(3,:)) 
    
   set(gca,'FontSize',10,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
   set(gca,'XColor',[0,0,0])
   set(gca,'YColor',[0,0,0])
   set(gca,'ZColor',[0,0,0])
   if i <= 6
       xticks([])
   else
       xticks([1930,1970,2010])
   end
   if i == 8
     yticks([0,25,50])
   end
   
   if i == 1
     ylim([0,40])
     yticks([0,20,40])
   end
    
end

figure(1)
set(gcf, 'Position',[50,70,530,600])
Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/HUC_PUE_panel.png'];
print('-dpng','-r600',[Figfolderpath])
    
figure(2)
set(gcf, 'Position',[50,70,500,600])
Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/LV_PUE_panel.png'];
print('-dpng','-r600',[Figfolderpath])

figure(3)
set(gcf, 'Position',[50,70,500,600])
Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/FERT_PUE_panel.png'];
print('-dpng','-r600',[Figfolderpath])

figure(4)
set(gcf, 'Position',[50,70,450,600])
Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/CROP_PUE_panel.png'];
print('-dpng','-r600',[Figfolderpath])

figure(5)
set(gcf, 'Position',[50,70,500,600])
Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/COMB_PUE_panel.png'];
print('-dpng','-r600',[Figfolderpath])

figure(6)
set(gcf, 'Position',[50,70,530,630])
Figfolderpath = [OUTPUT_folderName,'PUE_HUC_timeseries/Component_timeseries.png'];
print('-dpng','-r600',[Figfolderpath])