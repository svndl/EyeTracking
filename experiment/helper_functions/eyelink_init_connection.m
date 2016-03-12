function elConnStatus = eyelink_init_connection
	elConnStatus = 0;

    if (~EyelinkInit(0, 1))                       
        fprintf('Eyelink Init aborted.\n');
	else
		Eyelink('Command', 'link_sample_data = LEFT,RIGHT,HREF,AREA');
		elConnStatus = 1;			
	end
end