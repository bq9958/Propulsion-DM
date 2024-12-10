%% fitting allure Consomation - puissance en annexe2
clc;
clear;

[fileName, filePath] = uigetfile('GO-conso.csv', 'choose a csv file');
if isequal(fileName, 0)
    disp('Abord');
    return;
end

data = readmatrix(fullfile(filePath, fileName));

x = data(:, 1);
y = data(:, 2);

degree = input('degree of polynome: ');

p = polyfit(x, y, degree);

xFit = linspace(min(x), max(x), 500);
yFit = polyval(p, xFit);

figure;
plot(x, y, 'ro', 'DisplayName', 'Ori data '); 
hold on;
plot(xFit, yFit, 'b-', 'LineWidth', 1.5, 'DisplayName', 'fitted curve'); % 拟合曲线
title('Fitting polynome');
xlabel('x');
ylabel('y');
legend('show');
grid on;

disp('polynome coeff(from high order to low order):');
disp(p);

%% Tracer Emission- Contrainte
clc;
clear;

gazoletoNOx = 0.027;   % 1g gazole emet 0.07g NOx
Redu_emission = 0.60;  % pourcentage de reduction
n = 100:10:1200;    % vitesse de rotation en RPM
contraint = zeros(length(n),1);
n_nominal = 1200;   % vitesse de rotation nominale

for i = 1:length(n)
    % contrainte
    if n(i) <= 130
        contraint(i) = 3.4;   % g/(kW-h)
    elseif (130 < n(i)) && (n(i) < 1999)
        contraint(i) = 9*n(i)^(-0.2);
    else 
        contraint(i) = 2;
    end
end

% allure puissance-vitesse de rotation en annexe 1
pourent_puissance = 9/7*n/n_nominal - 2/7;
% Coeff de polynome
p5=-418; p4=1.28e3; p3=-1.51e3; p2=0.969e3; p1=-0.463e3; p0=0.355e3;
conso_gazole = p5*pourent_puissance.^5 + p4*pourent_puissance.^4 + ...
                    p3*pourent_puissance.^3 + p2*pourent_puissance.^2 + ...
                    p1*pourent_puissance + p0;
emission = conso_gazole*gazoletoNOx*(1-Redu_emission);

figure();
plot(n,emission, "LineWidth",2, 'Color','g')
hold on;
plot(n,contraint,'LineWidth',2,'Color','r');
legend('Emission','Contrainte')

title(sprintf('Emission - Contrainte (Réduction = %d %%)', Redu_emission*100), ...
                    'FontSize', 14, 'FontWeight', 'bold');
xlabel('Vitesse de rotation (RPM)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Emission NOx (g/kW-h)', 'FontSize', 12, 'FontWeight', 'bold');  
