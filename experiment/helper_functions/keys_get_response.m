function [stm, keys] = keys_get_response(keys, stm, trial, direction)
%
%

resps = {'away', 'towards', 'left', 'right'};
    
if ~isempty(GetGamepadIndices)
    
	[~, ~, keyCode] = KbCheck();
	
    resp(1) = Gamepad('GetButton', 1, keys.awayGP);
    resp(2) = Gamepad('GetButton', 1, keys.towardsGP);
    resp(3) = Gamepad('GetButton', 1, keys.leftGP);
    resp(4) = Gamepad('GetButton', 1, keys.rightGP);
    
else
    
    [~, ~, keyCode] = KbCheck();
    
    resp(1) = keyCode(keys.away);
    resp(2) = keyCode(keys.towards);
    resp(3) = keyCode(keys.left);
    resp(4) = keyCode(keys.right);
    
end

if sum(resp) == 1 && keys.isDown == 0
    
    display(['Response is ... ' resps{logical(resp)}]);

    stm.trials.resp{trial} = resps{logical(resp)};
    stm.trials.respCode(trial) = find(resp);
    keys.isDown = 1;
    
    %is response correct?
    if strcmp(stm.trials.resp{trial}, direction)
        
        display(['...Correct']);
        
        stm.trials.isCorrect(trial) = 1;
        
    else
        stm.trials.isCorrect(trial) = 0;
        display(['...Wrong']);
    end
    
elseif keyCode(keys.esc)
	
    cleanup(1, stm);

elseif sum(resp) == 0
    
    keys.isDown = 0;
    
end

