%pkg load image


imd_size = [100,100];
patch_size = 9;

%imd = texture_synthesis('text1.jpg', imd_size, patch_size);

target = im2double(imread('text1.jpg'));
mask = ones(size(target,1), size(target,2));
mask(size(target,1)/4: size(target,1) - size(target,2)/4, size(target,2)/4: size(target,2) - size(target,2)/4) = 0;
target(size(target,1)/4: size(target,1) - size(target,2)/4, size(target,2)/4: size(target,2) - size(target,2)/4,:) = 0;
imd = in_painting( target, mask, patch_size );


