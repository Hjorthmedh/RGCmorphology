% This code picks five of Sumbuls seven RGC types and checks
% classification performance

clear all, close all


pickMask = unique(perms([1 1 1 1 1 0 0]),'rows');

% Loop through all possible combinations of 5 types
for i = 1:size(pickMask,1)

  fprintf('%d/%d\n', i, size(pickMask,1))
  
  r = RGCclass(0);
  r.lazyLoad('knownSumbul');
  
  classIdx = find(pickMask(i,:));

  useTypes = r.RGCuniqueNames(classIdx);
  
  useIdx = ismember(r.RGCtypeName,useTypes);
  
  r.RGC = r.RGC(useIdx);
  
  r.updateTables(r.featuresUsed);

  [corr(i),corrSD(i)] = r.benchmark(10);
  
end

fprintf('Correct: %.2f +/- %.2f (mean +/- SD)\n', 100*mean(corr),100*std(corr))


% fprintf('Correct: %.2f +/- %.2f\n', 100*mean(corr),100*std(corr)/sqrt(numel(corr)))


