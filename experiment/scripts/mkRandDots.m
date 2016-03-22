function dots = mkRandDots(maxVal, nDots, varargin)
	% make dot coordinates 
	
	nFrames = 1;
	if (~isempty(varargin))
		nFrames = varargin{1};
	end
	dots = 2*(maxVal)*rand(nFrames, nDots) - maxVal;
end 