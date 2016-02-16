function res = loadELCalibration(edfFile, res)
 %function will parse and load calibration info for edfFile
 

    res.calibrationLeft          = 'No left eye calibration quality information stored';
    res.calibrationRight         = 'No right eye calibration quality information stored';
    res.calibrationAvgLeftError  = NaN;
    res.calibrationAvgRightError = NaN;
    res.calibrationMaxLeftError  = NaN;
    res.calibrationMaxRightError = NaN;

    % look for calibration file
    if exist(edfFile, 'file')
    
        % look for left and right eye calibration lines
        fid = fopen(edfFile);
        fLine = fgetl( fid );
        while (fLine ~=-1 ) 
            if strfind(fLine, '!CAL VALIDATION HV13 LR LEFT');
            
                res.calibrationLeft = fLine;
                res.calibrationAvgLeftError = str2double(cell2mat(regexp(fLine,'(?<=ERROR )[^]+(?= avg.)', 'match')));
                res.calibrationMaxLeftError = str2double(cell2mat(regexp(fLine,'(?<=avg. )[^]+(?= max)', 'match')));
            
            elseif strfind(fLine,'!CAL VALIDATION HV13 LR RIGHT');
            
                res.calibrationRight = fLine;
                res.calibrationAvgRightError = str2double(cell2mat(regexp(fLine,'(?<=ERROR )[^]+(?= avg.)', 'match')));
                res.calibrationMaxRightError = str2double(cell2mat(regexp(fLine,'(?<=avg. )[^]+(?= max)', 'match')));
            end
            fLine = fgetl( fid );
        end
        fclose(fid);        
    end
end