# Experiment list of features/fixes

## Display

* FIXED nonius lines and fixation

## Eyelink

* Send trial start/end message and start the trial inside the `drawDots` function (currently beforte callback).
Might help with raw data uniform issues. 

## Session

* Real-time eyelink data export and possibly processing. Curently real-time file transfer (after each condition) is not stable.

***

# Analysis list of features/fixes

## Accessing the data


## Processing the data

* Clipping the trials (eyelink trial duration varies by .2 s)
* Syncing the trials with timing info
* Test conversion from HREF to visual angle

## Displaying the data

* stable GUI performance
