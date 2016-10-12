
## This is a readme file describing the structure of the analysis folder. Analysis folder contains various scripts for processing and viewing the data from Eyetracking experiments.

# Analysis folder organization and quick manual

* *computations* -- HREF to visual angle conversion scripts
* *export* -- scripts for exporting the data
* *gui_scripts* -- gui definitions for gui_loadProject and gui_loadSession
* *plot* -- plotting routines
* *misc* -- uncategorized scripts 
* *processing* -- loading, converting and cleaning up the eyetracking data

We'll break down the contents of *gui_loadSession.m* script to explain how raw Eyetracking data is being processed.
First, define the session location ** to be

**
    close all;
    dirData = setPath;
    dataDir = dirData.data;
       
    if(~nargin)
        sessionPath = uigetdir(dataDir);
    else
        sessionPath = varargin{1};
    end
 
**

  data = loadSession(sessionPath);
*    
    
    dataOut = loadConditionData(guiSsn);
