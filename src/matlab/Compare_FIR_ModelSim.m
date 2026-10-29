
clc;
clear;
close all;

%% 1. Doc du lieu MATLAB da xuat
load('FIR_Verilog_Data.mat');

%% 2. Doc ket qua tu ModelSim
fid = fopen('fir_output.txt', 'r');

if fid == -1
    error('Khong tim thay fir_output.txt. Hay kiem tra thu muc hien tai.');
end

y_models = fscanf(fid, '%f');
fclose(fid);

%% 3. Kiem tra so luong mau
fprintf('So mau dau vao       : %d\n', length(x_q));
fprintf('So mau dau ra ModelSim: %d\n', length(y_models));

if length(y_models) ~= length(x_q)
    error('So mau khong khop. Hay kiem tra file fir_output.txt.');
end

%% 4. Quy doi dau ra ModelSim ve thang do tin hieu dau vao
% x_q la dau vao so nguyen 8-bit, da duoc chia theo X_SCALE
y_models_real = y_models / X_SCALE;

%% 5. Tinh dau ra tham chieu bang MATLAB
y_reference = filter(b, 1, double(x_q) / X_SCALE);

%% 6. Tinh sai so
error_signal = y_reference - y_models_real;

max_error = max(abs(error_signal));
rmse = sqrt(mean(error_signal.^2));

fprintf('\nKet qua so sanh:\n');
fprintf('Sai so tuyet doi lon nhat: %.8f\n', max_error);
fprintf('RMSE                     : %.8f\n', rmse);

%% 7. Ve do thi so sanh
n = 0:length(y_reference)-1;

figure;
plot(n, y_reference, 'b', 'LineWidth', 1.5);
hold on;
plot(n, y_models_real, 'r--', 'LineWidth', 1.2);
grid on;

xlabel('Chi so mau n');
ylabel('Bien do');
title('So sanh dau ra FIR: MATLAB va ModelSim');
legend('MATLAB tham chieu', 'ModelSim', 'Location', 'best');

%% 8. Ve sai so
figure;
plot(n, abs(error_signal), 'LineWidth', 1.2);
grid on;

xlabel('Chi so mau n');
ylabel('Sai so tuyet doi');
title('Sai so tuyet doi giua MATLAB va ModelSim');
