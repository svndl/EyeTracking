function varargout = exampleMixedCondition(varargin)
% define dots AND conditions for your experiment here
% TWO options for generating dot structure(s):
% Option #1, define in file, load with eval("myDotParams") 
% Option #2, define in structure here

%% dotStructure example (no multiple fields)
% can define multiple dots structires with same/different conditions

% dots.stimRadDeg      stimulus field radius
% dots.dispArcmin      disparity magnitude
% dots.rampSpeedDegSec ramp speed in degrees per second
% dots.dotSizeDeg      diameter of each dot
% dots.dotDensity      dots per degree2
% dots.dotUpdateHz = 60 dot update params

% timing
% dots.preludeSec      delay before motion onset
% dots.cycleSec        duration of stimulus after prelude in dot cycles 
 
%% Cues (no multiple fields)
 
% condition.cues = 'SingleDot'                 
% condition.dynamics = {{'step', 'ramp'}} or {{'step'}} or {{'ramp'}}
% condition.direction = {{'left', 'right'}};
% condition.isPeriodic = 0;
% condition.trialRepeats = 5;

%% merging things together

% define your stimset from multiple dot structures and conditions

% stimset{1} = catstruct(dots_1, condition_1) ..
% stimset{n} = catstruct(dots_n, condition_m) ..

% creating dot frames for one eye 
% dotFrames{k}.L = createDotFrames(stimset{k}, videoMode, 'L');
% dotFrames{k}.R = createDotFrames(stimset{k}, videoMode, 'R');
% a note on creating the frames and manipulating the color

%% NEXT step is to define the presentation color for each dot frame for each eye 
% dotColor{k}.L = [r_kl g_kl b_kl]
% dotColor{k}.R = [r_kr g_kr b_kr]
%% Last step is to define the dot size for each eye

% dotSize{k}.L = stimset.dotSizePix or scaled
% dotSize{k}.R = stimset.dotSizePix op scaled


%% WARNING: it is YOUR responsibility to ensure that all dotFrames have
% the same number of elements! Zero-pad or repmat whenever you have different sizes!

% dotFrames{k}.{L, R}{x, y} <-> dotColor{k}.{L, R} <-> dotSize{k}.{L, R}


%% Example: create salt & pepper IOVD stimset
	
    dots.stimRadDeg = 10;     
    dots.dispArcmin = 240;     
    dots.rampSpeedDegSec = 1; 
    dots.dotSizeDeg = 0.25;     
    dots.dotDensity = 2;      
    dots.dotUpdateHz = 60;
    %timing
    dots.preludeSec = 0.25;   
    dots.cycleSec = 2;        
            
    %condition is the same    
    condition_IOVD.cues = 'IOVD';                 
    condition_IOVD.dynamics = {'ramp'};
    condition_IOVD.direction = {'right'};
    condition_IOVD.isPeriodic = 0;
    condition_IOVD.nTrials = 5;
    
    
    if (~nargin)
        varargout = {condition_IOVD};
    else
        videoMode = varargin{1};
        stimset = catstruct(dots, condition_IOVD);
        dotParams = calcStimsetParams(stimset, videoMode);
    
        % pepper 
        dotFrames{1} = feval(stimset.cues, dotParams);

        dotColor{1}.L = videoMode.lblack;
        dotColor{1}.R = videoMode.rblack;

        dotSize{1}.L = dotParams.dotSizePix;
        dotSize{1}.R = dotParams.dotSizePix;
    
        %salt    
        dotFrames{2} = feval(dotParams.cues, dotParams);
        dotColor{2}.L = videoMode.lwhite;
        dotSize{2}.L = 2*dotParams.dotSizePix;
    
        dotColor{2}.R = videoMode.rwhite;
        dotSize{2}.R = 2*dotParams.dotSizePix;
        varargout = {dotFrames, dotColor, dotSize};
    end
end




 