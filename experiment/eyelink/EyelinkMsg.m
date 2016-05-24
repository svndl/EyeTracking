function EyelinkMsg(strMsg)
% function will send a message strMsg to Eyelink
    
    if (Eyelink('IsConnected') == 1)
        Eyelink('Message', strMsg);
    end
end