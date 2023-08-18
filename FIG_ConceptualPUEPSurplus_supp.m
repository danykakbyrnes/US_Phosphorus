clc, clear all, close all

% plot y = b*(1-x) where b = 10, 100

b = [2,10,50,100];

fp = fplot(@(x) b.*(1-x),'LineWidth',2);
xlim([0,1])
ylim([0,100])]

legend({'input (kg-P/ha) = 2', 'input (kg-P/ha) = 10', 'input (kg-P/ha) = 50', 'input (kg-P/ha) = 100'})

xlabel('Phosphorus Use Efficiency')
ylabel('P Surplus (kg-P ha^-^1)')

set(gca,'FontSize',14)


figure(2)

b = [2,10,50,100];

fp = fplot(@(x) (1-x./b),'LineWidth',2);

legend({'input (kg-P/ha) = 2', 'input (kg-P/ha) = 10', 'input (kg-P/ha) = 50', 'input (kg-P/ha) = 100'})

ylabel('Phosphorus Use Efficiency')
xlabel('P Surplus (kg-P ha^-^1)')

set(gca,'FontSize',14)