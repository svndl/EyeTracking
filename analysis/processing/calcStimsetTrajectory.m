function pos = calcStimsetTrajectory(stimsetInfo)
% Function will calculate the trajectory of stimset
% Input args:
% stimsetInfo -- structure with stimset parameters
% Output arguments:
% pos -- structure with left and right stimulus trajectories
%  pos.l, pos.r are vectors, identical for 2D motion, different for 3D
%  motion
% vel -- structure with left and right stimulus velocity
%  vel.l, vel.r are vectors, identical for 2D motion, different for 3D
%  motion
    waitSec = 0;
    % number of points for prelude/motion
    if (isfield(stimsetInfo, 'waitAfterPrelude'))
        waitSec = stimsetInfo.waitAfterPrelude;
    end
    preludeSamples = uint32(1e+03*(stimsetInfo.preludeSec + waitSec));
    motionSamples = uint32(1e+03*stimsetInfo.cycleSec); 

    % pre-allocate vectors for trajectory
    prelude = zeros(1, preludeSamples);

    %step or ramp 
    isStep = sum(ismember(stimsetInfo.dynamics, 'step'));
    isRamp = sum(ismember(stimsetInfo.dynamics, 'ramp'));
    
    %pre-calculate ramp motion (simple linspace)
    ramp = linspace(0, stimsetInfo.cycleSec*stimsetInfo.rampSpeedDegSec, ...
        motionSamples);
    
    %pre-calculate the step motion
    %convert to degrees (divide by 60) 
    step = repmat(stimsetInfo.dispArcmin/60, [1 motionSamples]); 
        
    % check if direction is the same or opposite
    sameDirection = 1;
    
    where = stimsetInfo.direction;
    
    if (numel(unique(where)) == 2 && numel(where)== 2)
        sameDirection = -1;
    end 
    
    % Find out signs for directions in left and right eyes 
    signL = directionSigns(where{1}, 'L');
    signR = directionSigns(where{1}, 'R');
     
    %left eye motion
    motionL = signL*(isStep*step + isRamp*sameDirection*ramp);
    
    %right eye: same as left eye if motion is 2D, mirror-flipped if motion
    % is 3d
    motionR =  signR*(isStep*step + isRamp*sameDirection*ramp);
    
    %
    if (strcmp(where{1}, 'up') || strcmp(where{1}, 'down'));
        yL = [prelude motionL];
        yR = [prelude motionR];

        xL = zeros(size(yL));
        xR = zeros(size(yR));        
    else
        xL = [prelude motionL];
        xR = [prelude motionR];

        yL = zeros(size(xL));
        yR = zeros(size(xR));
    end
        
    pos.l.x = xL';
    pos.r.x = xR';
    
    pos.l.y = yL';
    pos.r.y = yR';
end

