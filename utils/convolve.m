function J = convolve(I, h)
% CONVOLVE: CONV2 WITH CIRCULAR EXTENSION INSTEAD OF ZERO-PADDING.
%    
%  convolve(I, h)
%     I: input image
%     h: convolution kernel

r = floor(size(h, 1) / 2);
I_padded = I([end-r+1:end 1:end 1:r], [end-r+1:end 1:end 1:r]);
J = conv2(I_padded, h, 'valid');

end
