% This function generates the text file, RGCimageTypeList.txt
% which identifies which genetic line each file is

fid = fopen('RGCimageTypeList.txt','w');

matDir = '/Users/hjorth/DATA/Sumbul/rgc-master';
matFileList = {'warpedArbors1.mat','warpedArbors2.mat','warpedArbors3.mat'};

% Loads arborTraces1, arborTraces2, arborTraces3
tmp1 = load(sprintf('%s/%s', matDir, matFileList{1}));
tmp2 = load(sprintf('%s/%s', matDir, matFileList{2}));
tmp3 = load(sprintf('%s/%s', matDir, matFileList{3}));
     
data = tmp1.arborTraces1;

for i = 1:numel(tmp2.arborTraces2)
  data{end+1} = tmp2.arborTraces2{i};
end

for i = 1:numel(tmp3.arborTraces3)
  data{end+1} = tmp3.arborTraces3{i};
end

clear tmp

for i = 1:numel(data)
  fprintf(fid,'Name: %s Line: %s Cluster: %s\n', ...
          data{i}.id, ...
          data{i}.geneticLine, ...
          data{i}.cluster);
end

fclose(fid)


  