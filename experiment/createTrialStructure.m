function dataCombs = createTrialStructure(data)

	
	%stimset all combvec
	columnLabels = {'dynamics', 'directions', 'motiontype', 'stimRadDeg', ...
		'dispArcmin', 'rampSpeedDegSec', 'dotSizeDeg', ...
		'dotDensity', 'cycleSec', 'trialRepeats'};
	cartesianTrialProd = allcomb(data.dynamics, data.directions, data.motiontype, ...
		num2cell(data.stimRadDeg), num2cell(data.dispArcmin), num2cell(data.rampSpeedDegSec), ... 
		num2cell(data.dotSizeDeg), num2cell(data.dotDensity), num2cell(data.cycleSec), ...
		num2cell(data.trialRepeats));
	
	% cell combvec	
	
	nDataCombs = size(cartesianTrialProd, 1);
	dataCombs = cell(nDataCombs, 1);
		
	for dn = 1: nDataCombs
		copyData = data;
		for fn = 1:numel(columnLabels);
			copyData.(columnLabels{fn}) = cartesianTrialProd{dn, fn};
		end		
		dataCombs{dn} = copyData;
	end
end
