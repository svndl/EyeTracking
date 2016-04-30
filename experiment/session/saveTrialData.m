function saveTrialData(session, cndInfo, nC, trials)

	if (~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir)
    end
end