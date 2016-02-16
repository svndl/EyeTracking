function myData = getData(varargin)
    % function will load data from the experiment/data folder
    % varargin{1} -- experiment name
    % varargin{2} -- subject name
    %

    etpath = setPath_ET;
    dirStimulus = fullfile(etpath.results, 'stimulus');
        
    if (nargin == 0)
        lsStimulus = dir_clean(dirStimulus);
        %experiment setup:display, stimset, etc...
        listStimulus = {lsStimulus.name};
    end
    nStimsets = numel(listStimulus);
    stimsetData = cell(nStimsets, 1);
    
    %% 
    fullfilesExperiments = cell(nStimsets, 1);

    for sd = 1:nStimsets
        %load stims
        subjStimDir = dir_clean(fullfile(dirStimulus, listStimulus{sd}));
        listSubjStimDir = {subjStimDir.name};
        nSubjStims = numel(listSubjStimDir);
        stimsetSubj = cell(nSubjStims, 1);
        fullfilesSubjects = cell(nSubjStims, 1);
        
        for ns = 1:nSubjStims
            fullfileSubjExp = fullfile(dirStimulus, listStimulus{sd}, listSubjStimDir{ns});
            fullfilesSubjects{ns} = strtok(fullfileSubjExp, '.');
            load(fullfileSubjExp);
            dat.exp_name = listStimulus{sd};
            dat.ipd = 350;
            stimsetSubj{ns} = dat;            
        end
        stimsetData{sd} = stimsetSubj;
        fullfilesExperiments{sd} = fullfilesSubjects;
    end
    
    el  = eyelink_load_info;         % load in info about eyelink data aquisition        
    
    dcnt = 1;   % trial counter for responses
    tcnt = 1;   % trial counter for eyelink data
    
    for td = 1:size(fullfilesExperiments, 1)
        %loop through the experiments
        expTrack = fullfilesExperiments{td};
        %loop throught the subjects
        for ts = 1:size(expTrack, 1)
            subjTrack = strrep(expTrack{ts}, 'stimulus', 'tracking');
            edfFile_calibration = [subjTrack '_calibration.edf'];
            edfFile_Tracking = [subjTrack '.asc'];
            
            res = stimsetData{td}{ts};
            predictions = calcPredictions(res, el);
            res.el = el;
            res.predictions = predictions;
            res = loadELCalibration(edfFile_calibration, res);  % load and store calibration info
            [res, tcnt] = loadELData(edfFile_Tracking, el, res, tcnt);
            [res, dcnt] = loadResponses(dcnt, res);
            res = convert_data_values(res);  % convert screen coords to eye movements
            res = compute_velocity(res);     % compute velocity from position data
            plotResults(res, 'velocity', 'monocular');
        end
    end
end

% function getResponses()
%     [res, dcnt] = responses_load_data(dcnt, dat, res, f);  % fill in response and trial data
% end

% function getEyelinkData(elFileName, el)
%     %for each stimset look for TWO files in /tracking directory    
% 
%     edfFile_calibration = [elFileName '_calibration.edf'];
%     edfFile_Tracking = [elFileName '.edf'];
%     
%     elCalibration = loadELCalibration(edfFile_calibration);  % load and store calibration info
%     elData = loadELData(edfFile_Tracking, el, result);
% end