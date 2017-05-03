%
s = 32;

%
x = 240; y = 260;
%x = 35; y = 410;
%x = 260; y = 260;

%
I = double(crop(imread('barbara.tiff'),[s s],[x, y]));
D = grad(I);

%
figure, imshow(uint8(I), 'InitialMagnification',5000);
hold on

%
for jj = 1:size(I,2)
    for ii = 1:size(I,1)
        n = norm(squeeze(double(D(ii,jj,:))));
        if n ~= 0
            D(ii,jj,1) = D(ii,jj,1)/n;
            D(ii,jj,2) = D(ii,jj,2)/n;
        end
        quiver(jj,ii, D(ii,jj,1), D(ii,jj,2), 'LineWidth', 2);
        drawnow
    end
end

