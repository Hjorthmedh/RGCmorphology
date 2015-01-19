% If nOfEach is negative, then we are going to use all data for
% training, except abs(nOfEach) of each type.

function usedAll = setRandomTrainingSet(obj,nOfEach)

  if(nOfEach > 0)
    fprintf('Using %d cells of each subtype for training.\n', nOfEach)
  else
    fprintf('Leaving %d cells out of training for each subtype.\n',-nOfEach)
  end
  
  classIDs = unique(obj.RGCtypeID);

  newIdx = [];
  usedAll = false; % If we used all cells of a type for training
  
  for iID = 1:numel(classIDs)
    candidateIdx = find(obj.RGCtypeID == classIDs(iID));
    perm = randperm(numel(candidateIdx));
    
    if(nOfEach > 0)
    
      nUsed = min(nOfEach,numel(candidateIdx));
    
      if(nOfEach >= numel(candidateIdx))
        % Bad, we are using all cells of this type for training 
        usedAll = true;
      
        fprintf('Warning: %s: %d/%d\n', ...
                obj.RGC(candidateIdx(1)).typeName, ...
                nOfEach, numel(candidateIdx))
      end
    else
      
      nUsed = numel(candidateIdx) - abs(nOfEach);
      
      if(nUsed <= 0)
      
        disp(['You have asked to leave aside too many... no data ' ...
              'left for training'])
        keyboard
      end
        
    end
      
      
    try
      newIdx = [newIdx; candidateIdx(perm(1:nUsed))];
    catch e
      getReport(e)
      keyboard
    end
      
  end

  obj.trainingIdx = newIdx;

  if(usedAll)
    disp('Warning used all data of at least one cell type for training.')
  end
  
end