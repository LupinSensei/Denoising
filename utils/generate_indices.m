function [ind_d, ind_c] =  generate_indices(img, k)

% -- initialise the dim of Click to 2
if(nargin < 2)
    k = 2;
end
% -- reshaping the dimension of The Image
if(mod(numel(img), (k^2)))
   img = img(1:end-1,1:end-1); 
end
% --  instruction temporaire !! 
% if(k~=2)
%     k =2;
% end

img = matrix2index(img);
temp_D_in = reshape(img, [numel(img) 1]);
% --
ind_c = cell(1,k*k);
ind_d = cell(1,k*k);
for cas = 1:(k*k)
    switch k
        case 2
            imgc = reshapeImage_2x2(img, cas);
        case 3
            imgc = reshapeImage_3x3(img, cas);
        case 4
            imgc = reshapeImage_4x4(img, cas);
        case 5
            imgc = reshapeImage_2x2(img, cas);
    end
ind = 0;
[row, col] = size(imgc);
    for i=1:k:row-1
        for j=1:k:col-1
            ind = [ind; reshape(imgc((i:i+1),(j:j+1)),4,1)];
        end
    end
    ind_c{cas} = ind(ind>0);
    temp = temp_D_in;
    temp(ind_c{cas}) = [];
    ind_d{cas} = temp;
end
end
 


% -- Block Size 2x2
function [imgc] = reshapeImage_2x2(img, stat)
switch stat
    case 1
        imgc = img;
    case 2
        imgc = img(:,2:end-1);
    case 3
        imgc = img(2:end-1,:);
    case 4
        imgc = img(2:end-1,2:end-1);
end
end


%-- Pour des click 3x3
function [imgc] = reshapeImage_3x3(img, stat)
switch stat
    case 1
        imgc = img;
    case 2
        imgc = img(:,2:end-1);
    case 3
        imgc = img(:,3:end-2);
    case 4
        imgc = img(2:end-1,:);
    case 5
        imgc = img(2:end-1,2:end-1);
    case 6
        imgc = img(2:end-1,3:end-2);
    case 7
        imgc = img(3:end-2,:);
    case 8
        imgc = img(3:end-2,2:end-1);
    case 9
        imgc = img(3:end-2,3:end-2);
end
end


%-- Pour des click 4x4
function [imgc] = reshapeImage_4x4(img, stat)
switch stat
    case 1
        imgc = img;
    case 2
        imgc = img(:,2:end-1);
    case 3
        imgc = img(:,3:end-2);
    case 4
        imgc = img(:,4:end-3);
    case 5
        imgc = img(2:end-1,:);
    case 6
        imgc = img(2:end-1,2:end-1);
    case 7
        imgc = img(2:end-1,3:end-2);
    case 8
        imgc = img(2:end-1,4:end-3);
    case 9
        imgc = img(3:end-2,:);
    case 10
        imgc = img(3:end-2,2:end-1);
    case 11
        imgc = img(3:end-2,3:end-2);
    case 12
        imgc = img(3:end-2,4:end-3);
    case 13
        imgc = img(4:end-3,:);
    case 14
        imgc = img(4:end-2,2:end-1);
    case 15
        imgc = img(4:end-2,3:end-2);
    case 16
        imgc = img(4:end-2,4:end-3);
end
end


% %-- Pour des click 3x3
% function imgc = reshapeImage_3x3(img, stat)
% switch stat
%     case 1
%         imgc = img;
%     case 2
%         imgc = img(:,2:end-1);
%     case 3
%         imgc = img(:,3:end-2);
%     case 4
%         imgc = img(2:end-1,:);
%     case 5
%         imgc = img(2:end-1,2:end-1);
%     case 6
%         imgc = img(2:end-1,3:end-2);
%     case 8
%         imgc = img(3:end-2,:);
%     case 8
%         imgc = img(3:end-2,2:end-1);
%     case 9
%         imgc = img(3:end-2,3:end-2);
% end
% end