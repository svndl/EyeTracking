function saveCondition(sessionInfo, conditionInfo, scr, nC, trials)
	conditionInfo.display = scr;
	try
%         if (sessionInfo.recording) 
% 			%transfer eyelink file and save
%             fileName = [sessionInfo.subj.name '_cnd' num2str(nC)];
% 			EyelinkTransferFile(sessionInfo.saveDir, fileName);
%         end
        saveStr = ['cnd' num2str(nC) 't1-' num2str(conditionInfo.nTrials) '.mat'];
        save(fullfile(sessionInfo.saveDir, saveStr), 'conditionInfo', 'trials');
    catch err
		display(['Could not save the session in requested folder, saving here as ' saveStr]);
        display(err.message);
        display(err.stack(1).file);
        display(err.stack(1).line);        
		save([saveStr '.mat'], 'conditionInfo', 'trials');
	end
end