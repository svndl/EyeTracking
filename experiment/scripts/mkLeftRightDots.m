function [dotsL, dotsR ] = mkLeftRightDots(scr, stm, varargin)
% make nFrams of dots for a given condition

	nFrames = 1;
	if (~isempty(varargin))
		nFrames = varargin{1};
	end
	
	%max value for dot coordinates
	maxVal = min(stm.xmax, stm.ymax) / 2;
	c = char(stm.condition);
	switch c
    
		case 'SingleDot'        
			% just one dot per eye in center       
			dots = zeros(nFrames, 1);			
			dotsL.x = dots;
			dotsR.x = dots;
			stm.numDots = 1;			

		case 'IOVD'
			% for IOVD, two eyes are uncorrelated			
        
			dotsL.x = repmat(mkRandDots(maxVal, stm.numDots), [1 nFrames]);
			dotsR.x = repmat(mkRandDots(maxVal, stm.numDots), [1 nFrames]);
        
		case {'Mixed','MixedCons','MixedIncons'}  
			% for Mixed, first 1/2 are correlated, 2nd half uncorrelated        
			dotsSame = mkRandDots(maxVal, round(stm.numDots/2), nFrames);
                
			dotsL.x = [dotsSame mkRandDots(maxVal, round(stm.numDots/2), nFrames)];
			dotsR.x = [dotsSame mkRandDots(maxVal, round(stm.numDots/2), nFrames)];
        
		case {'CDOT','FullCue'}           
			% otherwise, same dots in both eyes        
			dots = mkRandDots(maxVal, stm.numDots, nFrames);
        
			dotsL.x = dots;
			dotsR.x = dots;
        
		otherwise
			error('invalid stimulus cues');
        
	end
	
	% y-coordinate is zero (no vertical motion)
	
 	dotsL.y = zeros(size(dotsL.x));
	dotsR.y = zeros(size(dotsR.x));
	
	% mirror reversal for Planar 
	dotsR.x = scr.signRight.*dotsR.x;
end