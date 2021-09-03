clear
close all

% load csv
CS = readmatrix('4-Hf.csv','FileType','text');

energy = CS(end-100+1:end,1);
intensity = CS(end-100+1:end,2);

% baseline
sample = find(energy==5|energy==10.8|energy==11.6|energy==21.6);
energy_sample = energy(sample);
intensity_sample = intensity(sample);

fo = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[-inf,-inf,-inf],...
    'Upper',[ inf, inf, inf],...
    'StartPoint',[1000, 0, 1000]);
ft = fittype('a*(x-b)^2+c','options',fo);
[curve,~] = fit(energy_sample,intensity_sample,ft);
cf_base = coeffvalues(curve);
curve_base = cf_base(1)*(energy-cf_base(2)).^2+cf_base(3);

% plot(energy,intensity)
% plot(energy,curve_base)

intensity_nobase = intensity-curve_base;

ignore_left = 1;
if ignore_left == 1
    intensity_nobase(energy>21.6|energy<10)=0;
end

% %% fit_gaussian
% fo = fitoptions('Method','NonlinearLeastSquares',...
%     'Lower',[-inf, 15,-inf,-inf, 16.5, 0],...
%     'Upper',[ inf, 16, inf, inf, 17.5, 2],...
%     'StartPoint',[4000, 15.5, 3, 4000, 17.2, 1]);
% ft = fittype('a*exp(-(x-b)^2/c^2) + d*exp(-(x-e)^2/f^2)','options',fo);
% [curve,~] = fit(energy,intensity_nobase,ft);
% cf_fit = coeffvalues(curve);
% curve_fit1 = cf_fit(1)*exp(-(energy-cf_fit(2)).^2/cf_fit(3)^2);
% curve_fit2 = cf_fit(4)*exp(-(energy-cf_fit(5)).^2/cf_fit(6)^2);
% curve_fit = curve_fit1+curve_fit2;

% %% fit_lorentz
% fo = fitoptions('Method','NonlinearLeastSquares',...
%     'Lower',[1000, 15, 0,1000, 16.5, 0],...
%     'Upper',[ inf, 16, 5, inf, 17.5, 5],...
%     'StartPoint',[4000, 15.5, 3, 4000, 17.2, 3]);
% ft = fittype('(a/c)/((1+((x-b)/c)^2)) + (d/f)/((1+((x-e)/f)^2))','options',fo);
% [curve,~] = fit(energy,intensity_nobase,ft);
% cf_fit = coeffvalues(curve);
% curve_fit1 = (cf_fit(1)/cf_fit(3))./((1+((energy-cf_fit(2))/cf_fit(3)).^2));
% curve_fit2 = (cf_fit(4)/cf_fit(6))./((1+((energy-cf_fit(5))/cf_fit(6)).^2));
% curve_fit = curve_fit1+curve_fit2;

%% fit_studentT
fo = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[1000, 15, 0,1000, 16.5, 0, 1],...
    'Upper',[ inf, 16, 5, inf, 17.5, 5, inf],...
    'StartPoint',[4000, 15.5, 3, 6000, 17.2, 2, 1.5]);
ft = fittype('a*((1+((x-b)/c)^2/g)^(-(1+g/2))) + d*((1+((x-e)/f)^2/g)^(-(1+g/2)))','options',fo);
[curve,~] = fit(energy,intensity_nobase,ft);
cf_fit = coeffvalues(curve);
curve_fit1 = cf_fit(1)*((1+((energy-cf_fit(2))/cf_fit(3)).^2/cf_fit(7)).^(-(1+cf_fit(7)/2)));
curve_fit2 = cf_fit(4)*((1+((energy-cf_fit(5))/cf_fit(6)).^2/cf_fit(7)).^(-(1+cf_fit(7)/2)));
curve_fit = curve_fit1+curve_fit2;

%%
Area1 = trapz(energy,curve_fit1);
Area2 = trapz(energy,curve_fit2);

Area2/Area1

figure;
hold on
% plot(energy,intensity_nobase)
plot(energy,intensity,'o')

plot(energy,curve_fit1+curve_base)
plot(energy,curve_fit2+curve_base)

plot(energy,curve_fit+curve_base)

%% figure settings
% daspect([1 1 1])
box on
% xlim([0.005 .4])
% ylim([2e-4 10])
% zlim([-5 5])
% caxis([0 1])
% load tw_flag.mat
% colormap(mymap);
% xticks(0:1:ED_ub)
% yticks(-1:0.2:1)
% zticks(-5:5:5)
% xticklabels({'',''})
% yticklabels({'',''})
% set(gca,'Yscale','log')
% set(gca,'Xscale','log')
xlabel('Energy','FontSize',24)
ylabel('Intensity','FontSize',24)
% shading flat
% set(gca,'Position', get(gca, 'OuterPosition') - ...
% get(gca,'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
set(gcf,'Position',[200,100,800,600])
set(gca,'FontSize',28,'FontName','Times New Roman')
% legend('boxoff')
legend('Intensity','Peak 1','Peak 2','Fit','Location','northwest')
set(gca,'LineWidth',2)
% set(gca,'Position',[0.1552    0.1491    0.7498    0.7759])