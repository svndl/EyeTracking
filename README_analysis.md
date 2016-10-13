
## This is a readme file describing the structure of the analysis folder. Analysis folder contains various scripts for processing and viewing the data from Eyetracking experiments.

# Analysis folder organization and quick manual

* *computations* -- HREF to visual angle conversion scripts
* *export* -- scripts for exporting the data
* *gui_scripts* -- gui definitions for gui_loadProject and gui_loadSession
* *plot* -- plotting routines
* *misc* -- uncategorized scripts 
* *processing* -- loading, converting and cleaning up the eyetracking data

To look into the session data, run *gui_loadSession.m*.
To see multiple sessions within the same project,  run *gui_loadProject.m*.

We'll break down the contents of *gui_loadSession.m* script to explain how raw Eyetracking data is being processed.
First, user will need to select the session location:

*
    close all;
    dirData = setPath;
    dataDir = dirData.data;
       
    if(~nargin)
        sessionPath = uigetdir(dataDir);
    else
        sessionPath = varargin{1};
    end
 
*
Then, the experiment data will be processed OR loaded with *loadSession.m* script.
Data processing pipeline:

For each raw file within the session directory: 
* *convertEyelinkFile(filePath, fileName, flags)* -- run edf2asc conversion, move raw recording files to the *raw/* folder.
* * rawData = loadEyelinkFile.m(filename, varargin)* -- reads contents of *.asc files. The output is a cell array, each column is a certain type of data and each row is a string value of this data.
* *trialsData = processEyelinkData.m(rawData, search_args)* -- breaks down the *rawData* data into trials using *search_args* timestamps. At this step we also mark atrifacts (blinks) and reject poor quality trials. 
The cell array *trialsData* has the dimentions of nTrials, *trialsData{trialX} = timeSamples x nVariables*.
Variable  *timeSamples = Trial duration in seconds * Eyelink Data Sampling Rate*.
Variable *nVariables = {Left eye x, Left eye y, Right eye x, Right Eye y, Left eye x velocity, Left eye y velocity, Right eye x velocity, Right Eye y velocity, sample quality*.
* *[missedFrames, response, eyetracking, trialIndex, sessionInfo] = loadRawData.m (path to session)* -- merges all session eyetracking data into by-trial cell matrices.
* *sessionData = processRawData.m(pathToSession)* -- rearrange the raw data by conditions, for each condition convert and resample the data *convertEyelinkData.m*, saves the resulting data to matfile structure (to be loaded later).
* *dataOut = loadSession.m(pathToSession)* -- filters the data and removes the prelude.




