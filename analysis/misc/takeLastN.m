function out = takeLastN(mat, N)
    nElems = size(mat, 1);
    out = mat(nElems - N + 1:end, :, :);
end