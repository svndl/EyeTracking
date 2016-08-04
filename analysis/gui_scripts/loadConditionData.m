function dataOut = loadConditionData(S)
    conditionPos = get(S.popCnd, 'val');
    plotProject = 0;
    calledfromProjectGui = 0;
    try
        sessionPos = get(S.popSsn, 'val');
        plotProject = strcmp(S.sessionsList{sessionPos}, 'all');
        calledfromProjectGui = 1;
    catch
        % called from session gui
        
    end
    if (plotProject)
    %load and average all data
        posL = [];
        posR = [];
        velL = [];
        velR = [];
        for s = 1:numel(S.data)
            dataSession = S.data{s};
            dataC = dataSession{conditionPos};
            posL = cat(3, posL, dataC.pos.L);
            posR = cat(3, posR, dataC.pos.R);
            velL = cat(3, velL, dataC.vel.L);
            velR = cat(3, velR, dataC.vel.R);
        end
        dataOut.pos.L = posL;
        dataOut.pos.R = posR;
        dataOut.vel.L = velL;
        dataOut.vel.R = velR;
        dataOut.info = dataSession{conditionPos}.info;
        dataOut.timecourse = dataSession{conditionPos}.timecourse;
    else
        if (calledfromProjectGui)
            dataOut = S.data{sessionPos}{conditionPos};
        else
            dataOut = S.data{conditionPos};
        end
    end
end

