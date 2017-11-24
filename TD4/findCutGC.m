function [ cut ] = findCutGC(patchA, patchB, patch_size, ov_size)

  pause(5);
  
  class = zeros(ov_size * patch_size, 1);
  class(1:ov_size:patch_size*ov_size) = 0;
  class(ov_size:ov_size:patch_size*ov_size) = 1;

  unary = ones(2, ov_size*patch_size);
  unary(:, 1:ov_size:patch_size*ov_size) = repmat([0; inf], 1, patch_size); 
  unary(:, ov_size:ov_size:patch_size*ov_size) = repmat([inf; 0], 1, patch_size); 

  labelcost = [0,1;1,0];

  pairwise = sparse(ov_size*patch_size,ov_size*patch_size);
  
  cpt = 0;
  for i=1:patch_size
   for j=1:ov_size
      offset = cpt * ov_size * patch_size + (i - 1) * ov_size + j;
      pixel = sum(abs(patchA(i,j,:) - patchB(i,j,:)));
      if (j ~= 1)
        pairwise(offset-1) = pixel + sum(abs(patchA(i,j-1,:) - patchB(i,j-1,:)));
      end
      if (j ~= ov_size)
        pairwise(offset+1) = pixel + sum(abs(patchA(i,j+1,:) - patchB(i,j+1,:)));
      end
      if (i ~= 1)
        pairwise(offset-ov_size) = pixel + sum(abs(patchA(i-1,j,:) - patchB(i-1,j,:)));
      end
      if (i ~= patch_size)  
        pairwise(offset+ov_size) = pixel + sum(abs(patchA(i+1,j,:) - patchB(i+1,j,:)));
      end
      cpt = cpt + 1;
    end
  end
  
  [labels E Eafter] = GCMex(class, single(unary), pairwise, single(labelcost), 0);   
  labels = reshape(labels, ov_size, patch_size)';

  cut = zeros(patch_size, patch_size);
  offset = patch_size - ov_size;
  for i=1:patch_size
    for j=1:ov_size
      if (labels(i,j) == 0) 
        cut(i,j) = 1;
      end
    end
  end
end