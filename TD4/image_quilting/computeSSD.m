function [ ssd ] = computeSSD( patch_1, patch_2, mask )
   patch_1 = patch_1 .* mask;
   patch_2 = patch_2 .* mask;
   ssd = sum(sum(sum((patch_1 - patch_2).^2)));
end
