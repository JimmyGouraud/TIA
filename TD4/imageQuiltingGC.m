function [ imd ] = imageQuiltingGC(filename, patch_size);

  if (exist('OCTAVE_VERSION', 'builtin'))
     pkg load image
  end

  tex = im2double(imread(filename));
  ov_size = floor(patch_size / 5);

  % Initialise patchA and patchB
  patchA = ones(patch_size, patch_size, 3);
  rand_i = randi(size(tex,1)-patch_size);
  rand_j = randi(size(tex,2)-patch_size);
  patchA(1:patch_size, 1:patch_size, :) = tex(rand_i:rand_i+patch_size-1, rand_j:rand_j+patch_size-1, :);

  patchB = ones(patch_size, patch_size, 3);
  rand_i = randi(size(tex,1)-patch_size);
  rand_j = randi(size(tex,2)-patch_size);
  patchB(1:patch_size, 1:patch_size, :) = tex(rand_i:rand_i+patch_size-1, rand_j:rand_j+patch_size-1, :);

  cut = findCutGC(patchA, patchB, patch_size, ov_size);
    
  imd = zeros(patch_size, patch_size * 2 - ov_size, 3);
  imd(1:patch_size, 1:patch_size, :) = patchA;

  offset = patch_size - ov_size;
  for i=1:patch_size
    for j=1:patch_size
      if (cut(i,j) == 0) 
        imd(i, offset+j, :) = patchB(i,j,:);
      end
    end
  end
end

