% This function returns a object which should be compatible with
% the tree toolbox, to allow us to verify our measures.

function [tree,MTRname] = makeTreeObject(obj,saveFlag)

  if(~exist('saveFlag'))
    saveFlag = false;
  end
  
  % treePath = '../TREES1.15';
  
  tree.dA = sparse([]);

  tree.X = obj.xSoma;
  tree.Y = obj.ySoma;
  tree.Z = obj.zSoma;
  
  tree.R = [];
  
  tree.D = [];
  
  tree.rnames = {'Neuron'};
  
  tree.Ri = 100;  % Value taken from example in the trees manual (p23)
  tree.Gm = 5e-4; % ditto
  tree.Cm = 1;    % ditto
  tree.name = strrep(obj.xmlFile,'.xml','');
  
  pID = 1;
  nID = 2;
  
  for k = 1:numel(obj.dendrite)
    
    nID = addBranch(obj.dendrite(k),pID,nID);
    
  end
  
  % Make sure dA matrix is square
  nDim = max(size(tree.dA));
  tree.dA(nDim,nDim) = 0;
  
  % curDir = pwd;
  % cd(treePath)

  try
    tree = sort_tree(tree);
  catch e
    disp('Did you forget to run start_trees before calling this command')
    keyboard
  end
    
  % cd(curDir)
  
  if(saveFlag)
    MTRname = saveMTR();
  else
    MTRname = [];
  end
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function nextID = addBranch(branch,parentID,nextID)
  % branch
  % keyboard
    
    % Add all elements of the branch
    for i = 1:size(branch.coords,1)
      tree.dA(nextID,parentID) = 1;
      tree.X(nextID,1) = branch.coords(i,1);
      tree.Y(nextID,1) = branch.coords(i,2);
      tree.Z(nextID,1) = branch.coords(i,3);      
      tree.D(nextID,1) = branch.diameter(i);

      tree.R(nextID,1) = 1; % Region ID, ignore.
      
      parentID = nextID;
      nextID = nextID + 1;
    end

    for j = 1:numel(branch.branches)
      nextID = addBranch(branch.branches(j),parentID,nextID);
    
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function fName = saveMTR()
    
    if(~exist('MTR'))
      mkdir('MTR');
    end
    
    fName = sprintf('MTR/%s.mtr', tree.name);
    fprintf('Writing %s\n', fName)
    save(fName,'tree');
    
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end