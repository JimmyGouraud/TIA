function [ cut ] = findCut(patchA, patchB, mask, patch_size, ov_size)
  patchA = rgb2gray(patchA) .* mask;
  patchB = rgb2gray(patchB) .* mask;
  cut = zeros(patch_size, patch_size);
  patch = (patchA - patchB) .^ 2;
  
  if (mask(1, patch_size) == 1) % horizontal overlap
    patch = rot90(patch);
    cut = rot90(cut);
    cut = computeCut(cut, patch, patch_size, ov_size);
    patch = rot90(patch,3);
    cut = rot90(cut,3);
  end 
  
  if (mask(patch_size, 1) == 1) % vertical overlap
    cut = computeCut(cut, patch, patch_size, ov_size);
  end
end