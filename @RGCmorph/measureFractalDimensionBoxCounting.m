% Ref: T.G. Smith, Jr, G. D. Lange and W.B. Marks
% Fractal methods and results in cellular morphology -- dimensions
% lacunarity and multifractals
% J Neurosci Methods 1996

function D = measureFractalDimensionBoxCounting(obj)

  disp('Calculating fractal dimension, using box counting')

  coords = obj.parseDendrites(@obj.allCoords);
  
  % Get largest side
  maxC = max(coords,[],1);
  minC = min(coords,[],1);
  maxLen = max(maxC-minC);
  
  % We use this for our stop condition
  nUniqueCoords = size(unique(coords,'rows'),1);
  
  done = false;
  len = maxLen*1.001; % To make sure entire structure fits within box
  oneCol = ones(size(coords,1),1);
  allOne = ones(size(coords));
  lenChange = 0.9;
  
  nNonEmpty = [];
  magnification = [];
  
  while(~done)
    
    if(0)
      
      for i = 1:10
        coarseCoords = floor(rand(1) + (coords - oneCol*minC) ./ (allOne * len));
        nUnique = size(unique(coarseCoords,'rows'),1);
    
        magnification(end+1,1) = maxLen/len;
        nNonEmpty(end+1,1) = nUnique;
      end
    else
      
      coarseCoords = floor((coords - oneCol*minC) ./ (allOne * len));
      nUnique = size(unique(coarseCoords,'rows'),1);
    
      magnification(end+1,1) = maxLen/len;
      nNonEmpty(end+1,1) = nUnique;      
    end

    % Shrink our length scale for next iteration
    len = len * lenChange;
    
    if(nUnique >= 0.5*nUniqueCoords)
      done = true;
    end
  end
  
  P = polyfit(log(magnification),log(nNonEmpty),1);
  
  D = P(1);
  
  if(0)
    % Debug plot
    
    figure
    loglog(magnification,nNonEmpty,'r*')
    hold on
    loglog(magnification,exp(polyval(P,log(magnification))),'k-')
    xlabel('Magnification')
    ylabel('Log(#Non-empty boxes)')
    title(sprintf('D = %.2f', D))
    
  end
  
end