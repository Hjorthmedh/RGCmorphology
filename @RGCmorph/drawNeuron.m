function drawNeuron(obj,draw3D,newFigFlag,offset,drawAxon,lineWidth)
 
  if(~exist('draw3D'))
    draw3D = 1;
  end
  
  if(~exist('newFigFlag'))
    newFigFlag = 1;
  end
  
  if(draw3D & newFigFlag)
    figure('name',sprintf('Neuron %s', obj.xmlFile))
  end
  hold on
  
  if(~exist('offset') | isempty(offset))
    offset = [0 0 0];
  elseif(isnan(offset))
    xyz = obj.parseDendrites(@obj.allCoords);
    offset = -mean(xyz,1);
  else
    xyz = obj.parseDendrites(@obj.allCoords);
    offset = offset - mean(xyz,1);    
  end
  
  if(~exist('drawAxon'))
    drawAxon = true;
  end
  
  if(~exist('lineWidth'))
    lineWidth = 1;
  end
  
  % Draw soma contours
  for i = 1:numel(obj.somaContours)
    n = size(obj.somaContours{i},1);
    
    if(draw3D)
      plot3(offset(1) + obj.somaContours{i}([1:n,1],1), ...
            offset(2) + obj.somaContours{i}([1:n,1],2), ...
            offset(3) + obj.somaContours{i}([1:n,1],3), ...
            'k-','linewidth',lineWidth);
    else
      plot(offset(1) + obj.somaContours{i}([1:n,1],1), ...
           offset(2) + obj.somaContours{i}([1:n,1],2), ...
           'r-','linewidth',lineWidth);
      
    end
  end

  % Draw axon and dendrites
  
  if(drawAxon)
    for i = 1:numel(obj.axon)
      drawTree(obj.axon(i),'-r',[]);
    end
  end
  
  for i = 1:numel(obj.dendrite)
    drawTree(obj.dendrite(i),'k-',[]);
  end
  
  axis equal
  ti = title(obj.xmlFile);
  set(ti,'interpreter','none')
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function drawTree(tree, lineType,parentPoint)

    if(exist('parentPoint') & ~isempty(parentPoint))
      coords = [parentPoint; tree.coords];
    else
      coords = tree.coords;
    end
    
    
    % Im ignoring diameter for now
    if(draw3D)
      plot3(offset(1) + coords(:,1), ...
            offset(2) + coords(:,2), ...
            offset(3) + coords(:,3), lineType,'linewidth',lineWidth);
    else
      plot(offset(1) + coords(:,1), ...
           offset(2) + coords(:,2), '-r','linewidth',lineWidth);
    end
      
    
    for j = 1:numel(tree.branches)
      drawTree(tree.branches(j),lineType,coords(end,:));
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % !!! Check video!
  
end