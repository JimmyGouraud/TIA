
imgA = im2double(imread('a.png'));
imgB = im2double(imread('b.png'));
imgC = zeros(size(imgA, 1), size(imgA, 2), 3);

patch_hs = 4;
patch_size = patch_hs * 2 + 1;
coor = zeros(size(imgC,1),size(imgC,2),2);

pad_imgA  = padarray(imgA,  [patch_hs, patch_hs]);
pad_imgB = padarray(imgB, [patch_hs, patch_hs]);

% Initialisation de C avec des pixels aléatoires de B
index = 1
for i=1:size(imgC,1)
    for j=1:size(imgC,2)
        i2 = randi(size(imgC,1)-patch_size)+patch_hs;
        j2 = randi(size(imgC,2)-patch_size)+patch_hs;
        imgC(i,j,:) = imgB(i2,j2,:);
        coor(i,j,:) = [i2,j2];
        index = index+1;
    end
end

subplot(1,3,1);
imagesc(imgA);
title('imgA');
subplot(1,3,2);
imagesc(imgB);
title('imgB');
subplot(1,3,3);
imagesc(imgC);
title('imgC');

figure;
for i=1:size(imgC,1)
    for j=1:size(imgC,2)
        i2 = coor(i,j,1);
        j2 = coor(i,j,2);
        patch_imgA = pad_imgA(i:i+patch_size-1, j:j+patch_size-1,:);
        patch_imgB = pad_imgB(i2:i2+patch_size-1, j2:j2+patch_size-1,:);
        
        best_i = i2;
        best_j = j2;
        
        ssd = computeSSD(patch_imgA, patch_imgB);
        if (i > 1 && i2 < size(pad_imgB,1)-patch_hs)
            i2 = coor(i-1,j,1);
            j2 = coor(i-1,j,2);
            patch_imgB = pad_imgB(i2+1:i2+1+patch_size-1, j2:j2+patch_size-1,:);
            ssd2 = computeSSD(patch_imgA, patch_imgB);
            if (ssd2 < ssd) 
               best_i = i2;
               best_j = j2;
               ssd = ssd2;
            end
        end
        
        if (j > 1 && j2 < size(pad_imgB,1)-patch_hs)
            i2 = coor(i,j-1,1);
            j2 = coor(i,j-1,2);
            patch_imgB = pad_imgB(i2:i2+patch_size-1, j2+1:j2+patch_size,:);
            ssd2 = computeSSD(patch_imgA, patch_imgB);
            if (ssd2 < ssd) 
               best_i = i2;
               best_j = j2;
               ssd = ssd2;
            end
        end
        
        imgC(i,j,:) = imgB(best_i, best_j,:);
        index = index+1;
    end
    i
    imagesc(imgC);
    drawnow;
end



