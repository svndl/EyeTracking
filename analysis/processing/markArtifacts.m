function [lValidIdx, rValidIdx] = markArtifacts(data, varargin)

    artifacts = {'blink'};
    if (nargin > 1)
        artifacts = varargin{2};    
    end
        
        
    saccades = {'SSACC', 'ESACC'};
    blinks = {'SBLINK', 'EBLINK'};
    fixations = {'SFIX', 'EFIX'};
    saccL = 0; saccR = 0;
    blinkL = 0; blinkR = 0;
    fixL = 0; fixR = 0;
    
    for al = 1:numel(artifacts)
        switch(artifacts{al})
            case 'sacc'
                saccL = markEyeEvent(saccades, 'L', data);
                saccR = markEyeEvent(saccades, 'R', data);
            case 'blink'
                blinkL = markEyeEvent(blinks, 'L', data);
                blinkR = markEyeEvent(blinks, 'R', data);
            case 'fix'
                fixL = markEyeEvent(fixations, 'L', data);
                fixR = markEyeEvent(fixations, 'R', data);
        end
    end
    lValidIdx = ~(blinkL);
    rValidIdx = ~(blinkR);
end

function hasEvent = markEyeEvent(event, eye, data)
    hasEvent = zeros(numel(data), 1);
    event_start = find(~cellfun(@isempty, strfind(data, [event{1} ' ' eye])));
    event_end = find(~cellfun(@isempty, strfind(data, [event{2} ' ' eye])));
    
    for e = 1:numel(event_start)
        hasEvent(event_start(e):event_end(e)) = 1;
    end
end