clc, clear

%% Aesthetic 
fontSize_p = 10;
plot_dim_1 = [400,400,375,280];
plot_dim_3 = [200,200,200,150];
mSize = 10; 

colourPalette = [1,102,94;
                216,179,101; 
                 90,180,172;
                 140,81,10]./255;
%% Read in gif files
INPUTfilepath = '..\INPUTS_103122\';
PUEfilepath = '..\OUTPUTS\PUE\PUE_2017.tif';
CUMSUMfilepath = '..\OUTPUTS\Cumulative Phosphorus\CumSum_2017.tif';
OUTPUTfilepath = '..\OUTPUTS\Figures\PUE_2017.tif';

% binscatter(x,y)
[PUE2017,~] = readgeoraster(PUEfilepath); % single
[CS2017,~] = readgeoraster(CUMSUMfilepath); % single

PUE2017(find(PUE2017 > 2^20)) = 0; 
CS2017(find(CS2017 > 2^20)) = 0; 

PUEfilepath = '..\OUTPUTS\PUE\PUE_1980.tif';
CUMSUMfilepath = '..\OUTPUTS\Cumulative Phosphorus\CumSum_1980.tif';

% binscatter(x,y)
[PUE1980,~] = readgeoraster(PUEfilepath); % single
[CS1980,~] = readgeoraster(CUMSUMfilepath); % single

PUE1980(find(PUE1980 > 2^20)) = 0; 
CS1980(find(CS1980 > 2^20)) = 0; 

% Vectorizin the data
PUE2017_v = PUE2017(:);
CS2017_v = CS2017(:);
PUE2017 = []; 
CS2017 = []; 

PUE1980_v = PUE1980(:);
CS1980_v = CS1980(:);
PUE1980 = []; 
CS1980 = []; 

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
D_copy = D; 
%% Removing NaNs
D = D_copy;
close all
% Stats for each quadrant
% 1980
Q_1980 = [length(find(D(:,5) == 1)); 
          length(find(D(:,5) == 2)); 
          length(find(D(:,5) == 3)); 
          length(find(D(:,5) == 4))]./size(D,1); 

Q_2017 = [length(find(D(:,6) == 1)); 
          length(find(D(:,6) == 2)); 
          length(find(D(:,6) == 3)); 
  length(find(D(:,6) == 4))]./size(D,1); 

figure(1)
b = bar([Q_1980,Q_2017]','stacked');
b(1).FaceColor = colourPalette(1,:);
b(2).FaceColor = colourPalette(2,:);
b(3).FaceColor = colourPalette(3,:);
b(4).FaceColor = colourPalette(4,:);

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,...
    {'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},...
    {'k','k','k'});
set(gcf,'position',plot_dim_3)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

ylim([0,0.2])

set(gca,'xticklabel',{'1980', '2017'})


%% Subsampling the data
D = D_copy;
D = D(~isnan(D(:,1)),:);
I = sort(randperm(length(D),ceil(length(D)/100))'); 

D = D(I,:);
% 2017
unQ = unique(D(:,6));
unQ = unQ(find(unQ ~= 0));

%% Figure
close all

figure(1)
% 2017
h = binscatter(D(:,2),D(:,4),  'YLimits',[0,3], 'XLimits', [-500, 4000]);
h.NumBins = [100 100];
caxis([1 2000]);
hold on
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,4000],[1,1],'--k','LineWidth',1)

ylim([0,3])
xlim([-500, 4000])

load([INPUTfilepath, 'orangeColormap.mat'])
colormap(orangeColormap)

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
ylabel('Phosphorus Use Efficiency')

figure(2)
% 1980
h = binscatter(D(:,1),D(:,3),  'YLimits',[0,3], 'XLimits', [-500, 4000]);
h.NumBins = [100 100];
caxis([1 2000]);
hold on
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,4000],[1,1],'--k','LineWidth',1)

ylim([0,3])
xlim([-500, 4000])

load([INPUTfilepath, 'orangeColormap.mat'])
colormap(orangeColormap)

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
ylabel('Phosphorus Use Efficiency')

%% Scatter 
close all

%2017
figure(1)
for i = 1:length(unQ)
    temp_D = D(find(D(:,6) == unQ(i)),:); 
    scatter(temp_D(:,2),temp_D(:,4), mSize, 'filled',...
              'MarkerFaceColor',colourPalette(i,:),...
              'MarkerFaceAlpha',0.05)
%             'MarkerEdgeColor',none[0 0 0],...
%              'LineWidth',0.5
    hold on
end
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,4000],[1,1],'--k','LineWidth',1)

ylim([0,3])
xlim([-300, 4000])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
ylabel('Phosphorus Use Efficiency')

% 1980
figure(2)
for i = 1:length(unQ)
    temp_D = D(find(D(:,5) == unQ(i)),:); 
    scatter(temp_D(:,1),temp_D(:,3), mSize, 'filled',...
              'MarkerFaceColor',colourPalette(i,:),...
              'MarkerFaceAlpha',0.05)
%             'MarkerEdgeColor',none[0 0 0],...
%              'LineWidth',0.5
    hold on
end
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,4000],[1,1],'--k','LineWidth',1)

ylim([0,3])
xlim([-300, 4000])

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Cumulative Phosphorus Surplus (kg-P ha-ag^-^1)')
ylabel('Phosphorus Use Efficiency')


