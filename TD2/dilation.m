function [ mask_dilation ] = dilation( mask )
    patch = ones(3);
    mask_dilation = conv2(mask, patch, 'same');
    mask_dilation(find(mask_dilation(:,:) >= 1)) = 1;
end

