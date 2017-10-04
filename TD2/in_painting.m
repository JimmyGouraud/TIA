function [ imd ] = in_painting( target, mask, patch_size )
    
    imd = target;
    figure;

    % On rajoute des 0 autour de imd/tex/mask pour gérer les bords
    patch_hs = floor(patch_size / 2);
    pad_imd  = padarray(imd,  [patch_hs, patch_hs]);
    pad_mask = padarray(mask, [patch_hs, patch_hs]);
    
    while(size(find(mask(:,:) == 0), 1) ~= 0) 
      [ i, j ] = find_unfilled_pixels(mask);
      
      for index = 1:size(i)
          imd_i = i(index);
          imd_j = j(index);
          patch_mask = pad_mask(imd_i:imd_i+patch_size-1,imd_j:imd_j+patch_size-1);
          patch_imd  = pad_imd(imd_i:imd_i+patch_size-1,imd_j:imd_j+patch_size-1) .* patch_mask;

          min_ssd = intmax;
          best_i = 0;
          best_j = 0;
          for tar_i = 1:size(imd,1)-patch_size
              for tar_j = 1:size(imd,2)-patch_size
                  if target(tar_i+patch_hs, tar_j+patch_hs) ~= 0
                      patch_tar = target(tar_i:tar_i+patch_size-1,tar_j:tar_j+patch_size-1) .* patch_mask;
                      ssd = computeSSD(patch_tar, patch_imd);
                      if (min_ssd > ssd)
                          min_ssd = ssd;
                          best_i = tar_i+patch_hs;
                          best_j = tar_j+patch_hs;
                      end
                  end
              end
          end
                      
          mask(imd_i, imd_j) = 1;
          pad_mask(imd_i+patch_hs, imd_j+patch_hs) = 1;
          pad_imd(imd_i+patch_hs,imd_j+patch_hs,:) = imd(best_i,best_j,:);
          
          imagesc(pad_imd);
          drawnow;
      end
    end
    imd = pad_imd(patch_hs+1:size(pad_imd,1)-patch_hs, patch_hs+1:size(pad_imd,2)-patch_hs, :);
    figure; imagesc(imd);
end

