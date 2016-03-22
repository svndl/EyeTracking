function scr = getVideoMode(displayName)
	scr = eval(displayName);
	
	scr.wlevel = 255;       
	scr.glevel = 0;          
	scr.blevel = 0;         

	switch displayName
    
		case {'planar','laptopRB','LG3DRB','CinemaDisplayRB'}       % planar uses blue-left, red-right
        
			scr.REwhite = [scr.glevel scr.glevel scr.wlevel];
			scr.REblack = [scr.glevel scr.glevel scr.blevel];
        
			scr.LEwhite = [scr.wlevel scr.glevel scr.glevel];
			scr.LEblack = [scr.blevel scr.glevel scr.glevel];
        
		otherwise                                                   % other displays just use white/black
        
			scr.LEwhite = [scr.wlevel scr.wlevel scr.wlevel];
			scr.LEblack = [scr.blevel scr.blevel scr.blevel];
        
			scr.REwhite = [scr.wlevel scr.wlevel scr.wlevel];
			scr.REblack = [scr.blevel scr.blevel scr.blevel];
        
	end
	
end