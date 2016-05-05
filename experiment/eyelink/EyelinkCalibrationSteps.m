function result = EyelinkCalibrationSteps(el, sendkey)

% USAGE: result=EyelinkDoTrackerSetup(el [, sendkey])
%
%		el: Eyelink default values
%		sendkey: set to go directly into a particular mode
% 				'v', start validation
% 				'c', start calibration
% 				'd', start driftcorrection
% 				13, or el.ENTER_KEY, show 'eye' setup image

%
% 02-06-01	fwc removed use of global el, as suggest by John Palmer.
%				el is now passed as a variable, we also initialize Tracker state bit
%				and Eyelink key values in 'initeyelinkdefaults.m'
% 15-10-02	fwc	added sendkey variable that allows to go directly into a particular mode
% 22-06-06	fwc OSX-ed
% 15-06-10	fwc added code for new callback version
%
% Emily renamed and cleaned up this PTB code


    result = -1;
    
    if nargin < 1
        error( 'USAGE: result=EyelinkDoTrackerSetup(el [,sendkey])' );  
    end


    Eyelink( 'StartSetup' );                                   
    Eyelink( 'WaitForModeReady', el.waitformodereadytime );    
    EyelinkClearCalDisplay(el);

    % dump old keys
    key = 1;
    while key ~= 0
        key = EyelinkGetKey(el);                              
    end

    % go directly into a particular mode if given
    if nargin == 2                                              
        if el.allowlocalcontrol == 1;
            switch lower(sendkey)
                case{ 'c', 'v', 'd', el.ENTER_KEY}
                    forcedkey = double(sendkey(1,1));
                    Eyelink('SendKeyButton', forcedkey, 0, el.KB_PRESS );
            end
        end   
    end

    stop = 0;

    while  ~stop && bitand(Eyelink( 'CurrentMode'), el.IN_SETUP_MODE)

        i = Eyelink( 'CurrentMode');
    
        if ~(Eyelink( 'IsConnected' ))
            stop = 1; 
            break; 
        end
        
        % calibrate, validate, etc: show targets
        if bitand(i, el.IN_TARGET_MODE)			
            EyelinkTargetDisplay(el);	
        
        % display image until we're back
        elseif bitand(i, el.IN_IMAGE_MODE)		
            if Eyelink ('ImageModeDisplay') == el.TERMINATE_KEY 
                result = el.TERMINATE_KEY;
                return;                        
            else
                EyelinkClearCalDisplay(el);     
            end	
        end
        
        % getkey() HANDLE LOCAL KEY PRESS
        [key, el] = EyelinkGetKey(el);		
        
%         if 1 && key~=0 && key~=el.JUNK_KEY
%             fprintf('%d\t%s\n', key, char(key) );
%         end
    
        switch key	
            case el.TERMINATE_KEY,				% breakout key code
                result = el.TERMINATE_KEY;
                return;
            case { 0, el.JUNK_KEY }          % No or uninterpretable key
            case el.ESC_KEY,
                 % instead of 'goto exit'
                if Eyelink('IsConnected') == el.dummyconnected
                    stop = 1;
                end
                if el.allowlocalcontrol
                    Eyelink('SendKeyButton', key, 0, el.KB_PRESS );
                end
            otherwise
                if el.allowlocalcontrol
                    Eyelink('SendKeyButton', double(key), 0, el.KB_PRESS );
                end
        end
        WaitSecs(0.1);
    end

    % exit
    EyelinkClearCalDisplay(el);
    result = 0;
end