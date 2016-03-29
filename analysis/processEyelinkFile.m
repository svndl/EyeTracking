function trials = processEyelinkFile(pathToFile, elInfo)


    eld     = loadEyelinkFile(pathToFile); 
     % find all trial start/stop flags
    starts  = find(~cellfun(@isempty,strfind(eld.f2,'STARTTIME')));                                
    stops   = find(~cellfun(@isempty,strfind(eld.f2,'STOPTIME')));                                  
    
     % eld structure fields to use; fields 1-4 are data, 5-6 are meta
    fields  = {'f2', 'f3', 'f5', 'f6', 'f1', 'f8'};                                                    
    vals    = {'LEx', 'LEy', 'REx', 'REy', 'meta', 'qual'};                                              

    for s = 1:length(starts)
    
        % parse startline into trial info
        [condition, dynamics, direction, trialnum] = eyelink_parse_startline(eld.f2(starts(s)));       
    
        for x = 1:length(fields)
            data{x} = eld.(fields{x})( starts(s) + 1:stops(s) - 1);
        end
    
        % indices to keep
        Datalines = ~isnan(str2double(data{5}));
    
        GoodQuallines   = strcmp(data{6},'.....') & ~strcmp(data{1},'.') & ~strcmp(data{2},'.') & ~strcmp(data{3},'.') & ~strcmp(data{4},'.');
    
        isGood = 1;
    
        for d = 1:4
        
            data_clean{d} = data{d};                                                % copy data in array for cleaning
            data_clean{d}(~GoodQuallines) = {'1e100'};                              % replace NaNs with very small value
            data_clean{d} = data_clean{d}(Datalines);                               % remove indices that a meta lines
            data_clean{d} = data_clean{d}...                                        % omit a few extra measurements
                (1:round(el.sampleRate*(res.preludeSec(f)+res.cycleSec(f)))+1);
        
            %data_nums = cellfun(@str2double,data_clean{d});                            % convert data to numbers
            data_nums = sscanf(sprintf('%s ',data_clean{d}{:}),'%f');
        
            data_nums(data_nums == 1e100) = NaN;                                    % replace bad values with NaNs
        
            trials.data(tcnt) = data_nums;                               % store cleaned eye position href data

            if sum(isnan(data_nums)) > 0                                            % flag this trial is there's bad data
                isGood = 0;
            end
        end
    
        trials.condition        = cell2mat(condition);
        trials.dynamics         = cell2mat(dynamics);
        trials.direction        = cell2mat(direction);
        trials.trialnum(tcnt)   = trialnum;
        trials.isGood(tcnt)     = isGood;
    
        % duration of recording for this trial    
        trials.recordingDurationSec(tcnt) = length(data{1}(Datalines))./elInfo.sampleRate;  
        % timepoints of recording for this trial        
        trials.recordingTimePointsSec(tcnt) = (0:1)/(elInfo.sampleRate:(res.preludeSec(f) + res.cycleSec(f)));  
        
        tcnt = tcnt + 1;
    end
end


function parseEyelinkMsg(startLine)
    [~,startline] = strtok(startline,' ');
    [~,startline] = strtok(startline,' ');

    [condition,startline] = strtok(startline,' ');
    [dynamics,startline] = strtok(startline,' ');
    [direction,trialnum] = strtok(startline,' ');
    trialnum = str2num(cell2mat(trialnum));
end
