%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function L = elinkage(y, alpha)
%ELINKAGE Minimum energy clustering for Matlab
%
% y      data matrix with observations in rows, 
%        or distances produced by pdist
% alpha  power of Euclidean distance, 0<alpha<=2
%        default alpha=1
%
% Agglomerative hierarchical clustering by minimum 
% energy method, using L-W recursion, for Matlab 7.0.
% See the contributed package "energy" for R, and its 
% reference manual, for details:
% http://cran.us.r-project.org/src/contrib/PACKAGES.html
% http://cran.us.r-project.org/doc/packages/energy.pdf
% Reference: 
% Szekely, G.J. and Rizzo, M.L. (2005), Hierarchical 
% clustering via joint between-within distances: 
% extending Ward's minimum variance method, Journal 
% of Classification, Vol. 22 (2).
% Email:
% gabors @ bgnet.bgsu.edu, mrizzo @ bgnet.bgsu.edu
% Software developed and maintained by: 
%     Maria Rizzo, mrizzo @ bgnet.bgsu.edu                    
% Matlab version 1.0.0 created: 12-Dec-2005    
% License: GPL 2.0 or later

%%% initialization
if nargin < 2
    alpha = 1.0;
end;

%%% if n==1, y is distance, output from pdist()
[n, d] = size(y);            %n obs. in rows
if n == 1  %distances in y
    ed = 2 .* squareform(y) .^alpha;
else       %data matrix
    ed = 2 .* (squareform(pdist(y)).^alpha);
end;
n = length(ed);
clsizes = ones(1, n);        %cluster sizes
clindex = 1:n;               %cluster indices
L = zeros(n-1, 3);           %linkage return value
nclus = n;

for merges = 1:(n-2);

    %find clusters at minimum e-distance  
    b = ones(nclus, 1) .* (ed(1,2) + 1);
    B = ed + diag(b);
    [colmins, mini] = min(B);
    [minmin, j] = min(colmins);
    i = mini(j);
    
    %cluster j will be merged into i
    %update the linkage matrix
    L(merges, 1) = clindex(i);
    L(merges, 2) = clindex(j);
    L(merges, 3) = ed(i, j);
    
    %update the cluster distances
    m1 = clsizes(i);
    m2 = clsizes(j);
    m12 = m1 + m2;
    
    for k = 1:nclus;
    	if (k ~= i && k ~= j);	
    	    m3 = clsizes(k);
            m = m12 + m3;
            ed(i, k) = ((m1+m3)*ed(i,k) + (m2+m3)*ed(j,k) - m3*ed(i,j))/m;
            ed(k, i) = ed(i, k);
        end; 
    end;
    
   
    %update cluster data, merge j into i and delete j
    ed(j, :) = [];
    ed(:, j) = [];
    clsizes(i) = m12;
    clsizes(j) = [];
    clindex(i) = n + merges;
    clindex(j) = [];
    nclus = n - merges;
    
    %order the leaves so that ht incr left to right
    if L(merges, 1) > L(merges, 2);
        ij = L(merges, 1);
        L(merges, 1) = L(merges, 2);
        L(merges, 2) = ij;
    end;
end;

%handle the final merge
L(n-1, :) = [clindex(1), clindex(2), ed(1, 2)];
if L(n-1, 1) > L(n-1, 2);
    ij = L(n-1, 1);
    L(n-1, 1) = L(n-1, 2);
    L(n-1, 2) = ij;
end;
