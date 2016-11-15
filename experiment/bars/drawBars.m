%%

function timing = drawBars(lbarFrame, rbarFrame, scr, barUpdate, noniusLines, msg)


%scr = setupVideoMode(samsung);
topPriorityLevel = MaxPriority(scr.wPtr);
Priority(topPriorityLevel);
nframe = size(lbarFrame,3);


waitframes = 0.5;
vbl = scr.vbl;
ifi = scr.ifi;


%prepare texture

% for idx = 1:nframe
%    lbarTexture(idx) = Screen('MakeTexture',scr.wPtr,255*lbar(:,:,idx));
%    rbarTexture(idx) = Screen('MakeTexture',scr.wPtr,255*rbar(:,:,idx));
% end

idxUpdate   = 1;
idxFrame = 1;
trialLoop = tic;

EyelinkMsg(['StartTrial:' msg]);

while idxUpdate <= nframe
    for d = 1:barUpdate
        frameLoop = tic;
        %Left display
        
        Screen('SelectStereoDrawBuffer', scr.wPtr, 0);
        lbarTexture = Screen('MakeTexture',scr.wPtr,255*lbarFrame(:,:,idxUpdate));
        Screen('FillRect', scr.wPtr, scr.background, InsetRect(Screen('Rect', scr.wPtr), -1, -1));
        Screen('DrawTexture',scr.wPtr,lbarTexture);
        
        %% TODO NONIUS LINES
        %             if (noniusLines.enable)
        %                 if (noniusLines.fxDotRadius > 0)
        %                     Screen('FillRect', scrPtr, noniusLines.color, ...
        %                         [xc - noniusLines.fxDotRadius yc + noniusLines.fxDotRadius ...
        %                         xc + noniusLines.fxDotRadius yc + noniusLines.fxDotRadius] );
        %                 end
        %                 Screen('DrawLine', scr.wPtr, nonius.color, xc, ...
        %                     yc + signShift*noniusLines.vertS, ...
        %                     xc, yc + signShift*(nonius.vertH + nonius.vertS), nonius.vertW);
        %             end
        %
        
        
        %Right Display
        
        Screen('SelectStereoDrawBuffer', scr.wPtr, 1);
        rbarTexture = Screen('MakeTexture',scr.wPtr,255*rbarFrame(:,:,idxUpdate));
        Screen('FillRect', scr.wPtr, scr.background, InsetRect(Screen('Rect', scr.wPtr), -1, -1));
        Screen('DrawTexture',scr.wPtr,rbarTexture);
        
        
        %Screen('FillRect', scr.wPtr, [255 0 0], [20 20 200 200] );
        
        
        %flip on screen
        [vbl, onsetTime, flipTimeStamp, missed, ~] = Screen('Flip',scr.wPtr,vbl+(waitframes*ifi));
        timing.VBLTimestamp(idxFrame) = vbl;
        timing.StimulusOnsetTime(idxFrame) = onsetTime;
        timing.FlipTimestamp(idxFrame) = flipTimeStamp;
        timing.Missed(idxFrame)  = missed;
        %timing.Beampos(idxFrame) = beampos;
        timing.Ifi(idxFrame) = toc(frameLoop);
        %Screen('Flip',scr.wPtr)
        
    end
    Screen('Close', lbarTexture);
    Screen('Close', rbarTexture);
    idxUpdate = idxUpdate +1;
    idxFrame = idxFrame + 1;
end
EyelinkMsg(['StopTrial:' msg]);
timing.trialDuration = toc(trialLoop)

Screen('DrawingFinished', scr.wPtr, 0);
Screen('Flip', scr.wPtr);

end







