close all
clear

% load
filename = './data/0810A_2th_all.uxd';
data = readmatrix(filename,'FileType','text','NumHeaderLines',65);

figure(1)
X = data(:,1);
Y = data(:,2);
plot(X,Y)
set(gca, 'YScale', 'log')
xlabel('2\theta')
ylabel('Intensity')

% Extract peak
Xb = [117,122]; % X range
index_peak = find(X>Xb(1)&X<Xb(2));
X_peak = X(index_peak);
Y_peak = Y(index_peak);

hold on
plot(X_peak,Y_peak)

figure(2)
hold on
plot(X_peak,Y_peak)
set(gca, 'YScale', 'log')
xlabel('2\theta')
ylabel('Intensity')



% Fit
fo = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',     [1e4, 116, 0.0, 0.0],...
    'Upper',     [1e6, 122, 0.1, 100],...
    'StartPoint',[1e5,  119, 0.08, 10.0]);
ft = fittype('a*(c^2/((x-b)^2+c^2))+d','options',fo);
[curve,gof] = fit(X_peak,Y_peak,ft);
Cf = coeffvalues(curve);

X_fitted = Xb(1):0.05:Xb(2);
Y_fitted = Cf(1)*(Cf(3)^2./((X_fitted-Cf(2)).^2+Cf(3)^2))+Cf(4);

plot(X_fitted,Y_fitted)

disp(['Peak position (2\theta) = ', num2str(Cf(2))])
disp(['FWHM (2\theta) = ', num2str(Cf(3)*2)])
disp(['Peak value (arb. unit) = ', num2str(Cf(1))])
disp(['Background (arb. unit) = ', num2str(Cf(4))])