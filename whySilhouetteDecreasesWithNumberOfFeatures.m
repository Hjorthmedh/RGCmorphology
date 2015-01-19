%
% Silhouette value was found to decrease with the number of
% features. My intuition says that this is because the first few
% features had good separation, later features are uncorrelated.

close all, clear all

n = 100;

class = [ones(n,1);2*ones(n,1)];

pAx = 2*randn(n,1);
pBx = 3 + 2*randn(n,1);

pAy = randn(n,1);
pBy = randn(n,1);

P1 = [pAx;pBx];
P2 = [pAx,pAy;pBx,pBy];

figure
silhouette(P1,class)
s1 = mean(silhouette(P1,class))
figure
silhouette(P2,class)
s2 = mean(silhouette(P2,class))

