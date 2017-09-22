% 2. Template Matching
% 2.1. Extract randomly 4 small square templates (size 9x9)

img = imread('text1.jpg');
img2 = im2double(img);

nb_patch = 4
size_patch = 9

patches = zeros(nb_patch, size_patch, size_patch, 3);

for i=1:nb_patch
   x = randi(size(img,1) - size_patch + 1, 1);
   y = randi(size(img,2) - size_patch + 1, 1);
   img2(x:x+size_patch-1,y:y+size_patch-1,:);
   patches(i,:,:,:) = img2(x:x+size_patch-1,y:y+size_patch-1,:);
   figure;
   imagesc(squeeze(patches(i,:,:,:)));
end

% 2.2. Compute the similarity using metrics
% On va calculer la SSD/ZNCC/SAD entre chaque patch
for i=1:nb_patch-1
    for j=i+1:nb_patch
        P1 = patches(i,:,:,:);
        P2 = patches(j,:,:,:);
        
        res_ssd = ssd(squeeze(P1), squeeze(P2));
        res_zncc = zncc(squeeze(P1), squeeze(P2));
        res_sad = sad(squeeze(P1), squeeze(P2));
    end
end




