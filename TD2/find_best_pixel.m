function [ best_pixel ] = find_best_pixel( patch_imd, patch_mask, tex)
  
  patch_imd * patch_mask;
  tex
  all_ssd = tex;
  all_ssd = ssd(patch_imd .* patch_mask)
  best_pixel = [1 1]
end 