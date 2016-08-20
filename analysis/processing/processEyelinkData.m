function trials = processEyelinkData(eyelinkData, varargin)
% function parses contents of *.asc eyelink file 
% input arguments
% eyelinkData: cell matrix with raw data
% if no extra arguments provide, default start/stop trial markers will be 
% used


% optional arguments
% varargin{1} data column in eyelinkData that has trial start markers (default = 1)
% varargin{2} data column in eyelinkData that has trial stop markers (default = 1)
% varargin{3} string for trial start marker (default = 'START')
% varargin{4} string for trial stop marker (default = 'END')

%exaple: processEyelinkFile(eyelinkData, 2, 2, 'StartTrial', 'StopTrial')

    %% default values
    startCol = 1;
    endCol = 1;
    strSearchStart = 'START';
    strSearchEnd = 'END';

    % fist data sample is 7 lines after the start marker: 
    % {START(1), PRESCALER(2), VPRESCALER(3), PUPIL(4), EVENTS(5), SAMPLES(6), INPUT(7), (8)..data..} 
    deltaStart = 7;
    
    %last data sample is one line before the stop marker
    deltaStop = -1;
    useIntersection = 0;
    %% custom start/stop markers 
    if (~isempty(varargin{1}))
        startCol = varargin{1}{1};        
        endCol = varargin{1}{2};
        strSearchStart = varargin{1}{3};
        strSearchEnd = varargin{1}{4};
        if (size(varargin{1}, 2) > 4)
            useIntersection = 1;
            strSearchStart_1 =  varargin{1}{5};
            strSearchEnd_1 = varargin{1}{6};
        end
            
        deltaStart = 1;
    end
    
    %% find all trial start/stop indices
    starts  = find(~cellfun(@isempty, strfind(eyelinkData(:, startCol), strSearchStart)));   
    stops   = find(~cellfun(@isempty, strfind(eyelinkData(:, endCol), strSearchEnd)));                                  
    
    %% look for strSearchStart/strSearchStop and extra argument ('left + right')
    if (useIntersection)
        starts = intersect(starts, ...
            find(~cellfun(@isempty, strfind(eyelinkData(:, startCol), strSearchStart_1))));
        stops = intersect(stops, ...
            find(~cellfun(@isempty, strfind(eyelinkData(:, endCol), strSearchEnd_1))));   
    end
    
    dataStarts = starts + deltaStart;
    dataStops = stops + deltaStop;
   
    %% convert data from str to num and break it into trials
    trials = cell(numel(starts), 1);
    nCols = size(eyelinkData, 2);
    
    % Mark fixations and saccades for l/r eyes
    % event start is in 1st column, event end in 2nd col,
    % event duration in 3rd col;
    [validLeft, validRight] = markArtifacts(eyelinkData(:, 1:2));
    
    lVars = [2, 3, 6, 7];
    rVars = [4, 5, 8, 9];
    
    for s = 1:length(starts)
        try
            %
            trialData = eyelinkData(dataStarts(s):dataStops(s), :);  
            % find out indices of saccades and fixation   
            %dataEvents = '[A-Z]';
            %timeSamples = trialData(:, 1);
            %validIDX = cellfun(@isempty, regexp(timeSamples, dataEvents));

            % process sample quality            
            qualSamples = trialData(:, nCols);
            lOK = ismember(qualSamples, '.....') & ...
                boolean(validLeft(dataStarts(s):dataStops(s)));
            rOK = ismember(qualSamples, '.....') & ...
                boolean(validRight(dataStarts(s):dataStops(s)));
                  
            data = zeros(size(trialData));
            data(1:end, 1) = 1:size(trialData, 1);
            % process numeric samples for left and right eyes
            for x = 2:nCols - 1             
                idxOK = lOK* sum(lVars == x ) + rOK* sum(rVars == x );
                data(:, x) = str2num_Nan(trialData(:, x), idxOK);
            end
            goodTrials = data; 
        catch err
            display(['processEyelinkFile Error trial #'  num2str(s)...
                ' caused by:']);
            display(err.message);
            display(err.stack(1).file);
            display(err.stack(1).line);                       
            % keep whatever we have parsed so far
            goodTrials = data;
        end
        trials{s} = goodTrials;
    end
end

function numArray = str2num_Nan(cellArray, idxOK)
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
    % replace large values
    numArray(numArray>1e+04) = NaN;
    numArray(~idxOK) = NaN;
end