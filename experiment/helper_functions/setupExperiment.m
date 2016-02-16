function [myExp, myScr, myStm] = setupExperiment(myExp, myScr)
%

    if ~strcmp(cell2mat(myExp.conditions),'SingleDot')                                % if there are multidot conditions included...      
        myScr.calicolor = [52 52 52];                                                 % make the calibration screen a little brighter
    else
        myScr.calicolor = [0 0 0];
    end


    %  STIMULUS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    myExp.dotUpdateHz     = 60;        % dot update rate
    myExp.numCycles       = 1;         % total cycles, more than 1 for periodic stim

    myStm.wlevel          = 255;       % white
    myStm.glevel          = 0;         % gray
    myStm.blevel          = 0;         % black

    switch myScr.name
    
        case {'planar','laptopRB','LG3DRB'}       % planar uses blue-left, red-right
        
            myStm.LEwhite = [myStm.glevel myStm.glevel myStm.wlevel];
            myStm.LEblack = [myStm.glevel myStm.glevel myStm.blevel];
        
            myStm.REwhite = [myStm.wlevel myStm.glevel myStm.glevel];
            myStm.REblack = [myStm.blevel myStm.glevel myStm.glevel];
    
        case 'CinemaDisplayRB'                                      % blue-right, red-left like anaglyph glasses in lab
        
            myStm.LEwhite = [myStm.wlevel myStm.glevel myStm.glevel];
            myStm.LEblack = [myStm.blevel myStm.glevel myStm.glevel];
        
            myStm.REwhite = [myStm.glevel myStm.glevel myStm.wlevel];
            myStm.REblack = [myStm.glevel myStm.glevel myStm.blevel];
        
        otherwise                                                   % other displays just use white/black
        
            myStm.LEwhite = [myStm.wlevel myStm.wlevel myStm.wlevel];
            myStm.LEblack = [myStm.blevel myStm.blevel myStm.blevel];
        
            myStm.REwhite = [myStm.wlevel myStm.wlevel myStm.wlevel];
            myStm.REblack = [myStm.blevel myStm.blevel myStm.blevel];
        
    end

    myStm.dispPix         = myExp.dispArcmin/myScr.pix2arcmin;            % step full disparity in pixels
    myStm.rampEndDispDeg  = 2*(myExp.rampSpeedDegSec*myExp.cycleSec);     % end full disparity of ramp in degrees relative to start position
    myStm.rampEndDispPix  = (60*myStm.rampEndDispDeg)/myScr.pix2arcmin;   % end full disparity of ramp in pixels relative to start position

    myStm.stimRadPix      = round((60*myExp.stimRadDeg)/myScr.pix2arcmin);    % dot field radius in pixels
    myStm.stimRadSqPix    = myStm.stimRadPix^2;                             % square it now to save time later
    myStm.dotSizePix      = (myExp.dotSizeDeg*60)/myScr.pix2arcmin;           % dot diameter in pixels

    myStm.xmax            = 4*myStm.stimRadPix;                             % full x field of dots before circle crop
    myStm.ymax            = 4*myStm.stimRadPix;                             % fill y field of dots before circle crop

    myStm.numDots         = round( myExp.dotDensity*(  myStm.xmax*(myScr.pix2arcmin/60) * ...  % convert dot density to number of dots for PTB
        myStm.ymax*(myScr.pix2arcmin/60) ) );


    %  TIMING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % note: dot drawing is done frame-by-frame rather than using PTB WaitSecs,
    % this seems to provide better precision, although time is still not
    % perfect (a few frames tend to be dropped)

    myStm.dotUpdateSec   = 1/myExp.dotUpdateHz;                                % duration to hold dots on screen
    myStm.dotRepeats	 = round(myScr.frameRate/myExp.dotUpdateHz);             % number of frames to hold dots on screen
    myExp.dotUpdateHz    = myScr.frameRate/myStm.dotRepeats;                     % true dot update rate is even multiple of frame rate
    myStm.numUpdates     = round(myExp.dotUpdateHz*myExp.cycleSec);              % number of times the stimulus is updated in a rap cycle
    myStm.preludeUpdates = round(myExp.dotUpdateHz*myExp.preludeSec);            % number of times the stimulus is updated in a preclue

    myStm.dynamics.step       = [ zeros(1,myStm.preludeUpdates) repmat(myStm.dispPix,1,myStm.numUpdates)];   % set up step disparity updates
    myStm.dynamics.ramp       = [ zeros(1,myStm.preludeUpdates) linspace(myStm.rampEndDispPix/myStm.numUpdates,myStm.rampEndDispPix,myStm.numUpdates)];       % set up ramp disparity updates
    myStm.dynamics.stepramp   = [ zeros(1,myStm.preludeUpdates) myStm.dispPix - linspace(0,myStm.rampEndDispPix - (myStm.rampEndDispPix/myStm.numUpdates),myStm.numUpdates)];


    % cycle through conditions and make sure they don't exceed calibration area
    isTooBigForRamp = 0;
    isTooBigForStep = 0;
    isTooBigForStepRamp = 0;

    for d = 1:length(myExp.dynamics)
        switch myExp.dynamics{d}
            case 'ramp'			
                isTooBigForRamp = max(myStm.dynamics.ramp/2) > myScr.caliRadiusPixX;			
            case 'step'			
                isTooBigForStep = max(myStm.dynamics.step/2) > myScr.caliRadiusPixX;
            case 'stepramp'
                isTooBigForStepRamp = max(myStm.dynamics.stepramp/2) > myScr.caliRadiusPixX;
        end	
    end

    if(isTooBigForRamp || isTooBigForStep || isTooBigForStepRamp)
        error('need to increase calibration area in order to run this condition');
    end

    %SOUND
    myStm.sound = setupSound;
    
    %FIXATION
    myStm.fixation = setupFixation(myScr);

%  TRIAL STRUCTURE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    myExp.trials.condition        = {};
    myExp.trials.dynamics         = {};
    myExp.trials.direction        = {};
    myExp.trials.repeat           = [];

    for c = 1:length(myExp.conditions)
        for d = 1:length(myExp.dynamics)     
            for n = 1:length(myExp.directions)
                for r = 1:myExp.cond_repeats
                    myExp.trials.condition    = [myExp.trials.condition ; myExp.conditions{c}];
                    myExp.trials.dynamics     = [myExp.trials.dynamics ; myExp.dynamics{d}];
                    myExp.trials.direction    = [myExp.trials.direction ; myExp.directions{n}];
                    myExp.trials.repeat       = [myExp.trials.repeat ; r];
                end
            end
        end
    end

    % randomize trial order
    myExp.trials.trialnum = randperm(length(myExp.trials.condition));

    % emptry response arrays
    myExp.trials.resp         = cell(1,length(myExp.trials.condition));
    myExp.trials.respCode     = NaN*ones(1,length(myExp.trials.condition));
    myExp.trials.isCorrect    = NaN*ones(1,length(myExp.trials.condition));

    % generate random delay period for each trial
    myExp.trials.delayTimeSec = randi([250 750],1,length(myExp.trials.condition))./1000;
    myExp.trials.delayUpdates = round(myExp.dotUpdateHz*myExp.trials.delayTimeSec);

    %dat.trials.mat = [dat.trials.trialnum' dat.trials.condition dat.trials.dynamics dat.trials.repeat dat.trials.direction];
    