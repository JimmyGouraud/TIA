
% Test Seam Carving
filename = 'text1.jpg';
patch_size = 25;
size_imd = [100, 100];

imd = imageQuilting(filename, patch_size, size_imd);
figure;imshow(imd);

% Test Graph Cut


