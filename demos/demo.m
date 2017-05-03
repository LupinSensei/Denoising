%
clear
close all;

%
I = double(imread('barbara.tiff'));
I = I(100-16:100+15, 430-16:430+15);
%
std = 15;
f0  = I + std*randn(size(I,1), size(I,2));

%
lbd = 0.5; % should be changed to see if this is a good value
% -- Other Values !!
% lbd = 0.3;
% lbd = 0.7;
% lbd = linspace(0.1,1,10);
 nb_iter = 100;

%
[f, nrj] = block_tnv_denoise(f0, lbd, nb_iter, 0);
% 
% 
figure('Name','Energy','NumberTitle','off');
plot(1:numel(nrj), log10(1 + nrj));
% 
figure('Name','Results of denoising Images','NumberTitle','off');
subplot(2,2,1), imshow(uint8(I)); title('Original Image');
subplot(2,2,2), imshow(uint8(f0));title('Noisy Image');
subplot(2,2,3), imshow(uint8(f)); title('Denoised Image');
linkaxes

psnrs
