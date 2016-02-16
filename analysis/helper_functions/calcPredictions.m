function pred = calcPredictions(stimSetting, elInfo)


    samples = elInfo.sampleRate/stimSetting.dotUpdateHz;

    for d = 1:length(stimSetting.dynamics)            
        pred.(stimSetting.dynamics{d}) = (1/60)*...
                resample(stimSetting.stim_info.dynamics.(stimSetting.dynamics{d}), elInfo.sampleRate, stimSetting.dotUpdateHz, 0);
    end
end


