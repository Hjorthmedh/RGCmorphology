  function s = blindScore(obj,blindLabels,realLabels)

    % Note that the labels might be permuted, we are only interested
    % in that the cells are grouped with members of the own type
    
    % Lets calculate the score so that for each cell you get one
    % point for each other cell with the same genetic label that was
    % classified in the same class as it.
    
    nLabels = max(realLabels);
    nBlindLabels = max(blindLabels);
    
    sMat = zeros(nBlindLabels,nLabels);
    
    for i = 1:numel(realLabels)
      
      sMat(blindLabels(i),realLabels(i)) = ...
          sMat(blindLabels(i),realLabels(i)) + 1 ;
      
    end
    
    % This just counted buddies in same group
    % s = sum(sMat(:).*(sMat(:)-1)/2);

    s = 0; % score
    
    for realIdx = 1:nLabels
      for blindIdx = 1:nBlindLabels
       
        for i = 1:nLabels
          if(i == realIdx)
            s = s + sMat(blindIdx, realIdx)*sMat(blindIdx, realIdx);
          else
            s = s - sMat(blindIdx,i)*sMat(blindIdx,realIdx);
          end
        end
        
      end
    end
    
  end