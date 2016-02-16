% script to demo ColorIt

clear all; close all;

data    = rand(100,6);
data    = data + repmat((5*rand(1,6)),100,1);
mcolors = 'rbygmc';


% bar plots
figure; hold on;

subplot(311); hold on; title('Matlab 1');
for x = 1:size(data,2);
  bar(x,mean(data(:,x)),mcolors(x))
end

subplot(312); hold on; title('Matlab 2');
bar(cat(1,mean(data,1),zeros(1,size(data,2))))
xlim([0.5 1.5]);

subplot(313); hold on; title('ColorIt');
for x = 1:size(data,2);
  bar(x,mean(data(:,x)),'facecolor',ColorIt(x))
end


% line plots
figure; hold on;

subplot(311); hold on; title('Matlab 1');
for x = 1:size(data,2);
  plot(data(:,x), 'Color', mcolors(x),'linewidth',2)
end

subplot(312); hold on; title('Matlab 1');
plot(data,'linewidth',2);

subplot(313); hold on; title('ColorIt');
for x = 1:size(data,2);
  plot(data(:,x), 'Color', ColorIt(x),'linewidth',2)
end

