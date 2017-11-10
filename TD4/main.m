
% Test Seam Carving
filename = 'text1.jpg';
patch_size = 25;
size_imd = [300, 300];

imd = imageQuilting(filename, patch_size, size_imd);
figure;imshow(imd);

% Test Graph Cut


