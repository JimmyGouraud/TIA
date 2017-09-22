% 2. Template Matching
% 2.1. Extract randomly 4 smal square templates

img = imread('text1.jpg');
img2 = im2double(img);

size_patch = 9
patches = zeros(4,9,9,3)

for i=1:4
   x = randi(size(img,1) - size_patch + 1, 1)
   y = randi(size(img,2) - size_patch + 1, 1)
   img2(x:x+size_patch-1,y:y+size_patch-1,:)
   patches(i,:,:,:) = img2(x:x+size_patch-1,y:y+size_patch-1,:)
   figure
   imagesc(squeeze(patches(i,:,:,:)))
end

% 2.2. Compute the similarity
% SSD
for i=1:3
    for j=i+1:4
        res = sum(sum(sum((patches(i,:,:,:) - patches(j,:,:,:)).^2)))
    end
end
