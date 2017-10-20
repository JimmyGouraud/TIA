function [ imgC ] = patchMatching( nb_iter, patch_hs, filenameA, filenameB, filenameC )
    if (exist ('OCTAVE_VERSION', 'builtin'))
      pkg load image
    end

    imgA = im2double(imread(filenameA));
    imgB = im2double(imread(filenameB));
    imgC = zeros(size(imgA, 1), size(imgA, 2), 3);
          
    patch_size = patch_hs * 2 + 1;
    NNF = zeros(size(imgC,1),size(imgC,2),2);

    pad_imgA  = padarray(imgA,  [patch_hs, patch_hs], -1);
    pad_imgB = padarray(imgB, [patch_hs, patch_hs], -1);

    % Initialisation de C avec des pixels aléatoires de B
    for i=1:size(imgC,1)
        for j=1:size(imgC,2)
            i2 = randi(size(imgC,1)-patch_size)+patch_hs;
            j2 = randi(size(imgC,2)-patch_size)+patch_hs;
            imgC(i,j,:) = imgB(i2,j2,:);
            NNF(i,j,:) = [i2,j2];
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

    for iter=1:nb_iter
      fprintf('iter = %d\n', iter);
      
      if (mod(iter,2) == 1)
         offset = -1;
      else
         offset = 1;
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
              
              i2 = NNF(i1,j1,1);
              j2 = NNF(i1,j1,2);
              patch_imgA = pad_imgA(i1:i1+patch_size-1, j1:j1+patch_size-1,:);
              patch_imgB = pad_imgB(i2:i2+patch_size-1, j2:j2+patch_size-1,:);
              
              mask = ones(patch_size, patch_size, 3);
              mask(find(patch_imgA < 0)) = 0;
              
              best_i = i2;
              best_j = j2;
              
              ssd = computeSSD(patch_imgA, patch_imgB, mask);
              if (i1+offset >= 1 && i1+offset <= size(imgC,1))
                  i2 = NNF(i1+offset,j1,1)-offset;
                  j2 = NNF(i1+offset,j1,2);
                  
                  if(i2 > 0 && i2 <= size(imgB,1)) 
                      patch_imgB = pad_imgB(i2:i2+patch_size-1, j2:j2+patch_size-1,:);
                      ssd2 = computeSSD(patch_imgA, patch_imgB, mask);
                      if (ssd2 < ssd) 
                         best_i = i2;
                         best_j = j2;
                         ssd = ssd2;
                      end
                  end
              end
              
              if (j1+offset >= 1 && j1+offset <= size(imgC,2))
                  i2 = NNF(i1,j1+offset,1);
                  j2 = NNF(i1,j1+offset,2)-offset;
                  
                  if(j2 > 0 && j2 <= size(imgB,2))
                      patch_imgB = pad_imgB(i2:i2+patch_size-1, j2:j2+patch_size-1,:);
                      ssd2 = computeSSD(patch_imgA, patch_imgB, mask);
                      if (ssd2 < ssd) 
                         best_i = i2;
                         best_j = j2;
                         ssd = ssd2;
                      end
                  end
              end
              
              imgC(i1,j1,:) = imgB(best_i, best_j,:);
              NNF(i1,j1,:) = [best_i,best_j];
          end
          
          imagesc(imgC);
          title('imgC');
          drawnow;
      end
      filenameIter = strcat(filenameC(1:size(filenameC, 2) - 5), '_hs', int2str(patch_hs), '_iter', int2str(iter), '.png');
      imwrite (imgC, filenameIter);
    end
    
    imwrite (imgC, filenameC);
end