clc, clear

%% Aesthetic 
fontSize_p = 10;
plot_dim_1 = [400,400,375,300];
plot_dim_3 = [200,200,275,200];
mSize = 10; 

colourPalette = [1,102,94;
                216,179,101; 
                 90,180,172;
                 140,81,10]./255;
%% Read in gif files
PUEfilepath = '..\OUTPUTS\PUE\PUE_2017.tif';
CUMSUMfilepath = '..\OUTPUTS\Cumulative Phosphorus\CumSum_2017.tif';
OUTPUTfilepath = '..\OUTPUTS\Figures\PUE_2017.tif';

% binscatter(x,y)
[PUE2017,~] = readgeoraster(PUEfilepath);
[CS2017,~] = readgeoraster(CUMSUMfilepath);
PUE2017 = single(PUE2017)./1000;
PUE2017(find(PUE2017 > 2^20)) = 0; 
CS2017(find(CS2017 > 2^20)) = 0; 


CUMSUMfilepath = '..\OUTPUTS\Cumulative Phosphorus\CumSum_1980.tif';
OUTPUTfilepath = '..\OUTPUTS\Figures\PUE_1980.tif';

% binscatter(x,y)
[PUE1980,~] = readgeoraster(PUEfilepath);
[CS1980,~] = readgeoraster(CUMSUMfilepath);
PUE1980 = single(PUE1980)./1000;
PUE1980(find(PUE1980 > 2^20)) = 0; 
CS1980(find(CS1980 > 2^20)) = 0; 

% Vectorizin the data
PUE2017_v = PUE2017(:);
CS2017_v = CS2017(:);

PUE1980_v = PUE1980(:);
CS1980_v = CS1980(:);
% %% Figure
% close all
% h = binscatter(CS2017_v,PUE2017_v,  'YLimits',[0,3], 'XLimits', [-500, 4000]);
% caxis([1 3000]);
% hold on
% plot([0,0],[0,20],'--k','LineWidth',1)
% plot([-2000,2000],[1,1],'--k','LineWidth',1)
% 
% ylim([0,3])
% xlim([-500, 4000])
% 
% set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
% set(gcf,'position',plot_dim_1)
% 
% set(gca,'XColor',[0,0,0])
% set(gca,'YColor',[0,0,0])
% set(gca,'ZColor',[0,0,0])
% 
% xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
% ylabel('Phosphorus Use Efficiency')

%% Scatter 
D = [CS1980_v, CS2017_v,PUE1980_v, PUE2017_v]; 

loadstar_CumSum = 0; %median(D(:,1),'omitnan');
loadstar_PUE = 1;% median(D(:,3),'omitnan');


% 1980

for i = 1:length(D)
   
    if D(i,1) > loadstar_CumSum
        if D(i,3) > loadstar_PUE
            D(i,5)  = 1; 
        elseif D(i,3) <= loadstar_PUE
            D(i,5)  = 4; 
        end
    elseif D(i,1) <= loadstar_CumSum
        if D(i,3) > loadstar_PUE
            D(i,5)  = 2;
        elseif D(i,3) <= loadstar_PUE
            D(i,5)  = 3; 
        end
    end
end

% 2017
for i = 1:length(D)
   
    if D(i,2) > loadstar_CumSum
        if D(i,4) > loadstar_PUE
            D(i,6)  = 1; 
        elseif D(i,4) <= loadstar_PUE
            D(i,6)  = 4; 
        end
    elseif D(i,2) <= loadstar_CumSum
        if D(i,4) > loadstar_PUE
            D(i,6)  = 2;
        elseif D(i,4) <= loadstar_PUE
            D(i,6)  = 3; 
        end
    end
end

% 2017
figure(2)
unQ = unique(D(:,6));

for i = 2:length(unQ)
    temp_D = D(find(D(:,6) == unQ(i)),:); 
    scatter(temp_D(:,2),temp_D(:,4), mSize, 'filled',...
              'MarkerFaceColor',colourPalette(i-1,:),...
              'MarkerFaceAlpha',0.001)
%             'MarkerEdgeColor',none[0 0 0],...
%              'LineWidth',0.5
    hold on
end
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,2000],[1,1],'--k','LineWidth',1)

ylim([0,3])
xlim([-200, 2000])
%%
figure(2)
hold on
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,2000],[1,1],'--k','LineWidth',1)

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
ylabel('Phosphorus Use Efficiency')


% 1980 data -- D[1,3,5]
figure(3)
unQ = unique(D(:,5));

for i = 2:length(unQ)
    temp_D = D(find(D(:,5) == unQ(i)),:); 
    scatter(temp_D(:,1),temp_D(:,3), mSize, 'filled',...
              'MarkerFaceColor',colourPalette(i-1,:),...
              'MarkerFaceAlpha',0.05)
%             'MarkerEdgeColor',none[0 0 0],...
%              'LineWidth',0.5
    hold on
end
ylim([0,3])
xlim([-200, 2000])

hold on
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,2000],[1,1],'--k','LineWidth',1)

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
ylabel('Phosphorus Use Efficiency')


%Figfolderpath = [OUTPUT_folderName,'Sustainability/CSum_PUE_Quadrant_1980.png'];
%print('-dpng','-r600',[Figfolderpath])

%% Creating

%%
% figure(2)
% % 2017
% h = scatter(D(:,1),D(:,3), 'filled');
% %caxis([ 3000]);
% hold on
% plot([0,0],[0,20],'--k','LineWidth',1)
% plot([-2000,2000],[1,1],'--k','LineWidth',1)
% 
% ylim([0,3])
% xlim([-500, 4000])
% 
% set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
% set(gcf,'position',plot_dim_1)
% 
% set(gca,'XColor',[0,0,0])
% set(gca,'YColor',[0,0,0])
% set(gca,'ZColor',[0,0,0])
% 
% xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
% ylabel('Phosphorus Use Efficiency')