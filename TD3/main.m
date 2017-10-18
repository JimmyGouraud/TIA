
% Test Simple
% filenameA = 'frodonA.png';
% filenameB = 'frodonB.png';
% filenameC = 'frodonC.png';
% patch_hs = 1;
% nb_iter = 4;
% patchMatching(nb_iter, patch_hs, filenameA, filenameB, filenameC);

% Test Complet
filename = {'frodonA.png', 'frodonB.png', 'frodonC.png';
             'grootA.png',  'grootB.png',  'grootC.png'};
for i=1:size(filename,1)
    for patch_hs = 1:4
        patchMatching(nb_iter, patch_hs, filename{i,1}, filename{i,2}, filename{i,3});
    end
end