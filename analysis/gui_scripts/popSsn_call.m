function [] = popSsn_call(varargin)
% Callback for Sessions popupmenu.
    S = varargin{3}; 
    dataOut = loadConditionData(S);
    displayCndInfo(S, dataOut.info);
    cla(S.pos_left); 
    cla(S.pos_right); 
    cla(S.pos_verg); 
    cla(S.pos_vers); 

    cla(S.vel_left); 
    cla(S.vel_right); 
    cla(S.vel_vers);
    cla(S.vel_verg); 
end