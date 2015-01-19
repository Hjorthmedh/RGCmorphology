function [stratificationDepth,biStratificationDistance,debugInfo] = getStratification(obj,debugPlot)

  if(~exist('debugPlot') | isempty(debugPlot))
    debugPlot = false;
  end
  
  % We might want to find the plane of stratification, for now we
  % just use Z-axis

  useDiameter = false;
    
  % This function uses calcDendHist to get the histogram
  zAxis = [0; 0; 1];

  if(~isempty(obj.zCoordsXML))    
    planeDist = abs(median(diff(obj.zCoordsXML)));
  else
    allCoords = obj.parseDendrites(@obj.allCoords);
    uniqueZ = unique(allCoords(:,3));
    planeDist = median(diff(uniqueZ));
  end
    
  [dendBinCount,dendBinCenters] = obj.calcDendHist(zAxis,[],[],[],planeDist);
  
  % Calculate bistratification distance
  biStratificationDistance = calcStratDepth(dendBinCount,dendBinCenters);

  stratificationDepth = obj.parseDendrites(@centreOfMass);
  stratificationDepth = stratificationDepth(1); % Only keep first value
  
  debugInfo.dendBinCount = dendBinCount;
  debugInfo.dendBinCenters = dendBinCenters;
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function biStratDist = calcStratDepth(binCount,binCenters)

    
    nTest = 50;
    betaCandidates = zeros(6,nTest);
    missmatch = zeros(1,nTest);

    % Initialise start values
    % Rand mu1, mu2
    betaCandidates(1:2,:) = min(binCenters) + rand(2,nTest)*(max(binCenters)-min(binCenters)); 
    % Rand sigma1, sigma2
    betaCandidates(3:4,:) = rand(2,nTest)*(max(binCenters)-min(binCenters))/3;
    % rand alpha1, alpha2
    betaCandidates(5:6,:) = max(binCount);

    % Turn off warnings !!
    warning('off','MATLAB:rankDeficientMatrix');
    warning('off','stats:nlinfit:ModelConstantWRTParam');
    warning('off','stats:nlinfit:IterationLimitExceeded');
    warning('off','stats:nlinfit:IllConditionedJacobian');
    
    for i = 1:nTest

      betaCandidates(:,i) = nlinfit(dendBinCenters,dendBinCount,@modelFunc,betaCandidates(:,i));
    

      % Only allow positive alphas (see modelFunc)
      betaCandidates(3:6,:) = abs(betaCandidates(3:6,:));
      
      missmatch(i) = sum(abs(binCount - modelFunc(betaCandidates(:,i),binCenters)));
    end
    
    % Turn warnings back on!!
    warning('on','MATLAB:rankDeficientMatrix');
    warning('on','stats:nlinfit:ModelConstantWRTParam');  
    warning('on','stats:nlinfit:IterationLimitExceeded');  
    warning('on','stats:nlinfit:IllConditionedJacobian');    

    % Which of the fits was best
    [~,minIdx] = min(missmatch);
    
    % Calculate bistratification distance for that case
    % biStratDist = abs(betaCandidates(1,minIdx) - betaCandidates(2,minIdx));

    % Normalise it by the largest standard deviation of gaussians
    biStratDist = abs((betaCandidates(1,minIdx) - betaCandidates(2,minIdx)) ...
        / max(betaCandidates(3:4,minIdx)));    
    
    debugInfo.fitted = betaCandidates(:,minIdx);
    
    if(debugPlot)

      zCoords = obj.parseDendrites(@obj.allCoords);
      zCoords = zCoords(:,3) - obj.zSoma;
      uniqueZcoords = unique(zCoords);
        
      figure
      subplot(3,1,1)
      p = plot(uniqueZcoords,zeros(size(uniqueZcoords)),'ko', ...
               obj.zCoordsXML - obj.zSoma,ones(size(obj.zCoordsXML)),'ro', ...
               dendBinCenters,0.5*ones(size(dendBinCenters)),'b*');
      legend(p,'Unique z-coords','XML z coords','Bin centers','location','eastoutside')
      a = axis();
      a(3:4) = [-2 2];
      axis(a);
      
      title(obj.xmlFile)
      
      % Debug plot
      subplot(3,1,2), hold on
      plot(binCenters,binCount,'k-', 'linewidth',2)
      for i = 1:nTest
        plot(binCenters,modelFunc(betaCandidates(:,i),binCenters),'r-')
      end

      plot(binCenters,modelFunc(betaCandidates(:,minIdx),binCenters), ...
               'b-', 'linewidth',2)
      
      plot(betaCandidates(1:2,minIdx), ...
           betaCandidates(5:6,minIdx)./sqrt(2.*pi.*betaCandidates(3:4,minIdx).^2),'b*')
      
      title(sprintf('Mismatch: %.1f Bistrat dist: %.1f', ...
                    missmatch(minIdx), biStratDist))
      
      subplot(3,1,3)
      hist(missmatch,100)
      title('Mismatch scores')
      
      fName = sprintf('FIGS/Bistratification-fit-%s.pdf', ...
                      strrep(obj.xmlFile,'.xml',''));
      saveas(gcf,fName,'pdf');
      
    end
      
    % keyboard
    
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

  function y = modelFunc(beta,x)
    
    mu = beta(1:2);
    sigma = beta(3:4);
    alpha = abs(beta(5:6)); % We don't allow negative alphas
    
    y = alpha(1)./sqrt(2*pi*sigma(1)^2) * exp(-(x-mu(1)).^2/(2*sigma(1)^2)) ...
        + alpha(2)./sqrt(2*pi*sigma(2)^2) * exp(-(x-mu(2)).^2/(2*sigma(2)^2));

  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = centreOfMass(branch,res)
    
    if(isempty(res))
      res = zeros(3,1);
    end
    
    x = branch.coords(:,1) - obj.xSoma;
    y = branch.coords(:,2) - obj.ySoma;
    z = branch.coords(:,3) - obj.zSoma;
    
    % Transformed coordinates, along plane normal
    coord = [x,y,z] * zAxis;
    assert(size(coord,2) == 1)
    
    if(useDiameter)
      d = branch.diameter;
    else
      % I saw some problems with thick branches close to soma
      % dominating the tracing.
      d = ones(size(branch.diameter));
    end

    for i = 1:numel(x) - 1
      % Use untransformed coordinates to calculate weight
      len = sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2 + (z(i)-z(i+1))^2);
      weight = len * pi/4*( d(i)^2 + d(i+1)^2 ) / 2;      
      
      res(2) = res(2) + weight*(coord(i) + coord(i+1))/2;
      res(3) = res(3) + weight;

      % Centre of mass
      res(1) = res(2) / res(3);
      
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end