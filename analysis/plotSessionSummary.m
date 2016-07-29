function plotSessionSummary(varargin)
% function will plot session's summary: 
    
    % select session
    
    dirData = setPath;
    if(~nargin)
        dirname = uigetdir(dirData.data);
        sessionPath = dirname;        
    else
        sessionPath = varargin{1};
    end
    
    % figures will be saved in SESSION_DIR/figures
    
    figurePath = fullfile(sessionPath, 'figures');
    if (~exist(figurePath, 'dir'))
        mkdir(figurePath);
    end
    
    sessionData = loadSession(sessionPath);    
    nCnd = numel(sessionData);
    close all;
    for c = 1:nCnd
        data = sessionData{c};
        stimPos = calcStimsetTrajectory(data.info);
    
        %% Plot L/R trajectories
        
        %open new figure
        posLR = figure;
        title('Left and Right eye trajectories');
        
        %extract L/R pos tracking data    
        lX = squeeze(data.pos.L(:, 1, :));
        lY = squeeze(data.pos.L(:, 2, :));
            
        rX = squeeze(data.pos.R(:, 1, :));
        rY = squeeze(data.pos.R(:, 2, :));
        
        % plot L/R trajectories and stimset
        plotBothEyes(lX, lY, rX, rY, 'pos', stimPos);
        
        % save figure
        saveas(posLR, fullfile(figurePath, ['Eyes Trajectories_cnd' num2str(c)]), 'fig');
        %close figure
        close gcf;
        
        %% Plot L/R Velocities
        velLR = figure;
        title('Left and Right eye velocity');
        
        lvX = squeeze(data.vel.L(:, 1, :));
        lvY = squeeze(data.vel.L(:, 2, :));
            
        rvX = squeeze(data.vel.R(:, 1, :));
        rvY = squeeze(data.vel.R(:, 2, :));
        
        plotBothEyes(lvX, lvY, rvX, rvY, 'vel');
        saveas(velLR, fullfile(figurePath, ['Eyes Velo_cnd' num2str(c)]), 'fig');
        close gcf;
        
        %% Plot L/R Vergence and Version
        ver_ver = figure;
        title('Vergence and Version');
        
        subplot(2, 1, 1)
        plotOneEye(data.timecourse, lX - lY, rX - rY, 'vergence', 'k', {});
        
        subplot(2, 1, 2)
        plotOneEye(data.timecourse, lvX - lvY, rvX - rvY, 'version', 'g', {});
        
        saveas(ver_ver, fullfile(figurePath, ['Eyes Vergence_cnd' num2str(c)]), 'fig');
        close gcf;     

        
        %% Get yer response pie charts here
        
        % user response is in data.response 
        % direction of motion is in data.info.direction
        
        
    end
end

function plotBothEyes(lX, lY, rX, rY, type, varargin)
     stimPosl = {};
     stimPosr = {};
     
    if (~isempty(varargin))
        stimPosl = varargin{1}.l;
        stimPosr = varargin{1}.r;        
    end
    timecourse = 1:size(lX, 1);
    subplot(2, 1, 1)        
        
    plotOneEye(timecourse, lX, lY, [type ' left'], 'b', ...
            stimPosl); 
    
        subplot(2, 1, 2)
        plotOneEye(timecourse, rX, rY, [type ' right'], 'r', ... 
            stimPosr);
end

function plotOneEye(timecourse, eyeX, eyeY, legendName, color, stimsetPos)
    muDatax = mean(eyeX, 2);
    muDatay = mean(eyeY, 2);

    semDatax = std(eyeX, [], 2)/sqrt(size(eyeX, 2));
    semDatay = std(eyeY, [], 2)/sqrt(size(eyeY, 2));
    
    h1 = shadedErrorBar(timecourse, muDatax, semDatax, {['-' color], 'LineWidth', 2}); hold on
    h2 = shadedErrorBar(timecourse, muDatay, semDatay, {['-' color], 'LineWidth', 2}); hold on
    legendRef = [h1.patch, h2.patch];
    legendStr =  {[ legendName ' x'], [legendName ' y']};
    if (~(isempty(stimsetPos)))
        stimPosx = stimsetPos.x;
        stimPosy = stimsetPos.y; 
    
        p1 = plot(timecourse(1:25:end), -stimPosx(1:25:end), [':' color], ...
            'LineWidth', 1.5, 'MarkerSize', 5, 'Marker', '+'); hold on;
        p2 = plot(timecourse(1:25:end), -stimPosy(1:25:end), [':' color], ...
            'LineWidth', 1.5, 'MarkerSize', 5, 'Marker', '+'); hold on;
        legendRef = [legendRef p1 p2];
        legendStr = {legendStr{:}, 'stimset x','stimset y'};
    end     
   legend(legendRef, legendStr{:});
    xlabel('Time samples');
    ylabel('Degrees per second');
end



