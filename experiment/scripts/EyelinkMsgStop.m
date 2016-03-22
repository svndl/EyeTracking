function EyelinkStopRecord(stm, trial)
%
% stop recording for trial and inset flag with response info

    Eyelink('Message', ['STOPTIME ' stm.condition ' ' stm.dynamics ' ' stm.direction ' ' num2str(trial)]);
    Eyelink('StopRecording');
end