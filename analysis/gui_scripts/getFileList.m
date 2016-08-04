function listFiles = getFileList(dirSrc, varargin)
% function will return list of files within dirSrc 
% varargin options:
% varargin{1} -- file extension
% varargin{2} -- part of filename

    ext = [];
    substr = [];
    if (nargin > 1)
        ext = varargin{1};
    end
    if (nargin > 2)
        substr = varargin{2};
    end
    
    files = dir([dirSrc filesep '*' substr '*.' ext]);
    listFiles = {files.name};
end

