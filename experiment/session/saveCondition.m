function saveCondition(sessionInfo, conditionInfo, nC, trials)
	try
        saveStr = ['cnd' num2str(nC)];
        m = matfile(fullfile(sessionInfo.saveDir, saveStr), 'Writable', true);
        m.trials = trials;
        m.conditionInfo = conditionInfo;
    catch err
		display(['Could not save the session in requested folder, saving here as ' saveStr]);
        display(err.message);
        display(err.stack(1).file);
        display(err.stack(1).line);        
		save([saveStr '.mat'], 'conditionInfo', 'trials');
	end
end