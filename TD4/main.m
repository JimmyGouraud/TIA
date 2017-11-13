
% Test Seam Carving
filename = 'text1.jpg';
patch_size = 25;
size_imd = [300, 300];

%imd = imageQuilting(filename, patch_size, size_imd);
%figure;imshow(imd);

% Test Graph Cut

pkg load image
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
height = size(tex, 1);
class = zeros(width * height, 1) - 1;
class(1:width:height*width) = 0;
class(width:width:height*width) = 1;

unary = ones(2, width*height);
unary(:, 1:width:height*width) = repmat([inf; 0], 1, height); 
unary(:, width:width:height*width) = repmat([0; inf], 1, height); 

labelcost = [0,1;1,0];

pairwise = sparse(width*height,width*height);
pairwise(:,:) = 0; % useful?
%     c
% e - a - b
%     d

for i=1:height
  for j=1:width
    [i,j]
    if (i == 1 && j == 1)
    
    elseif (i == width && j == height)
    
    else
      offset = i * width + j + (i-1 + j-1) * width*height
      pairwise(offset) = inf;
      pairwise(offset+1) = sum(abs(patchA(i,j,:) - patchB(i,j,:)) + abs(patchA(i,j+1,:) + patchB(i,j+1,:)));
      pairwise(offset-1) = sum(abs(patchA(i,j,:) - patchB(i,j,:)) + abs(patchA(i,j-1,:) + patchB(i,j-1,:)));
      pairwise(offset+width*height) = sum(abs(patchA(i,j,:) - patchB(i,j,:)) + abs(patchA(i,j+width,:) + patchB(i,j+width,:)));
      pairwise(offset-width*height) = sum(abs(patchA(i,j,:) - patchB(i,j,:)) + abs(patchA(i,j-width,:) + patchB(i,j-width,:)));
    end  
  end
end



%
%W = 10;
%H = 5;
%segclass = zeros(50,1);
%pairwise = sparse(50,50);
%unary = zeros(7,25);
%
%% pairwise = cout des arretes => équation 1 paper
%% [X, Y] = overlap A, overlap B
%% labelcost = ?
%% unary = ? ("potentiel initiaux des noeuds") => [inf 0] pour les premiers pixel, [0 inf] pour les autres pixels
%% segclass = ? ("classes initiales du label")
%
%[X Y] = meshgrid(1:7, 1:7);
%labelcost = min(4, (X - Y).*(X - Y));
%
%for row = 0:H-1
%  for col = 0:W-1
%    pixel = 1+ row*W + col;
%    if row+1 < H,  pairwise(pixel, 1+col+(row+1)*W) = 1; end
%    if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = 1; end 
%    if col+1 < W,  pairwise(pixel, 1+(col+1)+row*W) = 1; end
%    if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = 1; end 
%    if pixel < 25
%      unary(:,pixel) = [0 10 10 10 10 10 10]'; 
%    else
%      unary(:,pixel) = [10 10 10 10 0 10 10]'; 
%    end
%  end
%end
%
%[labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);

