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

    % number of points for prelude/motion
    preludeSamples = uint8(1e+03*stimsetInfo.preludeSec);
    motionSamples = uint8(1e+03*stimsetInfo.cycleSec); 

    % pre-allocate vectors for trajectory
    prelude = zeros(preludeSamples, 1);

    %step or ramp 
    isStep = sum(ismember(stimsetInfo.dynamics, 'step'));
    isRamp = sum(ismember(stimsetInfo.dynamics, 'ramp'));
    
    %pre-calculate ramp motion (simple linspace)
    ramp = linspace(0, stimsetInfo.rampSpeedDeg, motionSamples);
    
    %pre-calculate the step motion
    %convert to degrees (divide by 60) and divide by 2 for each eye 
    %(each eye gets 1/2 of the disparity)   
    step = repmat(stimsetInfo.dispArcmin/120, [motionSamples 1]); 
    
    % next step is to figure out if we need to calculated 3D or 2D motion
    % we'll use first element of stimsetInfo.direction
    
    is3dMotion = ismember(stimsetInfo.direction{1}, 'towards') + ...
        ismember(stimsetInfo.direction{1}, 'away');
    
    % check if direction is the same or opposite
    sameDirection = 1;
    
    if (numel(unique(stimsetInfo.direction)) == 2 && numel(stimsetInfo.direction )== 2)
        sameDirection = -1;
    end 
    
    % Find out signs for directions in left and right eyes 
    signL = directionSigns(stimsetInfo.direction{1}, 'L');
    signR = directionSigns(stimsetInfo.direction{1}, 'R');
     
    %left eye motion
    motionL = isStep*step*signL + isRamp*sameDirection*ramp;
    
    %right eye: same as left eye if motion is 2D, mirror-flipped if motion
    % is 3d
    motionR = 
    
    %
    pos.l = [prelude motionL];
    pos.r = [prelude motionR];
end

