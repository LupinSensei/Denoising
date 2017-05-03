function lF = laplacian_freq_response(s1, s2)
% LAPLACIAN_FREQ_RESPONSE: FFT2 OF NABLA^T NABLA.
%    
%  laplacian_freq_response(s1, s2)
%     s1: number of rows
%     s2: number of columns

delta = zeros(s1, s2);
delta(1) = 1;
opt.bound = 'per';
imp_lap = -div(grad(delta, opt), opt); % impulse response of the laplacian filter
lF = fft2(imp_lap);          % eignevalues of the laplacian


