function [ imd ] = texture_synthesis( tex, imd_size, patch_size )

    % Initialisation imd/mask/patch_hs
    imd  = zeros(imd_size(1), imd_size(2), 3);
    mask = zeros(size(imd,1), size(imd,2));
    patch_hs = floor(patch_size / 2);

    % Fill the seed & the mask
    [imd, mask] = fill_seed(tex, patch_size, imd, mask);
    
    figure; imagesc(imd);
    figure; imagesc(mask);
    
    
    while(size(find(mask(:,:) == 0), 1) != 0) 
      % Find out unfilled pixels
      pixel_queue = find_unfilled_pixels(mask);
      
      for pixel = size(pixel_queue, 1)
        % On rajoute des 0 autour de imd/tex pour gérer les bords
        pad_imd  = padarray(imd, [patch_hs,patch_hs]);
        pad_mask = padarray(mask, [patch_hs,patch_hs]);
        pad_tex  = padarray(tex, [patch_hs,patch_hs]); 
        
        pixel += patch_hs;
        
        best_pixel = find_best_pixel(pad_imd(pixel(1,1)-patch_hs:pixel(1,1)+patch_sh), 
                                     pad_mask(pixel(1,1)-patch_hs:pixel(1,1)+patch_sh),
                                     pad_tex);
        
        pixel -= patch_hs;

        imd(pixel_queue(pixel,1),pixel_queue(pixel,2)) = tex(best_pixel(1,1),best_pixel(1,2));
      end
      
      break; % delete break
    end
end