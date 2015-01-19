clear all, close all

cacheFile = 'SAVE/cache/NeurolucidaCache.mat';
loadCache = true;

if(~exist(cacheFile) | ~loadCache)

  % These are located on the external harddisk
  fileBasePath = '/Volumes/For future use/DATA/RanaEldanaf/LSM';

  % I have just randomly picked five cells here
  files = {'CB2/CB2-T4-R2-07092012-cell3-40x-08zoom.lsm', ...
           'Cdh3/Cdh3-07172012-a1r1-cell1-40x-0.lsm', ...
           'DRD4/P30-DRD4-07102012-a1r1-cell2-40x-0.lsm', ...
           'Hoxd10/Hoxd10-none-righteyecontrol-04292013-40x-cell3.lsm', ...
           'TRHR/P34TRHR-02242012-R1C2-40x.lsm'};

  cellType = {'CB2','Cdh3','DRD4','Hoxd10','TRHR'};

  for i = 1:numel(files)
  
    r(i) = RGCmorph();
    r(i).readLSM(files{i},fileBasePath);
  
    img{i} = sum(sum(double(r(i).lsm.image),3),4);
    r(i).lsm.image = [];
    
  end

  save(cacheFile,'r','img','cellType','files','fileBasePath');
  
else
  fprintf('Loading: %s\n', cacheFile)
  tmp = load(cacheFile);
  r = tmp.r;
  img = tmp.img;
  cellType = tmp.cellType;
  files = tmp.files;
  fileBasePath = tmp.fileBasePath;
end
  
figure
set(gcf,'paperunits','centimeters')
set(gcf,'units','centimeters')
set(gcf,'papersize',[18 15])
set(gcf,'paperposition',[1 1 16 13])


for i = 1:numel(files)
  p(i) = subplot(1,5,i);

  imshow(img{i},[0 max(img{i}(:))]);
  hold on
  len = 100e-6/r(i).lsm.xyRes;
  plot(100 + [0 len],100*[1 1],'color',[1 1 1],'linewidth',2)
  
  
  totalHeight(i) = size(img{i},1)*r(i).lsm.xyRes;
  totalWidth(i) = size(img{i},2)*r(i).lsm.xyRes;
  
  title(cellType{i});
  
end

for i = 1:numel(files)
  pos = get(p(i),'position');
  scale = totalWidth(i)/max(totalWidth);
  pos(3) = pos(3)*scale;
  set(p(i),'position',pos);
end

align(p,'verticalalignment','bottom')

align(p,'horizontalalignment','left')

printA4('FIGS/Neuroludica-images.eps')

% Make sure all are shown at the same scale!

