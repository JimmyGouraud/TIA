
% Test Seam Carving
filename = 'text1.jpg';
patch_size = 25;
size_imd = [300, 300];

%imd = imageQuilting(filename, patch_size, size_imd);
%figure;imshow(imd);

% Test Graph Cut

% pkg load image
tex = im2double(imread(filename));
ov_size = floor(patch_size / 5);

% Initialise patchA and patchB
patchA = ones(patch_size, patch_size, 3);
rand_i = randi(size(tex,1)-patch_size);
rand_j = randi(size(tex,2)-patch_size);
patchA(1:patch_size, 1:patch_size, :) = tex(rand_i:rand_i+patch_size-1, rand_j:rand_j+patch_size-1, :);
patchB = ones(patch_size, patch_size, 3);
rand_i = randi(size(tex,1)-patch_size);
rand_j = randi(size(tex,2)-patch_size);
patchB(1:patch_size, 1:patch_size, :) = tex(rand_i:rand_i+patch_size-1, rand_j:rand_j+patch_size-1, :);



width = ov_size;
height = patch_size;
class = zeros(width * height, 1) - 1;
class(1:width:height*width) = 0;
class(width:width:height*width) = 1;

unary = ones(2, width*height);
unary(:, 1:width:height*width) = repmat([inf; 0], 1, height); 
unary(:, width:width:height*width) = repmat([0; inf], 1, height); 

labelcost = [0,1;1,0];

pairwise = sparse(width*height,width*height);
pairwise(:,:) = 0; % useful?

cpt = 0;
for i=1:height
  for j=1:width
    offset = cpt * width * height + (i - 1) * width + j;
    % TODO: precompute abs(patchA(i,j,:));
    if (j ~= 1)
      pairwise(offset-1) = sum(abs(patchA(i,j,:) - patchB(i,j,:)) + abs(patchA(i,j-1,:) - patchB(i,j-1,:)));
      pairwise(offset) = pairwise(offset) + pairwise(offset-1);
    end
    if (j ~= width)
      pairwise(offset+1) = sum(abs(patchA(i,j,:) - patchB(i,j,:)) + abs(patchA(i,j+1,:) - patchB(i,j+1,:)));
      pairwise(offset) = pairwise(offset) + pairwise(offset+1);
    end

    if (i ~= 1)
      pairwise(offset-width) = sum(abs(patchA(i,j,:) - patchB(i,j,:)) + abs(patchA(i-1,j,:) - patchB(i-1,j,:)));
      pairwise(offset) = pairwise(offset) + pairwise(offset-width);
    end
    if (i ~= height)  
      pairwise(offset+width) = sum(abs(patchA(i,j,:) - patchB(i,j,:)) + abs(patchA(i+1,j,:) - patchB(i+1,j,:)));
      pairwise(offset) = pairwise(offset) + pairwise(offset+width);
    end
    cpt = cpt + 1;
  end
end

[labels E Eafter] = GCMex(class, single(unary), pairwise, single(labelcost), 0);
