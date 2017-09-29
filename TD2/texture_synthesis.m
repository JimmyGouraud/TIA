function [ imd ] = texture_synthesis( tex, imd_size, patch_size )

    % Initialisation imd/mask/patch_hs
    imd  = zeros(imd_size(1), imd_size(2), 3);
    mask = zeros(size(imd,1), size(imd,2));
    
    % Fill the seed & the mask
    [imd, mask] = fill_seed(tex, patch_size, imd, mask);
    
    figure; imagesc(imd);
    figure; imagesc(mask);

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
          for tex_i = 1:size(tex,1)-patch_size
              for tex_j = 1:size(tex,2)-patch_size
                  patch_tex = tex(tex_i:tex_i+patch_size-1,tex_j:tex_j+patch_size-1) .* patch_mask;
                  ssd = computeSSD(patch_tex, patch_imd);
                  if (min_ssd > ssd)
                      min_ssd = ssd;
                      best_i = tex_i + patch_hs;
                      best_j = tex_j + patch_hs;
                  end
              end
          end
                      
          mask(imd_i, imd_j) = 1;
          pad_mask(imd_i+patch_hs, imd_j+patch_hs) = 1;
          pad_imd(imd_i+patch_hs,imd_j+patch_hs,:) = tex(best_i,best_j,:);
          
          imagesc(pad_imd);
          drawnow;
      end
    end
    imd = pad_imd(patch_hs+1:size(pad_imd,1)-patch_hs, patch_hs+1:size(pad_imd,2)-patch_hs, :);
    figure; imagesc(imd);
end