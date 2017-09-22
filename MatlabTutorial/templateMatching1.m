% 2. Template Matching
% 2.1. Extract randomly 4 small square templates (size 9x9)

img = imread('text1.jpg');
img2 = im2double(img);

size_patch = 9
nb_patch = 4

patches = zeros(4,9,9,3);

for i=1:nb_patch
   x = randi(size(img,1) - size_patch + 1, 1);
   y = randi(size(img,2) - size_patch + 1, 1);
   img2(x:x+size_patch-1,y:y+size_patch-1,:);
   patches(i,:,:,:) = img2(x:x+size_patch-1,y:y+size_patch-1,:);
   figure;
   imagesc(squeeze(patches(i,:,:,:)));
end

% 2.2. Compute the similarity
% SSD (On va calculer la SSD entre chaque patch)
for i=1:nb_patch-1 
    for j=i+1:nb_patch
        P1 = patches(i,:,:,:);
        P2 = patches(j,:,:,:);
        
        ssd = sum(sum(sum((P1 - P2).^2)));
    end
end

% ZNCC
for i=1:nb_patch-1 
    for j=i+1:nb_patch
        P1 = patches(i,:,:,:);
        P2 = patches(j,:,:,:);
        
        meanP1 = (1/(size_patch*size_patch)) * sum(sum(sum(patches(i,:,:,:))));
        meanP2 = (1/(size_patch*size_patch)) * sum(sum(sum(patches(j,:,:,:))));
        
        zccP1 = (P1 - meanP1);
        zccP2 = (P2 - meanP2);
        
        zncc = (zccP1  .* zccP2) ./ (sqrt(zccP1.^2) .* sqrt(zccP2.^2));
    end
end

% SAD


