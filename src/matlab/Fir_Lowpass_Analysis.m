
% Bước 6.1: Vẽ tín hiệu trước và sau khi lọc FIR

load('FIR_Lowpass_Reference.mat');

% Lấy dữ liệu từ Timeseries
t_in = x_in.Time;
x = x_in.Data;

t_out = y_out.Time;
y = y_out.Data;

% Đưa dữ liệu về vector cột
x = x(:);
y = y(:);
t_in = t_in(:);
t_out = t_out(:);

% Vẽ tín hiệu đầu vào và đầu ra
figure;

subplot(2,1,1);
plot(t_in, x);
grid on;
title('Input Signal - Before FIR Lowpass Filter');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t_out, y);
grid on;
title('Output Signal - After FIR Lowpass Filter');
xlabel('Time (s)');
ylabel('Amplitude');



% Bước 7: Phân tích đáp ứng tần số

Fs = 8000;          % Tan so lay mau (Hz)
N = length(b);      % So he so cua bo loc

[H, f] = freqz(b, 1, 2048, Fs);

figure;
plot(f, 20*log10(max(abs(H), 1e-8)));
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Frequency Response of FIR Lowpass Filter');

xlim([0 Fs/2]);
ylim([-100 5]);



% Bước 8: Kiem tra muc dap ung tai 500 Hz va 2500 Hz

f_test = [500 2500];

H_test = freqz(b, 1, 2*pi*f_test/Fs);

gain_dB = 20*log10(max(abs(H_test), 1e-8));

fprintf('Frequency response:\n');
fprintf('500 Hz  : %.2f dB\n', gain_dB(1));
fprintf('2500 Hz : %.2f dB\n', gain_dB(2));
