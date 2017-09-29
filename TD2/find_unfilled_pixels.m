function [ i,j ] = find_unfilled_pixels ( mask )
   mask_dilation = imdilate(mask, strel('square',3));
   pixel_queue = mask_dilation - mask;
   
   [ i,j ] = ind2sub(size(mask), find(pixel_queue == 1));
end 