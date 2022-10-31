clc, clear all, close all

INPUT_folderName = '../INPUTS_061322/'; 
OUTPUT_folderName = '../OUTPUTS/TREND_P_Version_1.2/';

% Loading Files
load([OUTPUT_folderName,'Ag_CumSum_kgha.mat'])
load([OUTPUT_folderName, 'Fertilizer_ag_kgha.mat']);
load([OUTPUT_folderName, 'Livestock_kgha.mat'])
load([OUTPUT_folderName,'PUE/PUE_all.mat'])

%% Aesthetics
fontSize_p = 12;
colourPalette = [190,186,218;
                251,128,114; 
                128,177,211;
                253,180,98]./255;
mSize = 30; 
plot_dim_1 = [400,400,375,300];
plot_dim_3 = [200,200,275,200];

%%            
PUE_County_num = County_num; 
County_num = []; 
% Ordering CumSum the same way as PUE
% Removing the CountyID x. 
for i = 1:length(County1)
    temp = County1{i};
    County_num(i) = str2num(temp(2:end)); 
end

% Sorting the matrices so they all have the same order of counties. 
[County_num, idx] = sort(County_num);
CumSum_PSurplus_kgha = CumSum_PSurplus_kgha(:,idx);


% D = [CumSum_PSurplus_kgha(50,:)./median(CumSum_PSurplus_kgha(50,:),'omitnan'); CumSum_PSurplus_kgha(end,:)./median(CumSum_PSurplus_kgha(end,:),'omitnan');...
%     PUE_fert(50,:); PUE_fert(end,:)]';
% 1980 cum sum, 2017 cum sum, 1980 pue, 2017 pue
D = [CumSum_PSurplus_kgha(51,:); 
    CumSum_PSurplus_kgha(end,:);...
    PUE_fert(51,:); 
    PUE_fert(end,:)]';

%figure(1)
%scatter(CumSum_2017,PUE_2017)
%ylim([0,5])
%xlim([-500, 2000])

% Inputs = Livestock_export + Fertilizer_export; 
% Inputs_2017 = Inputs(end,:);

figure(2)
% CumSum_1980 = CumSum_PSurplus_kgha(50,:); 
% PUE_1980 = PUE_fert(50,:);
%scatter(CumSum_1980,PUE_1980)
%ylim([0,5])
%xlim([-500, 2000])

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
County_num_rem = County_num; 
County_num_rem(find(D(:,5) == 0)) = [];
D(find(D(:,5) == 0),:) = [];
County_num_rem(find(D(:,6) == 0)) = [];
D(find(D(:,6) == 0),:) = [];


%% 2017 data -- D[2,4,6]
unQ = unique(D(:,6));
figure(1)
for i = 1:length(unQ)
    temp_D = D(find(D(:,6) == unQ(i)),:); 
    scatter(temp_D(:,2),temp_D(:,4), mSize, 'filled',...
             'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',colourPalette(i,:),...
              'LineWidth',0.5)
    hold on
end
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,2000],[1,1],'--k','LineWidth',1)

ylim([0,3])
xlim([-200, 2000])

figure(1)
hold on
plot([0,0],[0,20],'--k','LineWidth',1)
plot([-2000,2000],[1,1],'--k','LineWidth',1)

set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_1)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Cumulative Ag P (kg-P ha-ag^-^1 yr^-^1)')
ylabel('PUE')

Figfolderpath = [OUTPUT_folderName,'Sustainability/CSum_PUE_Quadrant_2017.png'];
print('-dpng','-r600',[Figfolderpath])

%% 1980 data -- D[1,3,5]
figure(2)
unQ = unique(D(:,5));

for i = 1:length(unQ)
    temp_D = D(find(D(:,5) == unQ(i)),:); 
    scatter(temp_D(:,1),temp_D(:,3), mSize, 'filled',...
             'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',colourPalette(i,:),...
              'LineWidth',0.5)
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

xlabel('Cumulative Ag P (kg-P ha-ag^-^1 yr^-^1)')
ylabel('PUE')


Figfolderpath = [OUTPUT_folderName,'Sustainability/CSum_PUE_Quadrant_1980.png'];
print('-dpng','-r600',[Figfolderpath])

%% Distance metric

for i = 1:length(D)
   X = [0,1;
       D(i,2)./max(D(:,2)), D(i,4)];
   dist_2017(i,1) = pdist(X,'euclidean');
   x_s = sign(X(2,1) - X(1,1));
   y_s = sign(X(2,2) - X(1,2)); 
   dist_2017(i,2) = x_s*y_s; 

   X = [0,1;
       D(i,1)./max(D(:,1)), D(i,3)];
   dist_1980(i,1) = pdist(X,'euclidean');
   x_s = sign(X(2,1) - X(1,1));
   y_s = sign(X(2,2) - X(1,2)); 
   dist_1980(i,2) = x_s*y_s; 
end


figure(3)
histogram(dist_1980(:,1).*dist_1980(:,2), 'BinWidth', 0.1, 'FaceColor', '#b0b0b0', 'EdgeColor','#b0b0b0','FaceAlpha',0.5)
hold on
histogram(dist_2017(:,1).*dist_2017(:,2),'BinWidth', 0.1, 'FaceColor', '#4a4a4a ', 'EdgeColor','#4a4a4a','FaceAlpha',0.5)
xlim([-1.5,1.5])

hold on
plot([0,0],[0,600],'--k','LineWidth',1)
legend('1980','2017','')
set(gca,'FontSize',fontSize_p,'LineStyleOrderIndex',3,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'});
set(gcf,'position',plot_dim_3)

set(gca,'XColor',[0,0,0])
set(gca,'YColor',[0,0,0])
set(gca,'ZColor',[0,0,0])

xlabel('Sustainability Index')
ylabel('No. Counties')

Figfolderpath = [OUTPUT_folderName,'Sustainability/Distance_Histogram.png'];
print('-dpng','-r600',[Figfolderpath])

%% Creating a shapefile

County_SP = shaperead([INPUT_folderName,'0 General Data/CountyShapefiles/County_TotalArea_5070_20220902.shp']);
County_SP = rmfield(County_SP,{'ALAND','AWATER'});
    storeCunt = [];

for j = 1:4
    Q_SP = County_SP; 
    County_num_rem_j = County_num_rem(find(D(:,6) == j));
    D_j = D(find(D(:,6) == j),:);
    %dist_1980_j = dist_1980(find(D(:,6) == j),:);
    dist_2017_j = dist_2017(find(D(:,6) == j),:);

        for i = 1:length(Q_SP)
        CountyNum_shp = str2num(Q_SP(i).GEOID);
        idx = find(County_num_rem_j == CountyNum_shp);
        if isempty(idx)
            %Q_SP(i).dist_1980 = NaN; 
            Q_SP(i).dist_2017 = NaN; 
            %Q_SP(i).Q_1980 = 0; 
            Q_SP(i).Q_2017 = NaN; 
        else
            %Q_SP(i).dist_1980 = dist_1980_j(idx,1).*dist_1980_j(idx,2); 
            Q_SP(i).dist_2017 = dist_2017_j(idx,1).*dist_2017_j(idx,2);
           %Q_SP(i).Q_1980 = D_j(idx,5);
            Q_SP(i).Q_2017 = D_j(idx,6);
            storeCunt = [storeCunt; County_num_rem_j(idx)];

        end

end

'Saving shapefiles'
shapewrite(Q_SP,  [OUTPUT_folderName, 'Sustainability/Q',num2str(j),'_D_Map.shp'])
end