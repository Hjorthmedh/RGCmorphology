% This file illustrates the measures we use

clear all, close all

dataDir = '/Users/hjorth/DATA/RanaEldanaf/CB2/';
exampleFile = 'CB2-T4-R2-07092012-cell3-40x-08zoom.xml';

r = RGCmorph(exampleFile,dataDir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fractal dimension box counting illustration

coords = r.parseDendrites(@r.allCoords);

flattenedCoords = coords;
flattenedCoords(:,3) = 100;

r.drawNeuron();

maxC = max(coords,[],1);
minC = min(coords,[],1);
maxLen = max(maxC-minC)*1.01;

nBins = 30;
len = maxLen/nBins;

% binMat = zeros(nBins,nBins);

oneCol = ones(size(coords,1),1);
allOne = ones(size(coords));

coarseCoords = floor((coords - oneCol*minC) ./ (allOne * len)) + 1;

xMax = max(coarseCoords(:,2));
yMax = max(coarseCoords(:,1));

binMat = zeros(xMax,yMax);

for i = 1:size(coarseCoords,1)
  binMat(coarseCoords(i,2),coarseCoords(i,1)) = 1;
end

hold on

for y = 1:size(binMat,1)
  for x = 1:size(binMat,2)
   
    px = len*[x-1,x,x,x-1];
    py = minC(2)+len*[y-1,y-1,y,y];

    pX = len*[x-1,x;x-1,x];
    pY = minC(2)+len*[y-1,y-1; y, y];
    
    % Should we plot a solid box?
    if(binMat(y,x))
      surf(pX,pY,-10*ones(size(pX)),'facecolor',[1 1 1]*0.7)
      % rec = rectangle('position', [px(1),py(1),len,len], ...
      %                 'facecolor', [1 1 1]*0.8)
    end
    
    plot(px,py,'k-');
    
    
  end
end

axis equal
axis tight
axis off

printA4('FIGS/Illustration-FractalDimBoxCounting.eps');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%r.drawNeuron();
figure, subplot(1,2,1)
hold on

view(0,0)
axis normal

% Plot histogram of dendrites
xHist0 = maxC(1)+50;
xHistScale = 0.1;

[stratDepth,biStratDist,debugInfo] = r.getStratification();

binCount = debugInfo.dendBinCount;
binCenter = debugInfo.dendBinCenters;

for i = 1:numel(binCount)
  plot3(xHist0 + xHistScale*[0,binCount(i)], ...
        [0 0], ...
        [1 1]*binCenter(i), '-', 'linewidth',8,'color',0.7*[1 1 1]);
end

% Plot interpolation
G = debugInfo.fitted;
G(5:6) = abs(G(5:6));

interpZ = linspace(binCenter(1),binCenter(end),100);
gaussA = G(5)./sqrt(2*pi*G(3)^2) * exp(-(interpZ-G(1)).^2/(2*G(3)^2));
gaussB = G(6)./sqrt(2*pi*G(4)^2) * exp(-(interpZ-G(2)).^2/(2*G(4)^2));

plot3(xHist0+xHistScale*gaussA,-100*ones(size(gaussA)),interpZ,'k-')
plot3(xHist0+xHistScale*gaussB,-100*ones(size(gaussB)),interpZ,'k-')

% Make bistratification distance lines
plot3(xHist0+xHistScale*[0 max(binCount)*1.2], -100*[1 1], G(1)*[1 1],'k--','linewidth',2)
plot3(xHist0+xHistScale*[0 max(binCount)*1.2], -100*[1 1], G(2)*[1 1],'k--','linewidth',2)
plot3(xHist0+xHistScale*[1 1]*max(binCount)*1.2, ...
      -100*[1 1], ...
      G(1:2), 'k-','linewidth',2);
% text(xHist0+xHistScale*max(binCount)*1.2+10, ...
%      -200, mean(G(1:2)),'\Deltaz')

% Plot stratification depth
plot3(xHist0+xHistScale*[0 1]*max(binCount)*1.1, ...
      -100*[1 1], stratDepth*[1 1],'b-','linewidth',2)


% Scalebar
plot3(305*[1 1],[0 0],[-1 0],'k-','linewidth',3)


box off
axis off

printA4('FIGS/Illustration-Bistratification.eps');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Show the convex hull

r.drawNeuron();

cIdx = convhull(coords(:,1),coords(:,2));
a = axis();

hold on
fill3(coords(cIdx,1),coords(cIdx,2),-1000*ones(numel(cIdx),1), ...
      [1 1 1]*0.85,'edgecolor','none')

plot([200 250]+10,-240*[1 1],'k-','linewidth',2)

axis(a)
axis off

printA4('FIGS/Illustration-DendriticArea.eps');
