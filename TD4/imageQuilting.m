function [ imd ] = imageQuilting(filename, patch_size, size_imd);

  if (exist('OCTAVE_VERSION', 'builtin'))
     pkg load image
  end
  
  tex = im2double(imread(filename));
  ov_size = floor(patch_size / 5);
  
  % Initialisation of imd with a random block
  imd = ones(size_imd(1), size_imd(2), 3) * -1;
  rand_i = randi(size(tex,1)-patch_size);
  rand_j = randi(size(tex,2)-patch_size);
  imd(1:patch_size, 1:patch_size, :) = tex(rand_i:rand_i+patch_size-1, rand_j:rand_j+patch_size-1, :);

  offset = patch_size - ov_size;
  for i=1:offset:size_imd(1)
    for j=1:offset:size_imd(2)
      
      % don't compute the first case
      if (i == 1 && j == 1)
          continue;
      end
        
      % borders management
      if (i > size_imd(1) - patch_size) 
        i = size_imd(1) - patch_size + 1;
      end
      
      % borders management
      if (j > size_imd(2) - patch_size) 
        j = size_imd(2) - patch_size + 1;
      end
      
      patchA = imd(i:i+patch_size-1, j:j+patch_size-1, :);
      mask = ones(patch_size, patch_size);
      
      
      mask(find(patchA(:,:,1) == -1)) = 0;

      % Find best patch
      best_ssd = inf;
      best_coord = [1,1];
      for i2=1:size(tex,1)-patch_size
        for j2=1:size(tex,2)-patch_size
          patchB = tex(i2:i2+patch_size-1, j2:j2+patch_size-1, :);
          ssd = computeSSD(patchA, patchB, mask);
          if (ssd < best_ssd) 
            best_ssd = ssd;
            best_coord = [i2, j2];
          end
        end
      end
      patchB = tex(best_coord(1):best_coord(1)+patch_size-1, best_coord(2):best_coord(2)+patch_size-1, :);
      
      % Find cut
      cut = findCut(patchA, patchB, mask, patch_size, ov_size);
      for i2=1:patch_size
        for j2=1:patch_size
          if (cut(i2,j2) == 0) 
            imd(i+i2-1, j+j2-1, :) = patchB(i2,j2,:);
          end
        end
      end
      
      % Display
%      figure;imshow(patchA);
%      figure;imshow(patchB);
%      figure;imshow(cut);
%      figure;imshow(imd);
%      pause(5);
    end
  end
end