function H=shadedErrorBar(x,y,errBar,lineProps,transparent)
% function H=shadedErrorBar(x,y,errBar,lineProps,transparent)
%
% Purpose 
% Makes a 2-d line plot with a pretty shaded error bar made
% using patch. Error bar color is chosen automatically.
%
% Inputs
% x - vector of x values [optional, can be left empty]
% y - vector of y values or a matrix of n observations by m cases
%     where m has length(x);
% errBar - if a vector we draw symmetric errorbars. If it has a
%          size of [2,length(x)] then we draw asymmetric error bars
%          with row 1 being the upper bar and row 2 being the lower
%          bar. ** alternatively ** errBar can be a cellArray of
%          two function handles. The first defines which statistic
%          the line should be and the second defines the error
%          bar. 
% lineProps - [optional,'-k' by default] defines the properties of
%             the data line. e.g.:    
%             'or-', or {'-or','markerfacecolor',[1,0.2,0.2]}
% transparent - [optional, 0 by default] if ==1 the shaded error
%               bar is made transparent, which forces the renderer
%               to be openGl. However, if this is saved as .eps the
%               resulting file will contain a raster not a vector
%               image. 
%
% Outputs
% H - a structure of handles to the generated plot objects.     
%
%
% Examples
% y=randn(30,80); x=1:size(y,2);
% shadedErrorBar(x,mean(y,1),std(y),'g');
% shadedErrorBar(x,y,{@median,@std},{'r-o','markerfacecolor','r'});    
% shadedErrorBar([],y,{@median,@std},{'r-o','markerfacecolor','r'});    
%
% Overlay two transparent lines
% y=randn(30,80)*10; x=(1:size(y,2))-40;
% shadedErrorBar(x,y,{@mean,@std},'-r',1); 
% hold on
% y=ones(30,1)*x; y=y+0.06*y.^2+randn(size(y))*10;
% shadedErrorBar(x,y,{@mean,@std},'-b',1); 
% hold off
%
%
% Rob Campbell - November 2009


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Error checking    
error(nargchk(3,5,nargin))


%Process y using function handles if needed to make the error bar
%dynamically
if iscell(errBar) && ~isvector(y)
    fun1=errBar{1};
    fun2=errBar{2};
    errBar=fun2(y);
    y=fun1(y);
elseif ~iscell(errBar) && isvector(y)
    y=y(:)';
else
    error('2nd and 3rd input arguments are not compatible')
end

if isempty(x)
    x=1:length(y);
else
    x=x(:)';
end

if length(x) ~= length(y)
    error('inputs x and y are not of equal lengths')
end


%If only one error bar is specified then we will mirror it, turning it into
%both upper and lower bars. 
if length(errBar)==length(errBar(:))
    errBar=repmat(errBar(:)',2,1);
else
    f=find(size(errBar)==2);
    if isempty(f), error('errBar has the wrong size'), end
    if f==2, errBar=errBar'; end
end

if length(x) ~= length(errBar)
    error('inputs x and y must have the same length as errBar')
end


%Set default options
defaultProps={'-k'};
if nargin<4 || isempty(lineProps)
    lineProps=defaultProps; 
end
if ~iscell(lineProps)
    lineProps={lineProps}; 
end


if nargin<5 || ~isnumeric(transparent)
    transparent=0; 
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Plot the main line. We plot this first in order to extract the RGB values
% for the line colour. I am not aware of a function that does this.
H.mainLine=plot(x,y,lineProps{:});


% Work out the color of the shaded region and associated lines
% Using alpha requires the render to be openGL and so you can't
% save a vector image. On the other hand, you need alpha if you're
% overlaying lines. We therefore provide the option of choosing alpha 
% or a de-saturated solid colour for the patch surface.

col=get(H.mainLine,'color');
edgeColor=col+(1-col)*0.55;
patchSaturation=0.15; %How de-saturated or transparent to make the patch
if transparent
    faceAlpha=patchSaturation;
    patchColor=col;
    set(gcf,'renderer','openGL')
else
    faceAlpha=1;
    patchColor=col+(1-col)*(1-patchSaturation);
    set(gcf,'renderer','painters')
end

    
%Calculate the y values at which we will place the error bars
uE=y+errBar(1,:);
lE=y-errBar(2,:);



%Add the error-bar plot elements
holdStatus=ishold;
if ~holdStatus, hold on,  end


%Make the cordinats for the patch
yP=[lE,fliplr(uE)];
xP=[x,fliplr(x)];

%remove any nans otherwise patch won't work
xP(isnan(yP))=[];
yP(isnan(yP))=[];


H.patch=patch(xP,yP,1,'facecolor',patchColor,...
              'edgecolor','none',...
              'facealpha',faceAlpha);


%Make nice edges around the patch. 
H.edge(1)=plot(x,lE,'-','color',edgeColor);
H.edge(2)=plot(x,uE,'-','color',edgeColor);

%The main line is now covered by the patch object and was plotted first to
%extract the RGB value of the main plot line. I am not aware of an easy way
%to change the order of plot elements on the graph so we'll just remove it
%and put it back (yuk!)
delete(H.mainLine)
H.mainLine=plot(x,y,lineProps{:});


if ~holdStatus, hold off, end
end

