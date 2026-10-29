
%% Bước 1: Xuat he so FIR va tin hieu dau vao cho Verilog

clear;
clc;

% Doc du lieu tham chieu
load('FIR_Lowpass_Reference.mat');

% Kiem tra he so bo loc
assert(length(b) == 32, ...
    'Loi: Bo loc khong co dung 32 he so.');

%% 1. Chuyen he so sang Q15

B_Q15 = round(b(:) * 2^15);

% Gioi han trong pham vi so nguyen 16 bit co dau
B_Q15 = max(-32768, min(32767, B_Q15));
B_Q15 = int16(B_Q15);

% Chuyen sang dang hex 16 bit bu 2
B_hex = dec2hex(typecast(B_Q15, 'uint16'), 4);

% Ghi moi he so tren mot dong
fid = fopen('fir_coeff.hex', 'w');
assert(fid ~= -1, 'Khong mo duoc file fir_coeff.hex');

for k = 1:length(B_Q15)
    fprintf(fid, '%s\n', B_hex(k,:));
end

fclose(fid);

%% 2. Luong tu hoa tin hieu dau vao thanh so nguyen 8 bit

x = x_in.Data(:);

% Scale 100 de han che tran voi tin hieu bien do toi da 1.2
X_SCALE = 100;
x_q = round(x * X_SCALE);

% Gioi han trong pham vi int8
x_q = max(-128, min(127, x_q));
x_q = int8(x_q);

% Chuyen sang hex 8 bit bu 2
x_hex = dec2hex(typecast(x_q, 'uint8'), 2);

% Ghi moi mau tren mot dong
fid = fopen('fir_input.hex', 'w');
assert(fid ~= -1, 'Khong mo duoc file fir_input.hex');

for k = 1:length(x_q)
    fprintf(fid, '%s\n', x_hex(k,:));
end

fclose(fid);

%% 3. Luu cac thong so de doi chieu sau nay

save('FIR_Verilog_Data.mat', ...
    'b', 'B_Q15', 'x', 'x_q', 'X_SCALE');

fprintf('Da xuat du lieu thanh cong!\n');
fprintf('So he so FIR: %d\n', length(B_Q15));
fprintf('So mau dau vao: %d\n', length(x_q));
fprintf('He so: fir_coeff.hex\n');
fprintf('Tin hieu vao: fir_input.hex\n');
fprintf('Du lieu MATLAB: FIR_Verilog_Data.mat\n');
