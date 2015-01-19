function verifyMeasuresTreeToolbox(obj)

  % This function calculates the measures using the tree toolbox and
  % compares them to the internally calculated measures

  results = obj.calculateMeasures(false);
  
  disp('Before running this you need to do start_tree')
  disp('The function is in the tree toolbox')
  
  tree = obj.makeTreeObject(false);
  
  % Now we got the tree loaded in the toolbox, lets calculate some measures.
  
  disp(['Please note: Tree toolbox includes soma in tree, we dont. ' ...
        'They also assume only two children at each branch point, ' ...
        'but some have three.'])
  
  tAngles = angleB_tree(tree);
  fprintf('Mean branch angle: %.2f (%.2f)\n', ...
           results.meanBranchAngle, nanmean(tAngles))
  
  lenTree = sum(len_tree(tree));
  fprintf('Total dendritic arbor length: %.2f (%.2f)\n', ...
          results.totalDendriticLength, lenTree)
  disp(['- Tree toolbox needs soma centre coord, our algorith starts from edge of soma.'])
  
  numBranches = sum(B_tree(tree))*2+1;
  fprintf(['Number of segments: %d (%d)\n' ...
           '- Tree toolbox assumes each branchpoint has two children, not true!\n'], ...
          results.numSegments,numBranches)
  
  numTips = sum(T_tree (tree));
  fprintf('Number of leaves: %d (%d)\n', ...
          results.numLeaves, numTips)
  
  % http://www.treestoolbox.org/manual/obtaining_some_statistics.html
  % vhull_tree does not compute what we want...
  %
  % [a b c area] = vhull_tree (tree,[],[],[],[],'-2d');
  % surfArea = sum(area);
  %
  % fprintf('Dendritic field: %.2f (%.2f)\n', ...
  %         results.dendriticField, surfArea)
  
  % Number of end points for branch children, N1/(N1+N2), N1 <= N2
  % Because we can have 3 branchest, I prefer to have N2/(N1+N2)
  branchAssymetry = nanmean(asym_tree (tree));
  fprintf('Branch assymtery: %.3f (%.3f)\n', ...
          results.branchAssymetry, ...
          1-branchAssymetry)
  
  numBranchPoints = sum(B_tree (tree));
  fprintf('Branch points: %d (%d)\n', ...
          results.numBranchPoints, ...
          numBranchPoints)
  
  keyboard
  
end