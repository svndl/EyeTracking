function dataOut = startAtZero(dataIn)
    dataOut = dataIn - repmat(dataIn(1, :, :), [size(dataIn, 1) 1 1]);
end