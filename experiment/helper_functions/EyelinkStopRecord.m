function EyelinkStopRecord(condition,dynamics,direction,trial)
%
% stop recording for trial and inset flag with response info

    Eyelink('Message', ['STOPTIME ' condition ' ' dynamics ' ' direction ' ' num2str(trial)]);
    Eyelink('StopRecording');
end