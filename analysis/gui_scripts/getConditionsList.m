function myConditions = getConditionsList(sessionDir)
    
    
    load([sessionDir filesep 'sessionInfo.mat']);
    
    
    myConditions = cell(numel(sessionInfo.conditions), 1);
    for n = 1:numel(sessionInfo.conditions)
        myConditions{n} = [num2str(n) ':' sessionInfo.conditions{n}.info.name ': ' ...
            sessionInfo.conditions{n}.info.dynamics{:} ':' sessionInfo.conditions{n}.info.direction{:}];
    end
end