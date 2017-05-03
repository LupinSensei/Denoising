function [imgs, nb_imgs] = read_images()
% -- Read the images from the folder data
% -- Return a cell with names of images in the folder.
% -- [imgs, nb_imgs] = read_images()
% -- Output : 
% --        imgs : paths of thes images in the folder data <cell>
% --        nb_imgs : nomber of images in the folder data

    doc_img = [pwd,'/','data'];
    img = dir(doc_img);
    nb_img = length(img);
    imgs = cell(nb_img-2,1);
    for ii=3:nb_img
        imgs{ii-2} = [doc_img,'/',img(ii).name];
    end
    nb_imgs = length(imgs);
end