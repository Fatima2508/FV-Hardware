clear; clc; close all;
% Generate random Fixed point numbers
num_tests = 10000;
num_coeff = 64;
x = fi(zeros(1, num_tests), 1, 16, 8);
b = fi(zeros(1, num_coeff), 1, 16, 8);
y = zeros(1, num_tests);

b_out_file = fopen('./float/random_gen_b.result', 'w');
x_out_file = fopen('./float/random_gen_x.result', 'w');
fir_out_file = fopen('./float/fir_m.result', 'w');

% Generate 10,000 random 16 bit strings
for i = 1:num_tests
    temp = uint16(randi([0, 65535]));
    x(:, i) = reinterpretcast(temp, numerictype(1,16,8));
    fprintf(x_out_file, '%s\n', dec2bin(temp, 16));
end

% Generate 64 random 16 bit strings
for i = 1:num_coeff
    temp = uint16(randi([0, 65535]));
    b(:, i) = reinterpretcast(temp, numerictype(1,16,8));
    fprintf(b_out_file, '%s\n', dec2bin(temp, 16));
end

for n = 1:num_tests
    for i = 1:num_coeff
        b_fp = single(b(i));
        
        if ((n-i+1) > 0) && ((n-i+1) < (length(x)+1))
            x_fp = single(x(n-i+1));
            y_temp = b_fp * x_fp;
        else
            y_temp = 0;
        end
        y(n) = y(n) + y_temp;
    end
    fprintf(fir_out_file, '%f\n', y(n));
end
