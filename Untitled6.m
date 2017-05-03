% A = rand(50, 50, 50) < 0.01;  % synthetic data
% [x, y, z] = ind2sub(size(A), find(A));
% plot3(x, y, z, 'k.');

%# create stacked images (I am simply repeating the same image 5 times)
[X, map] = imread('C:\Users\Asus\Desktop\EMBRYON.jpg');
I = repmat(X,[1 1 5]);
cmap = map;

%# coordinates
[X,Y] = meshgrid(1:size(I,2), 1:size(I,1));
Z = ones(size(I,1),size(I,2));

%# plot each slice as a texture-mapped surface (stacked along the Z-dimension)
for k=1:size(I,3)
    surface('XData',X-0.5, 'YData',Y-0.5, 'ZData',Z.*k, ...
        'CData',I(:,:,k), 'CDataMapping','direct', ...
        'EdgeColor','none', 'FaceColor','texturemap')
end
colormap(cmap)
view(3), box on, axis tight square
set(gca, 'YDir','reverse', 'ZLim',[0 size(I,3)+1])