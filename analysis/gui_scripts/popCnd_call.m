function [] = popCnd_call(varargin)
% Callback for Conditions popupmenu.
    S = varargin{3};
    cndData = loadConditionData(S);     
    displayCndInfo(S, cndData.info);
    
    cla(S.pos_left); 
    cla(S.pos_right); 
    cla(S.pos_verg); 
    cla(S.pos_vers); 

    cla(S.vel_left); 
    cla(S.vel_right); 
    cla(S.vel_vers);
    cla(S.vel_verg); 
end