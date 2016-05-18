function vAngle = computeVelocity(x, sampleRate)
% take eye position data and convert to velocity

    % sgolay filter design for differentiation
    % Order of polynomial fit    
    N = 3;                
    % Window length    
    F = 101;               
    % Calculate S-G coefficients    
    [~, g] = sgolay(N, F);     
    spacing = 1/sampleRate; % temporal spacing between samples

    % convert position to velocity using sgolay filter
    % velo = gradient(x,spacing); %gradient filter -- too noisy!
    HalfWindowF  = (F + 1)/2 - 1; 
    
    SG1 = zeros((length(x) - 2*HalfWindowF), size(x, 2));
    
    % 1st differential
    g1 = repmat(g(:, 2), [1 size(x, 2)]);
    for n = HalfWindowF:length(x) - HalfWindowF - 1
        SG1(n, :) = dot(g1, x(n - HalfWindowF + 1:n + HalfWindowF + 1, :));
    end

    % Turn differential into derivative, pad with NaNs
    vAngle = [(SG1/spacing); NaN*ones(HalfWindowF + 1, 1)];
end