function EyelinkMsgStop(stm, trial)
%
% stop recording for trial and inset flag with response info

	msgStr = ['STOPTIME ' stm.condition ' ' stm.dynamics ' ' ...
		stm.directions ' ' num2str(trial)];

    Eyelink('Message', char(msgStr));
    Eyelink('StopRecording');
end