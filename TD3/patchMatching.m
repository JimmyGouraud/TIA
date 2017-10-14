function [ imgC ] = patchMatching( nb_iter, patch_hs, filenameA, filenameB, filenameC )
    if (exist ('OCTAVE_VERSION', 'builtin'))
      pkg load image
    end

    imgA = im2double(imread(filenameA));
    imgB = im2double(imread(filenameB));
    imgC = zeros(size(imgA, 1), size(imgA, 2), 3);
          
    patch_size = patch_hs * 2 + 1;
    coor = zeros(size(imgC,1),size(imgC,2),2);

    pad_imgA  = padarray(imgA,  [patch_hs, patch_hs]);
    pad_imgB = padarray(imgB, [patch_hs, patch_hs]);

    % Initialisation de C avec des pixels aléatoires de B
    for i=1:size(imgC,1)
        for j=1:size(imgC,2)
            i2 = randi(size(imgC,1)-patch_size)+patch_hs;
            j2 = randi(size(imgC,2)-patch_size)+patch_hs;
            imgC(i,j,:) = imgB(i2,j2,:);
            coor(i,j,:) = [i2,j2];
        end
    end

    figure;
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
    for iter=1:nb_iter
      iter
      
      if (mod(iter,2) == 1)
         di = -1;
         dj = -1;
      else
         di = 1;
         dj = 1;
      end
      
      for i=1:size(imgC,1)
          for j=1:size(imgC,2)
              if (mod(iter,2) == 1)
                  i1 = i;
                  j1 = j;
              else
                  i1 = size(imgC,1)-i+1;
                  j1 = size(imgC,2)-j+1;
              end
              
              i2 = coor(i1,j1,1);
              j2 = coor(i1,j1,2);
              patch_imgA = pad_imgA(i1:i1+patch_size-1, j1:j1+patch_size-1,:);
              patch_imgB = pad_imgB(i2:i2+patch_size-1, j2:j2+patch_size-1,:);
              
              best_i = i2;
              best_j = j2;
              
              ssd = computeSSD(patch_imgA, patch_imgB);
              if (i1+di >= 1 && i1+di <= size(imgC,1))
                  i2 = coor(i1+di,j1,1)-di;
                  j2 = coor(i1+di,j1,2);
                  if(i2 < 1 || i2 > size(imgB,1)) 
                    continue;
                  end
                  
                  patch_imgB = pad_imgB(i2:i2+patch_size-1, j2:j2+patch_size-1,:);
                  ssd2 = computeSSD(patch_imgA, patch_imgB);
                  if (ssd2 < ssd) 
                     best_i = i2;
                     best_j = j2;
                     ssd = ssd2;
                  end
              end
              
              if (j1+dj >= 1 && j1+dj <= size(imgC,2))
                  i2 = coor(i1,j1+dj,1);
                  j2 = coor(i1,j1+dj,2)-dj;
                  if(i2 < 1 || i2 > size(imgB,2)) 
                    continue;
                  end
                  
                  patch_imgB = pad_imgB(i2:i2+patch_size-1, j2:j2+patch_size-1,:);
                  ssd2 = computeSSD(patch_imgA, patch_imgB);
                  if (ssd2 < ssd) 
                     best_i = i2;
                     best_j = j2;
                     ssd = ssd2;
                  end
              end
              
              imgC(i1,j1,:) = imgB(best_i, best_j,:);
              coor(i1,j1,:) = [best_i,best_j];
          end
          imagesc(imgC);
          drawnow;
      end
      filenameIter = strcat("iter", int2str(iter), ".png");
      imwrite (imgC, filenameIter);
    end
    
    imwrite (imgC, filenameC);
end