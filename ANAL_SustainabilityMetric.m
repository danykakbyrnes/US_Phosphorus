clc, clear, close all

[SUST,~] = readgeoraster('D:\Danyka\9 Phopshorus Use Efficiency\OUTPUTS\SUST\SUST_2017.tif');
[SURP_cum,~] = readgeoraster('D:\Danyka\9 Phopshorus Use Efficiency\OUTPUTS\Cumulative Phosphorus\CumSum_2017.tif');
[PUE,~] = readgeoraster('D:\Danyka\9 Phopshorus Use Efficiency\OUTPUTS\PUE\PUE_2017.tif');
SURP_cum = double(SURP_cum);

SUST_v = SUST(:);
SURP_v = SURP_cum(:);
PUE_v = PUE(:);

int = randi(length(PUE_v), 10000, 1);

SUST_v = SUST_v(int);
SURP_v = SURP_v(int);
PUE_v = PUE_v(int);

cSURP_v = SURP_v;
cSURP_v(SURP_v < -200) = -200;
cSURP_v(SURP_v > 200) = 200;

scatter(SUST_v, PUE_v, 150, cSURP_v, 'filled')

xlim([-20,20])
ylim([0, 2])
colorbar

figure(2)

idxab0 = find(cSURP_v >= 0);
idxbl0 = find(cSURP_v < 0);

scatter(SUST_v(idxab0), PUE_v(idxab0), 150,  'filled','r')
hold on
scatter(SUST_v(idxbl0), PUE_v(idxbl0), 150, 'filled','b')

xlim([-20,20])
ylim([0, 2])


figure(3)
subplot(1,2,1)
scatter(SUST_v(idxab0), PUE_v(idxab0), 150,  'filled','r')

xlim([-20,20])
ylim([0, 2])

subplot(1,2,2)
scatter(SUST_v(idxbl0), PUE_v(idxbl0), 150,  'filled','b')

xlim([-20,20])
ylim([0, 2])

figure(4)
scatter(1-SUST_v, SURP_v, 150, PUE_v, 'filled')
