function [ imd ] = texture_synthesis( tex, imd_size, patch_size )
    imd = zeros(imd_size(1), imd_size(2), 3);
    mask = zeros(imd_size(1), imd_size(2));
    
    % Fill the seed & the mask
    seed_size = 3;
    tex_x = randi(size(tex,1) - patch_size + 1, 1);
    tex_y = randi(size(tex,2) - patch_size + 1, 1);
    imd_x = floor((imd_size(1) - seed_size)/2);
    imd_y = floor((imd_size(2) - seed_size)/2);
    imd(imd_x:imd_x+seed_size-1, imd_y:imd_y+seed_size-1, :) = tex(tex_x:tex_x+seed_size-1, tex_y:tex_y+seed_size-1, :);
    mask(imd_x:imd_x+seed_size-1, imd_y:imd_y+seed_size-1) = ones(seed_size, seed_size);
    
    figure;
    imagesc(imd);
    figure;
    imagesc(mask);
    
    mask_dilation = dilation(mask);
    pixel_queue = mask_dilation - mask
    
end

