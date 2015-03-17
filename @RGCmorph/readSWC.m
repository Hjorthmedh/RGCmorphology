function readSWC(obj,filename,dataDir)

  % Debug thingy
  prevBranchStartIdx = [];

  
  % It is not really a XML file, but a lot of code already uses
  % that name and now I want to read in SWC files also.
  obj.xmlFile = filename;
  obj.xmlDir = dataDir;
  
  obj.somaContours = {};
  obj.axon = [];
  obj.dendrite = [];
  
  fprintf('Loading neuron: %s\n', filename)
  
  if(~isempty(dataDir))
    fName = sprintf('%s/%s',dataDir,filename);
  else
    fName = filename;
  end

  fid = fopen(fName,'r');
  
  str = fgets(fid);
  
  somaID = NaN;
  
  % Start by reading everything in
  
  ctr = 1;
  
  while(str ~= -1)
    
    if(str(1) == '#')
      % Skip line if begining with #
      str = fgets(fid);
      continue;
    end
    
    % label type x y z R parent
    str = strrep(str,',','');
    c = textscan(str,'%d %d %f %f %f %f %d');
    
    try 
      itemLabel(ctr,1) = c{1}; 
      itemType(ctr,1)  = c{2}; % This does not appear to be used
      xCoord(ctr,1)    = c{3};
      yCoord(ctr,1)    = c{4};
      zCoord(ctr,1)    = c{5};
      radius(ctr,1)    = c{6};
      parent(ctr,1)    = c{7};
    catch e
      getReport(e)
      keyboard
    end
      
    % This should be equal
    assert(itemLabel(ctr,1) == ctr);

    % fprintf('%d : (%.2f,%.2f,%.2f)\n', ctr, xCoord(ctr),yCoord(ctr),zCoord(ctr))    
    
    ctr = ctr + 1;
    
    str = fgets(fid);

  end
  
  rowUsed = zeros(size(xCoord));
  
  % Time to parse everything
  
  % Save soma
  somaIdx = find(parent == -1);
  assert(itemType(somaIdx) == 0 | itemType(somaIdx) == 1);
  
  obj.xSoma = xCoord(somaIdx);
  obj.ySoma = yCoord(somaIdx);
  obj.zSoma = zCoord(somaIdx);  
  
  rowUsed(somaIdx) = 1;
  
  % Find all branch points
  sParent = sort(parent);
  allParentIdx = unique(sParent(find(diff(sParent) == 0)));
  
  % Find all branches
  primBranchIdx = find(parent == itemLabel(somaIdx));
    
  for iPrim = 1:numel(primBranchIdx)
    
    [primBranch, branchType] = parseTree(primBranchIdx(iPrim),0,0);
  
    % 0 = undefined
    % 1 = soma
    % 2 = axon
    % 3 = dendrite
    % 4 = apical dendrite
    % 5 = fork point
    % 6 = end point
    % 7 = custom
    
    switch(branchType)
      case {0,3,4}
        if(isempty(obj.dendrite))
          obj.dendrite = primBranch;
        else
          obj.dendrite(end+1) = primBranch;
        end
      case {2}
        if(isempty(obj.axon))
          obj.axon = primBranch;
        else
          obj.axon(end+1) = primBranch;
        end
      case {1}
        if(isempty(primBranch.branches) & size(primBranch,1) <= 1)
          % Just skip this, orphaned branch that is empty
          disp('Orphaned branch')
        else
          fprintf('Something fishy with the input branch')
          keyboard
        end
        
      otherwise
       fprintf('The itemType %d is currently not supported\n', ...
               itemType(primBranchIdx(iPrim)))    
       keyboard
    end
  end
  
  try
    assert(all(rowUsed))
  catch e
    % This checks that we did not miss any rows
    getReport(e)
    keyboard
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  function [tree, branchType, allSegmentType] = parseTree(branchStartIdx,somaDist,branchOrder)

    if(0)
      fprintf('parseTree called: branchStartIdx = %d, somaDist = %.2f, branchOrder = %d\n', ...
              branchStartIdx, somaDist, branchOrder)
    end
    
    try 
      assert(~ismember(branchStartIdx,prevBranchStartIdx))
    catch e
      getReport(e)
      keyboard
    end
    
    % Just save variable for later debug check
    prevBranchStartIdx(end+1) = branchStartIdx;
    
    % somaDist is the distance to the soma for the proximal end of the branch
    tree = struct('coords',[],'diameter',[],'branches',[],'somaDist',0,'branchOrder',0);

    % Follow the branch until the next branch point, and then
    % trigger two new parseTree from that point
        
    putativeBranchEndIdx = allParentIdx(find(allParentIdx >= branchStartIdx,1,'first'));
    if(isempty(putativeBranchEndIdx))
      putativeBranchEndIdx = numel(xCoord);
    end
    
    % Need to make sure that all are connected
    try
      branchEndIdx = branchStartIdx;
      while(branchEndIdx < putativeBranchEndIdx & parent(branchEndIdx+1) == branchEndIdx)
        branchEndIdx = branchEndIdx + 1;
      end
    catch e
      getReport(e)
      keyboard
    end
      
    % Just an idiot check for me
    assert(numel(branchEndIdx) == 1)
    
    segIdx = branchStartIdx:branchEndIdx;
    
    
    % if(branchEndIdx < putativeBranchEndIdx)
    %   disp('Check why...') % Seems legit
    %   keyboard
    % end
   
    try
      % This checks that we dont use a row twice
      assert(~all(rowUsed(segIdx)))
    catch e
      getReport(e)
      keyboard
    end
    
    xSeg = xCoord(segIdx);
    ySeg = yCoord(segIdx);
    zSeg = zCoord(segIdx);
    rSeg = radius(segIdx);
    
    rowUsed(segIdx) = 1;
    
    tree.coords = [xSeg,ySeg,zSeg];
    tree.diameter = 2*rSeg;
    
    len = sum(sqrt(diff(xSeg).^2 + diff(ySeg).^2 + diff(zSeg).^2));
    tree.somaDist = somaDist + len;
    tree.branchOrder = branchOrder + 1;
        
    % Find all branches that has the end point as parent, and parse them
    childIdx = find(parent == branchEndIdx);    
    
    childSegType = {};
    for iChild = 1:numel(childIdx)      
      
      [branch,branchType,childSegType{iChild}] = parseTree(childIdx(iChild),tree.somaDist,tree.branchOrder);
      
      try
        if(isempty(tree.branches))
          tree.branches = branch;
        else
          tree.branches(end+1) = branch;
        end
      catch e
        getReport(e)
        keyboard
      end
    end
      
    % Most common itemType as the type of branch, sometimes first element can be marked as soma, 
    % want to avoid that screwing things up. Also branch points might get other itemType values
    allSegmentType = itemType(segIdx);
    for iChild = 1:numel(childSegType)
      allSegmentType = [allSegmentType;childSegType{iChild}];
    end
    branchType = mode(allSegmentType);
    
    % if(branchType == 1)
    %   disp('For some reason branchType is 1 = soma')
    %   keyboard
    % end
    
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
end