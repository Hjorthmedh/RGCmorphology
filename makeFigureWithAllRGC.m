% This function plots a figure with all RGC

clear all, close all

previouslyUsed = { 'CB2-rightear-R1-beads-07032012-cell1-40x-06zoom.xml', ...
                   'Cdh3-07-18-2012-a2r2-cell2-40x-corrected.xml', ...
                   'P25-DRD4-07142012-r1-c2-40x-07zoom.xml', ...
                   'Hoxd10-06062012-c2-corrected.xml', ...
                   'P40-TRHR-03222012-r2c2-40x.xml', ...
                   'CB2-06142012-cell1-40x.xml', ...
                   'Cdh3-a3r3-07172012-cell3-40x-0.xml', ...
                   'DRD4-noearclip-righteye-control-06012013-cell2-40x-09zoom.xml', ...
                   'P25-Hoxd1007132012-r2-25x-06zoom.xml', ...
                   'TRHR-07182012-a1r1-cell1-40x-0.xml', ...
                   'CB2-2ears-R1-07062012-cell3-40x-06zoom.xml', ... % Rana reject
                   'Hoxd10-none-righteyecontrol-04292013-40x-cell2-09zoom.xml', ... % Rana reject
                   'Hoxd10-none-righteyecontrol-04292013-40x-cell3.xml', ...
                   'CB2-2ears-R1-07062012-cell4-40x-06zoom.xml', ...
                   'Hoxd10-none-righteyecontrol-04292013-40x-cell5-stitch.xml', ...                 
                   'CB2-07182012-r1-cell1-40x-06zoom-corrected.xml', ...
                   'CB2-T4-R2-07092012-cell3-40x-08zoom.xml', ...
                   'Hoxd10-04292013-leftear-righteyecontrol-cell3-40x-tile_Stitch.xml', ...
                   'Hoxd10-04292013-rightear-righteyecontrol-cell2-40x-tile.xml', ...
                   'Hoxd10-04292013-rightear-righteyecontrol-cell1-40x-tile_Stitch.xml', ...
                   'Hoxd10-leftear-righteyecontrol-04292013-40x-cell2-07zoom.xml', ...
                   'P82-Hoxd10-retina2-cell4-07022012.xml' ...
                 }; % Rana reject

dataPath = '/Users/hjorth/DATA/RanaEldanaf/XML';

classDir = { 'CB2','Cdh3','DRD4','Hoxd10','TRHR' };
nOfEach = 3;
filesUsed = {};

nBad = 0;

for i = 1:numel(classDir)
  fileList = dir(sprintf('%s/%s/', dataPath, classDir{i}));
  fileIdx = find(~cat(1,fileList.isdir));
 
  % List of all file names
  fileNames = {};
  for j = 1:numel(fileIdx)
    fileNames{j} = fileList(fileIdx(j)).name;
  end

  % Remove those that are part of excluded list
  badFlag = ismember(fileNames,previouslyUsed);
  badFlag2 = ismember(fileNames,'.DS_Store');
  badFlag = badFlag + badFlag2;
  
  nBad = nBad + nnz(badFlag);
  fileNames = fileNames(find(~badFlag));
  
  useIdx = randperm(numel(fileNames));
  useIdx = useIdx(1:nOfEach);
  
  for j = 1:numel(useIdx)
    filesUsed{i,j} = sprintf('%s/%s/%s', ...
                             dataPath, classDir{i}, ...
                             fileNames{useIdx(j)});
  end
  
end

xSpacing = 400;
ySpacing = -400;

figure
for i = 1:numel(classDir)
  for j = 1:nOfEach
    r = RGCmorph(filesUsed{i,j});
    xCenter = i*xSpacing;
    yCenter = j*ySpacing;
    r.drawNeuron(1,0,[xCenter yCenter 0]);
  end
end
   
plot3(xCenter(1)+[0 100],yCenter(1) -150*[1 1],[0 0],'k-','linewidth',2)
axis off
title([])

for i = 1:numel(classDir)
  t(i) = text(400*i,-150,classDir{i},'fontsize',18);
  set(t(i),'horizontalalignment','center')
end


printA4('FIGS/ExampleMorphologies.eps');

fid = fopen('FIGS/ExampleMorphologies.txt','w');

for i = 1:size(filesUsed,1)
  for j = 1:size(filesUsed,2)
    fprintf(fid,'%s\n', filesUsed{i,j});
  end
end

fclose(fid)