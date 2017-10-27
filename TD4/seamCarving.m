tex = im2double(imread('text1.jpg'));

patch_size = 50;
ia = randi(size(tex,1)-patch_size);
ja = randi(size(tex,2)-patch_size);
patchA = rgb2gray(tex(ia, ja, :));

ib = randi(size(tex,1)-patch_size);
jb = randi(size(tex,2)-patch_size);
patchB = rgb2gray(tex(ib, jb, :));

size_ov = floor(patch_size / 5);

ovA = patchA(size(patchA, 1) - size_ov+1:size(patchA, 1), 1:size(patchA, 2));
ovB = patchB(1:size_ov, 1:size(patchB, 2));
imshow(ovA);
imshow(ovB);

patch_ov = (ovA - ovB) .^ 2;
pad_ov = padarray(patch_ov,  [0, 1], inf);

for i=2:size(patch_ov,1)
    for j=1:size(patch_ov,2)
        pad_ov(i,j+1) = min(patch_ov(i,j-1), patch_ov(i,j), patch_ov(i,j+1));
    end
end


