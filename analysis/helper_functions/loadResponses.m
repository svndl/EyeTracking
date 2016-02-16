function [res, dcnt] = loadResponses(dcnt, results)

% data fields to fill in are two types, experiment-specific and
% trial-specific
    fields_exp = {'subj', 'exp_name', 'ipd', 'training', 'dispArcmin',...
        'stimRadDeg', 'dotSizeDeg', 'dotDensity',...
        'preludeSec', 'cycleSec'};
    
    fields_trial = {'condition', 'dynamics', 'direction', 'repeat',...
        'trialnum', 'resp', 'respCode', 'isCorrect',    'delayTimeSec'};

    num_trials = length(results.trials.condition);
    res = results;


    % experiment-specific info
    for f = 1:length(fields_exp)
    
        if ischar(results.(fields_exp{f}))
            flist = repmat({results.(fields_exp{f})}, 1, num_trials);
        else
            flist = repmat(results.(fields_exp{f}), 1, num_trials);
        end
    
        res.trials.(fields_exp{f})(dcnt:dcnt + num_trials - 1) = flist;
    end


    % trial specific info
    for f = 1:length(fields_trial)
        flist = results.trials.(fields_trial{f})(results.trials.trialnum);
        res.trials.([fields_trial{f} 'R'])(dcnt:dcnt + num_trials - 1) = flist;
    end

    %stimulus predictions
    v_half_angle = atand(((results.ipd/2))./res.el.href_dist); % half the vergence angle

    cntr = 1;
    for t = dcnt:dcnt - 1 + num_trials

        switch res.trials.directionR{t}
        
            case 'left'
            
                res.trials.predictionLE{dcnt - 1 + cntr} = v_half_angle - res.predictions.(res.trials.dynamicsR{t});
                res.trials.predictionRE{dcnt - 1 + cntr} = -v_half_angle - res.predictions.(res.trials.dynamicsR{t});
            
            case 'right'
            
                res.trials.predictionLE{dcnt - 1 + cntr} = v_half_angle + res.predictions.(res.trials.dynamicsR{t});
                res.trials.predictionRE{dcnt - 1 + cntr} = -v_half_angle + res.predictions.(res.trials.dynamicsR{t});
            
            case 'towards'
            
                res.trials.predictionLE{dcnt -1 + cntr} = v_half_angle + res.predictions.(res.trials.dynamicsR{t});
                res.trials.predictionRE{dcnt -1 + cntr} = -v_half_angle - res.predictions.(res.trials.dynamicsR{t});
            
            case 'away'
            
                res.trials.predictionLE{dcnt - 1 + cntr} = v_half_angle - res.predictions.(res.trials.dynamicsR{t});
                res.trials.predictionRE{dcnt - 1 + cntr} = -v_half_angle + res.predictions.(res.trials.dynamicsR{t});
            otherwise
        end
        cntr = cntr + 1;
    end
    dcnt = dcnt + num_trials; % increment counter
end
    

