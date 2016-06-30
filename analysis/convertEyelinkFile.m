function convertEyelinkFile(filePath, fileName, flags)
% function converts eyelink edf file to asc file by caling edf2asc bin
% and moves the original file into /raw subdirectory

% arguments:

% filePath: path to directory with the file
% fileName: file name
% flags: extra flags for edf2asc

% Example: convertEyelinkFile(exampleDir, exampleFile, '-convert flag')
% will run command 'edf2asc -convert flag exampleDir/exampleFile'
% converted data will be saved in exampleDir/exampleFile.asc
% original data will be moved to exampleDir/raw/exampleFile



    convert2asc(fullfile(filePath, fileName), flags);
    archive(filePath, fileName);    
end

function convert2asc(filepath, flags)
    command = ['edf2asc -sh ' flags ' ' filepath];
	[~, ~] = system(command);
end

function archive(filepath, filename)

    dirRaw = fullfile(filepath, 'raw');
    if (~exist(dirRaw, 'dir'))
        mkdir(dirRaw);
    end
    
    command = ['mv ' [filepath filesep filename] ' ' [dirRaw filesep filename]];
	[~, ~] = system(command);   
end