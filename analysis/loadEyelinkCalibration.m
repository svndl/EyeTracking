function calibrationErr = loadEyelinkCalibration(filename)

    % generate calibration data file name

    % start with no data stored
    
    avgL = 'NaN';
    maxL = 'NaN';
    
    avgR = 'NaN';
    maxR = 'NaN';
    
    % look for calibration file
    if exist(filename, 'file')
    
        % look for left and right eye calibration lines
        fid = fopen(filename);

        while(1)
            Line = fgetl( fid );    % read a line from file
            if( Line == -1 )        % reached end of file
                fclose(fid); break;
            end
        
            if strfind(Line,'!CAL VALIDATION HV13 LR LEFT');
            
                avgL = str2double(cell2mat(regexp(Line,'(?<=ERROR )[^]+(?= avg.)', 'match')));
                maxL = str2double(cell2mat(regexp(Line,'(?<=avg. )[^]+(?= max)', 'match')));
                
            elseif strfind(Line,'!CAL VALIDATION HV13 LR RIGHT');
            
                avgR = str2double(cell2mat(regexp(Line,'(?<=ERROR )[^]+(?= avg.)', 'match')));
                maxR = str2double(cell2mat(regexp(Line,'(?<=avg. )[^]+(?= max)', 'match')));
                
            end
        end
    end
    calibrationErr.left.avg = avgL;
    calibrationErr.left.max = maxL;
    calibrationErr.right.avg = avgR;
    calibrationErr.right.max = maxR;
end
