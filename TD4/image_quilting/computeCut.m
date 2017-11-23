function [ cut ] = computeCut(cut, patch, patch_size, ov_size)
  % Compute overlap and create a border at inf
  ov = patch(1:patch_size, 1:ov_size);
  ov = padarray(ov,  [0, 1], inf);

  % Compute overlap with a cost function
  for i=2:patch_size
    for j=2:ov_size+1
      ov(i,j) = ov(i,j) + min([ov(i-1,j-1), ov(i-1,j), ov(i-1,j+1)]);
    end
  end

  [m, j] = min(ov(patch_size, :));
  cut(patch_size, 1:j-1) = 1;
  
  for i=patch_size-1:-1:1
    [m, index] = min([ov(i,j-1), ov(i,j), ov(i,j+1)]);
    j = j+index-2; % We normalize between -1 and 1
    cut(i, 1:j-1) = 1;
  end
end