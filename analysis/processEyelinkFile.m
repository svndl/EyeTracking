function trials = processEyelinkFile(pathToFile, varargin)

    % Parses *.asc eyelink trial
    if (nargin > 1)
        startCol = varargin{1};
        endCol = varargin{2};
        strSearchStart = varargin{3};
        strSearchEnd = varargin{4};
        deltaStart = 1;
        deltaStop = -1;
        %exaple usage: processEyelinkFile(pathToFile, ...
        % 2(data column 2 to search for trial starts), ...
        % 2(data column to search for trial ends), ...
        % 'StartTrial' (MSG start trial), ...
        % 'StopTrial' (MSG stop trial))
    else
        startCol = 1;
        endCol = 1;
        strSearchStart = 'START';
        strSearchEnd = 'END';
        % 6 lines after the start: 
        % {START(1), PRESCALER(2), VPRESCALER(3), PUPIL(4), EVENTS(5), SAMPLES(6), INPUT(7), (8)..data..} 
        deltaStart = 7;
        deltaStop = -1;
    end
    
    startIdx = 1;
    endIdx = inf;
    
    eyelinkData = loadEyelinkFile(pathToFile, startIdx, endIdx);
    
    % find all trial start/stop flags
    starts  = find(~cellfun(@isempty, strfind(eyelinkData(:, startCol), strSearchStart)));                                
    stops   = find(~cellfun(@isempty, strfind(eyelinkData(:, endCol), strSearchEnd)));                                  
    
    
    dataStarts = starts + deltaStart;
    dataStops = stops + deltaStop;
    
    
    % we'll keep HREF position only 
    vals = {'time', 'Lx', 'Ly', 'Rx', 'Ry'};                                                  
    
    trials = cell(numel(starts), 1);
 
    for s = 1:length(starts)
    
        try
            % exclude saccades and fixation   
            dataEvents = '[A-Z]';
            timeSamples = eyelinkData(dataStarts(s):dataStops(s), 1);
            validIDX = cellfun(@isempty, regexp(timeSamples, dataEvents));
    
            data = zeros(sum(validIDX), numel(vals));
            data(:, 1) = cellfun(@str2double, timeSamples(validIDX));    
    
            % parse startline into trial info
            for x = 2:length(vals)            
                samples = eyelinkData(dataStarts(s):dataStops(s), x);
                %replace '.' with NaN
                data(:, x) = str2num_Nan(samples(validIDX));
                %data(:, x) = cellfun(@str2num, samples(validIDX));
            end
        
            %qualSamples = eyelinkData.(fields{end})( dataStarts(s):dataStops(s));       
            %qualIdx = ismember(qualSamples(validIDX), '.....');        
            %goodTrials = data(qualIdx, :);
            goodTrials = data; 
            goodTrials(goodTrials == 1e100) = NaN;
        catch err
            display(['processEyelinkFile Error trial #'  num2str(s)  ' file ' ...
                pathToFile ' caused by:']);
            display(err.message);
            display(err.stack(1).file);
            display(err.stack(1).line);
                        
            % keep whatever we have parsed so far
            goodTrials = data;
        end
        trials{s}.data = goodTrials;
        trials{s}.headers = vals; 
    end
end

function numArray = str2num_Nan(cellArray)
    nElems = numel(cellArray);
    numArray = NaN*ones(size(cellArray));
    
    for k = 1:nElems
       elem = cellArray{k};
       try
           numArray(k) = str2double(elem);
       catch
           %leave the NaN out
       end
    end
end