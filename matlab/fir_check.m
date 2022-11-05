clear; clc; close all;
fir_matlab = load("./float/fir_m.result");
fir_qsim = readlines("../../qsim_dc/core/fir_fi.result");

% Change from fixed point output from QSIM to MATLAB fixed point
fir_qsim_fi = fi([1, 10000], 1, 64, 16);
for i = 1:10001
    fir_qsim_chars = char(fir_qsim(i));
    if(fir_qsim_chars(1) == '1') 
        fir_qsim_chars = strcat('11111111111111111111111', fir_qsim_chars);
    else
        fir_qsim_chars = strcat('00000000000000000000000', fir_qsim_chars);
    end
    fir_qsim_data = bin2int(fir_qsim_chars, 'uint64');
    fir_qsim_fi(i) = reinterpretcast(fir_qsim_data, ...
        numerictype(1,64,16));
end
fir_qsim_fi = fir_qsim_fi(2:10001)';

%%
RMSE = sqrt(mean(fir_matlab - double(fir_qsim_fi)).^2)
NRMSE = RMSE / (max(fir_matlab) - min(fir_matlab))
MAX_ERR = max((fir_matlab - double(fir_qsim_fi)) ./ ...
    (fir_matlab))