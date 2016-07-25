function saveSession(sessionInfo)
	try
%         if (sessionInfo.recording) 
% 			%transfer eyelink file and save
%             fileName = [sessionInfo.subj.name '_cnd' num2str(nC)];
% 			EyelinkTransferFile(sessionInfo.saveDir, fileName);
%         end
        saveStr = 'sessionInfo.mat';
        save(fullfile(sessionInfo.saveDir, saveStr), 'sessionInfo');
    catch err
        display(err.message);
        display(err.stack(1).file);
        display(err.stack(1).line);        
		save(saveStr, 'sessionInfo');
	end
end