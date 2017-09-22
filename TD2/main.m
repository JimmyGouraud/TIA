
tex = imread('text1.jpg');
tex = im2double(tex);
imd_size = [size(tex,1) * 2, size(tex,2) * 2];
patch_size = 9;

imd = texture_synthesis(tex, imd_size, patch_size);



