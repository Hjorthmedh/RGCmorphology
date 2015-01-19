% This script calculates the probablity that if you randomly guess
% which neuron it is (based on the proportions of cells of each
% type) that you get it right.

clear all, close all

r = RGCclass(0);
r.lazyLoad();

nClasses = 5;
nCells = numel(r.RGC);

nOfType = zeros(nClasses,1);

for i = 1:numel(nOfType)
  nOfType(i) = nnz(r.RGCtypeID == i);
end

cumN = cumsum(nOfType);

Pcorrect = sum((nOfType/nCells).^2);
Pincorrect = 1 - Pcorrect;

% Verify

nRep = 1000000;
corrUniform = 0;
corrProportional = 0;

guessCountUniform = zeros(nClasses,1);
guessCountProportional = zeros(nClasses,1);

fprintf('Doing %d repetitions\n')

for i = 1:nRep
  idx = ceil(nCells*rand(1));
  
  IDguessUniform = ceil(nClasses*rand(1));
  IDguessProportional = find(rand(1)*nCells <= cumN,1,'first');
  
  guessCountUniform(IDguessUniform) = guessCountUniform(IDguessUniform) +1;
  guessCountProportional(IDguessProportional) = guessCountProportional(IDguessProportional) + 1;
  
  if(IDguessUniform == r.RGCtypeID(idx))
    corrUniform = corrUniform + 1;
  end
  
  if(IDguessProportional == r.RGCtypeID(idx))
    corrProportional = corrProportional + 1;
  end
  
end

fprintf('Theoretical: %.2f %%\n', Pcorrect*100)

fprintf('P proportional (%d rep): %.2f %%\n', ...
        nRep, corrProportional / nRep *100)

fprintf('P uniform (%d rep): %.2f %%\n', ...
        nRep, corrUniform / nRep * 100)


