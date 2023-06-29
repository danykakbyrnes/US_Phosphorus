clc, clear, close all

% Read in gif files
INPUTfilepath = ['B:/LabFiles/users/DanykaByrnes/9 Phosphorus Use Efficiency/OUTPUTS/CropFertRatio/'];
YEARS = 1930:2017;
countyShp = shaperead([INPUTfilepath,'CFR_counties.shp']);
stateShp = shaperead([INPUTfilepath,'CFR_state.shp']);

StateID_Northeast = [9,23,25,33,34,36, 42,44,50]; 
StateID_Midwest = [17,18,19,20,26,27,29,31,38,39,46,55]; 
StateID_Midwest = [17,18,19]; 
StateID_GLR = [];
StateID_South = [1,5,10,11,12,13,21,22,24,28,37,40,45,47,48,51,54]; 
StateID_West = [4,6,8,16,30,32,35,41,49,53,56];

%% Starting with plotting the midwestern States
C_stateShp = struct2cell(stateShp);
C_stateIDs = str2num(cell2mat(C_stateShp(8,:)'));
figure(1)
for i = 1:length(StateID_Midwest)
    idx = find(C_stateIDs == StateID_Midwest(i));
    timeseriesCFR = cell2mat(C_stateShp(14:end, idx));

    plot(YEARS, timeseriesCFR,'o-')
    hold on 
end

ylim([0,5])
legend('IL','IN','IA')

%% Now for County
for i = 1:length(countyShp)
    
    countyID = countyShp(i).GEOID;
    CountyStateID(i) = str2num(countyID(1:2));

end  

C_countyShp = struct2cell(countyShp);

for i = 1:length(StateID_Midwest)
   
    idx = find(CountyStateID == StateID_Midwest(i));
    timeseriesCFR = cell2mat(C_countyShp(15:end, idx));
    median_timeseriesCFR = median(timeseriesCFR, 2);
    figure(2)
    plot(YEARS, median_timeseriesCFR,'o-')
    hold on 
    
    figure(3)
    subplot(1,3,i)
    plot(timeseriesCFR')
    ylim([0,100])
end
legend('IL','IN','IA')

idx = find(CountyStateID == StateID_Midwest(1));
IL_TS = cell2mat(C_countyShp(15:end, idx));
idx = find(CountyStateID == StateID_Midwest(2));
IN_TS = cell2mat(C_countyShp(15:end, idx));
idx = find(CountyStateID == StateID_Midwest(3));
IA_TS = cell2mat(C_countyShp(15:end, idx));

subplot(2,3,1)
histogram(IL_TS(41,:),'BinWidth',0.1, 'Normalization','probability')
xlim([0,3])
legend('IL')

subplot(2,3,2)
histogram(IN_TS(41,:),'BinWidth',0.1, 'Normalization','probability')
xlim([0,3])
legend('IN')

subplot(2,3,3)
histogram(IA_TS(41,:),'BinWidth',0.1, 'Normalization','probability')
xlim([0,3])
legend('IA')

subplot(2,3,4)
histogram(IL_TS(88,:),'BinWidth',0.1, 'Normalization','probability')
xlim([0,3])

hold on
subplot(2,3,5)
histogram(IN_TS(88,:),'BinWidth',0.1, 'Normalization','probability')
xlim([0,3])

subplot(2,3,6)
histogram(IA_TS(88,:),'BinWidth',0.1, 'Normalization','probability')
xlim([0,3])