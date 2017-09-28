function [ index_pixel ] = find_unfilled_pixels ( mask )
   SE = strel('square',3);
   mask_dilation = imdilate(mask, SE);
   pixel_queue = mask_dilation - mask;
          
   rows = mod(find(pixel_queue == 1), size(pixel_queue,1));
   cols = floor(find(pixel_queue == 1) / size(pixel_queue, 2));
   index_pixel = [rows, cols];
end 