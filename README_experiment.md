## This is a readme file describing the structure and functionality for running and analyzing Eyetracking experiments.

# Data organization

* *analysis* -- scripts for loading and processing trial data
* *experiment* -- scripts for running the experiment
* *data* -- folder to store the recorded data.

# Experiment folder organization and quick manual

* `conditions` folder contains scripts that generate dot display parameters (dot coordinates, dot size, dot color) 
* `conditions/cues` subfolder contains predefined dot motion patterns, such as IOVD, FullCue, CDOT, etc.
* `displays` folder contains the scripts that set up, initiate and run the visual part of the experiment.
* `displays/data` subfolder contains scripts defining the visual systems . 
* `dots` folder contains scripts to generate dot motion patterns.  
* `dots/data` stores some pre-defined dot properties. 
* `eyelink` folder has the scripts for communicating with the Eyelink. 
* `scripts` a collection of misc scripts.
* `session` scripts to init and run the session.
* `stimsets` folder with stimulus sets.

We'll break down the contents of `runSession.m` script to demonstrate how to create and run an experiment.
 
Fill in subject info. 
```
  subject.name = 'AY';
  subject.ipd = 6.5;    
    
    
  % Folder where you'll be saving the experiment data:
  % data/myStimset/subjName_date/
    
  myStimset = 'TowardsAwayAllCues';
```

Next, define the display info.
  
```
  displayName = 'LG_OLED_TB';
```
Matfile with display settings should be located in `/experiment/displays/data/LG_OLED_TB.m`.

Next, setup the session. Create directory to save the session data,  setup keyboard (PTB), setup video mode (PTB).
```
  [mySession, myScr] = setupSession(displayName, subject, myStimset);
```
Structure `mySession` at this point stores the KB info, subject info and save directory path.
Structure `myScr` stores the video system info(resolution, frequency), color mode, 3D mode, fixation window properties and calibration window properties and active link to the current video buffer.
```
  %% Inint session
  if (useEyelink)
    if (~initSession(mySession, myScr))
      useEyelink = 0;
    end
  end
```
Initialize the Eyelink, set up calibration window properties.
```
  conditions = myStimset(myScr);
```
Initialize your stimset with display settings. Here, stimset is defined in `TowardsAwayAllCues.m`.
A *stimset* is a cell array of unique condition structures. Each *condition* structure has three fields:
```
  condition.fhandle : function handle that will return dotFrames, dotColor and dotSize
  condition.fparams: arguments to function handle
    
  condition.info: stim info with the following fields:
  condition.info.nTrilas - # of repeats
  condition.info.cues
  condition.info.dynamic
  condition.info.direction
  condition.info.dotSize, etc ...
```
Example from `TowardsAwayAllCues.m` file defining the FullCue condition:
```
  fc = eval('FullCue_dots');
```
Structure `fc` contains dot params described in  `dots/data/FullCue_dots.m`.
```  
  fc.handle = 'mixedDotFrames';
  
  stimset{c}.fhandle = fc.handle.handle;
  stimset{c}.fparams = {fc, videoMode};
  stimset{c}.info = fc;
```
Function `mixedDotFrames.m` will be used to generate dot positions
```
  function [dotFrames, dotColor, dotSize] = mixedDotFrames(dotParams, videoMode)
```
Each condition handle function *MUST* return three parameters `[dotFrames, dotColor, dotSize]`. Cell array `dotFrames` contains a subsets of dot positions for each eye, `dotColor` defines dot color for each eye for each element and `dotSize` specifies dot size for each group and each eye. 
For example, define two dot patterns. 
```
  dotFrames{1}.(L,R) -> positions of different random dots for each eye
  dotColor{1}.L -> black, dotColor{1}.R-> white
  dotSize{1}.L - > .25degrees, dotSize{1}.R - > .55 degrees, 
  
  dotFrames{2}.(L,R) -> positions of still dots
  dotColor{2}.L -> black, dotColor{2}.R-> white
  dotSize{2}.L - > .25degrees, dotSize{2}.R - > .55 degrees, 
```
Run all trials for each condition.
```
  for s = 1:numel(conditions)    
    try
      trials = runCondition(mySession, myScr, conditions{s}, s);
  ...
```
For each condition, open an eyelink file. Filename must be under 8 chars.
```
function trials = runCondition(mySession, myScr, condition, s)
  if (mySession.recording) 
    eyelinkFile = [mySession.subj.name '_cnd' num2str(s) '.edf'];
    Eyelink('Openfile', eyelinkFile);				
```
For number of trials in each condition, execute the trial
```
  for t = 1:condition.info.nTrials
    try 
      [trials.timing(t), trials.response{t}] = runTrial(t, myScr, ...
        mySession.keys, condition, mySession.recording);
  ...              
```
For each trial, get the dot display info (frames, size, color), message Eyelink with condition/trial info, display the dots, collect subject's answer. 
```
  [dotFrames, dotColor, dotSize] = feval(condition.fhandle, condition.fparams{:});
  ...
  condition.info.msgEyelinkStart = ['STARTTIME:' num2str(GetSecs) ':' msgTrialDescription];  
  Eyelink('Message',  condition.info.msgEyelinkStart);
  ...
	trialTiming = drawDots(dotFrames, dotColor, dotSize, scr, dotUpdate);
	...
	[keys, response] = KeysGetResponse(keys, useEyelink);
```
Wen done displaying the condition, save trial timing and condition info in matstructure.  
```
  saveCondition(mySession, conditions{s}.info, myScr, s, trials);            
```
When all conditions have been displayed, session info will be saved and the eyelink files for each condition will be transferred.
```
  if (mySession.recording)
    for nC = 1:numel(conditions)
      %transfer eyelink file and save
      fileName = [mySession.subj.name '_cnd' num2str(nC)];
      EyelinkTransferFile(mySession.saveDir, fileName);
    end
  end
  % Save session info  
  saveSession(mySession, myScr);
```
