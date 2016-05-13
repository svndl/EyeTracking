function conditions = getConditionsList(sessionDir)

    cndList = dir([sessionDir filesep 'cnd*.mat']);
    
    
    conditions = cell(numel(cndList), 1);
    for n = 1:numel(cndList)
       load(fullfile(sessionDir, cndList(n).name), 'conditionInfo'); 
        conditions{n} = [num2str(n) ':' conditionInfo.name ': ' ...
            conditionInfo.dynamics{:} ':' conditionInfo.direction{:}];
    end
end