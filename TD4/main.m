
% Test Seam Carving
filename = 'text1.jpg';
patch_size = 25;
size_imd = [300, 300];

% Dynamic Programming
imd = imageQuilting(filename, patch_size, size_imd);
figure;imshow(imd);

% Graph Cut
imd = imageQuiltingGC(filename, patch_size);
figure;imshow(imd);

