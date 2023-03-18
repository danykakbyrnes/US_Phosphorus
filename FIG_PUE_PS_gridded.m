clc, clear, close all
%% Aesthetic 
fontSize_p = 10;
fontSize_p2 = 12; 
plot_dim_1 = [400,400,375,280];
plot_dim_2 = [200,200,170,125];
plot_dim_3 = [200,200,200,150];
mSize = 10; 
lineColour = '#70AD47';

%% Figure to explore the failures of PUE as a metric
[SURP_cum,~] = readgeoraster('D:\Danyka\9 Phopshorus Use Efficiency\OUTPUTS\Cumulative Phosphorus\CumSum_2017.tif');
[SURP,~] = readgeoraster('D:\Danyka\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\Grid_TREND_P_Version_1\TREND-P Agriculture Surplus\AgSurplus_2017.tif');
[PUE,~] = readgeoraster('D:\Danyka\9 Phopshorus Use Efficiency\OUTPUTS\PUE\PUE_2017.tif');
[CROP,~] = readgeoraster('D:\Danyka\3 TREND_Nutrients\TREND_Nutrients\OUTPUTS\Grid_TREND_P_Version_1\TREND-P Postpocessed Gridded\CropUptake_Agriculture_Agriculture_LU\CropUptake_Ag_2017.tif');    
CROP = single(CROP)/1000;
CROP(CROP == 0) = NaN; 

SURP = SURP(:);
PUE = PUE(:);
SURP_cum = SURP_cum(:);
CROP = CROP(:);

I = sort(randperm(length(SURP),ceil(length(SURP)/100))'); 
SURP = SURP(I,:);
PUE = PUE(I,:);
SURP_cum = SURP_cum(I,:);
CROP = CROP(I,:);

SURP_cum(SURP_cum > 2500) = 5000; 
SURP_cum(SURP_cum < -2500) = -5000; 

PUE_sub1_idx = find(PUE < 1);
PUE_sub1 = PUE(PUE_sub1_idx);
SURP_pos = SURP(PUE_sub1_idx);

lm = fitlm(PUE_sub1, SURP_pos);
m = lm.Coefficients.Estimate(2);
b = lm.Coefficients.Estimate(1);

figure(1)
%scatter(PUE, SURP,[],SURP_cum, 'filled','MarkerFaceAlpha', 0.8)%,'MarkerFaceColor',[0,0,0])
scatter(PUE, SURP, mSize,'filled','MarkerFaceAlpha', 0.5,'MarkerFaceColor',[0,0,0])

n_xlim = [0,1];
xlim(n_xlim)
ylim([0,100]) % [0.999,0.001]

hold on
y_vec = m*n_xlim + b;

plot(xlim,y_vec, 'LineWidth',2, 'Color', lineColour)


yticks([0, 50, 100])    
set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

box on
set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])



% figure(2)
% scatter(PUE, CROP, mSize,'filled','MarkerFaceAlpha', 0.5,'MarkerFaceColor',[0,0,0])
% xlim([0,3])
% ylim([0,100]) % [0.999,0.001]
% 
% yticks([0, 50, 100])    
% set(gca,'FontSize',fontSize_p2,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
% set(gcf,'position',plot_dim_1)
% 
% box on
% set(gca,'XColor',[0,0,0])
% set(gca,'YColor',[0,0,0])
% set(gca,'ZColor',[0,0,0])
close all
scatter(PUE, SURP, mSize,'filled','MarkerFaceAlpha', 0.5,'MarkerFaceColor',[0,0,0])

n_xlim = [0,1];
xlim(n_xlim)
ylim([0,100]) % [0.999,0.001]

hold on

% Modelled data. 
IN = 100;
    INv = [0:20:200];
    CROP = [0:1:100];
    for i = 1:length(INv)
        
        IN = INv(i);
        PUE = CROP./IN; 
        PS = IN-CROP;
        plot(PUE,PS)
        hold on
    end
    ylim([0,100])
    xlim([0,1])
    legend('Raw Data','Inputs = 0', 'In = 20', 'In = 40', 'In = 60', 'In = 80', 'In = 100', 'In = 120','In = 140', 'In = 160', 'In = 180', 'In = 200')