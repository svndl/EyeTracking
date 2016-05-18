function trials = processEyelinkFile(pathToFile)
    % Parses *.asc eyelink trial

    eyelinkData = loadEyelinkFile(pathToFile); 
     % find all trial start/stop flags
    starts  = find(~cellfun(@isempty, strfind(eyelinkData.f1, 'START')));                                
    stops   = find(~cellfun(@isempty, strfind(eyelinkData.f1, 'END')));                                  
    
    % 6 lines after the start: 
    % {START(1), PRESCALER(2), VPRESCALER(3), PUPIL(4), EVENTS(5), SAMPLES(6), INPUT(7), (8)..data..} 
    
    dataStarts = starts + 6 + 1;
    dataStops = stops - 1;
    
    % eld structure fields to use
    fields = {'f1', 'f2', 'f3', 'f5', 'f6', 'f1', 'f8'};                                                    
    
    % we'll keep HREF position only 
    vals = {'time', 'Lx', 'Ly', 'Rx', 'Ry'};                                                  
    
    trials = cell(numel(starts), 1);
 
    for s = 1:length(starts)
    
        try
            % exclude saccades and fixation   
            dataEvents = '[A-Z]';
            timeSamples = eyelinkData.(fields{1})( dataStarts(s):dataStops(s));
            validIDX = cellfun(@isempty, regexp(timeSamples, dataEvents));
    
            data = zeros(sum(validIDX), numel(vals));
            data(:, 1) = cellfun(@str2double, timeSamples(validIDX));    
    
            % parse startline into trial info
            for x = 2:length(vals)            
                samples = eyelinkData.(fields{x})(dataStarts(s):dataStops(s));
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