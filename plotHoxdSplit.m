% The clustering was done with findBestHoxd10Split.m here we are
% only plotting a selected few of those

clear all, close all

% Pre Jan 2015 plot
% RGCtoPlot = {{'Hoxd10-04022012.xml'}, ...
%              {'P25-Hoxd1007132012-r2-25x-06zoom.xml'}, ... % Single cell cluster, top right corner
%              {'Hoxd10-06082012-c1-corrected.xml'} }

 RGCtoPlot = {{'Hoxd10-bothears-righteyecontrol-04302013-40x-cell1-09zoom.xml'}, ...
              {'P25-Hoxd1007132012-r2-25x-06zoom.xml'}, ... % Single cell cluster, top right corner
              {'Hoxd10-none-righteyecontrol-04292013-40x-cell5-stitch.xml'} }


RGCpath = '/Users/hjorth/Data/RanaEldanaf/XML/Hoxd10/';
pos = [0 0;
       600 500; % Top right corner
       500 0];
       
numOrder = [2 1 3];

figure

for i = 1:numel(RGCtoPlot)
  for j = 1:numel(RGCtoPlot{i})
   
    x = pos(i,1) + (j-1)*400;
    y = pos(i,2);
    
    r = RGCmorph(RGCtoPlot{i}{j},RGCpath);
    r.drawNeuron(1,0,[x y 0]);

  end
end
 
plot([-100,0],-150*[1 1],'k-','linewidth',2)
text(-50,-170,'100 \mum','fontsize',12,'horizontalalignment','center')
title([])

axis off
printA4('FIGS/Hoxd10-split-single-examples.eps')