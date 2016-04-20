function [dotsL, dotsR ] = mkLeftRightDots(scr, stm, varargin)
% make nFrams of dots for a given condition

	nFrames = 1;
	if (~isempty(varargin))
		nFrames = varargin{1};
	end
	
	%max value for dot coordinates
	maxVal = min(stm.xmax, stm.ymax) / 2;
	
	switch char(stm.condition)
    
		case 'SingleDot'        
			% just one dot per eye in center       
			dots = zeros(nFrames, 1);			
			dotsL.x = dots;
			dotsR.x = dots;
			stm.numDots = 1;			
            dotsL.y = zeros(size(dotsL.x));
            dotsR.y = zeros(size(dotsR.x));

		case 'IOVD'
			% for IOVD, two eyes are uncorrelated			
        
			dotsL.x = repmat(mkRandDots(maxVal, stm.numDots), [nFrames 1]);
			dotsR.x = repmat(mkRandDots(maxVal, stm.numDots), [nFrames 1]); 	
            dotsL.y = repmat(mkRandDots(maxVal, stm.numDots), [nFrames 1]);
            dotsR.y = repmat(mkRandDots(maxVal, stm.numDots), [nFrames 1]);

		case {'Mixed','MixedCons','MixedIncons'}  
			% for Mixed, first 1/2 are correlated, 2nd half uncorrelated        
			dotsSameX = mkRandDots(maxVal, round(stm.numDots/2), nFrames);
			dotsSameY = mkRandDots(maxVal, round(stm.numDots/2), nFrames);
                
			dotsL.x = [dotsSameX mkRandDots(maxVal, round(stm.numDots/2), nFrames)];
			dotsR.x = [dotsSameX mkRandDots(maxVal, round(stm.numDots/2), nFrames)];
            
			dotsL.y = [dotsSameY mkRandDots(maxVal, round(stm.numDots/2), nFrames)];
			dotsR.y = [dotsSameY mkRandDots(maxVal, round(stm.numDots/2), nFrames)];
        
		case {'CDOT','FullCue'}           
			% otherwise, same dots in both eyes        
			dotsX = mkRandDots(maxVal, stm.numDots, nFrames);
			dotsY = mkRandDots(maxVal, stm.numDots, nFrames);
			
            dotsL.x = dotsX;
			dotsR.x = dotsX;
            
            dotsL.y = dotsY;
			dotsR.y = dotsY;
        
		otherwise
			error('invalid stimulus cues');
        
	end
	
	% y-coordinate is zero (no vertical motion)
	
	
	% mirror reversal for Planar 
	dotsR.x = scr.signRight.*dotsR.x;
end