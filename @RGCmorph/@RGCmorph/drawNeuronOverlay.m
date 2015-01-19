function drawNeuronOverlay(obj)

  if(isempty(obj.lsm))
    disp('No LSM image loaded, or it has been unloaded')
    return
  end
  
  figure('name',sprintf('Neuron %s', obj.xmlFile))
  img = double(max(obj.lsm.image,[],4));
  for i = 1:3
    img(:,:,i) = img(:,:,i) / max(max(img(:,:,i)));
  end

  imshow(img, ...
         'xdata', [0 obj.lsm.xyRes*size(obj.lsm.image,2)*1e6], ...
         'ydata', [0 -obj.lsm.xyRes*size(obj.lsm.image,1)*1e6])
  
  hold on
  obj.drawNeuron(0);
  
  
  xNum = size(img,2);
  yNum = size(img,1);
  
  xyz = obj.parseDendrites(@allCoords);
    
  % Here we are ignoring the Z-coordinate
  x = xyz(:,1);
  y = xyz(:,2);
    
  idx = convhull(x,y);

  % Dendritic field extent
  x = x(idx)/(obj.lsm.xyRes*1e6);
  y = yNum + y(idx)/(obj.lsm.xyRes*1e6);

  % Evil, poly2mask takes yDim before xDim, but x before y
  mask = uint16(poly2mask(x,y,yNum,xNum));
  
  % But subtract the soma
  xCont = [];
  yCont = [];
  for i = 1:numel(obj.somaContours)
    xCont = [xCont; obj.somaContours{i}(:,1)];
    yCont = [yCont; obj.somaContours{i}(:,2)];
  end
  
  idx = convhull(xCont,yCont);  
  xCont = xCont(idx)/(obj.lsm.xyRes*1e6);
  yCont = yNum+yCont(idx)/(obj.lsm.xyRes*1e6);
  
  maskSoma = uint16(poly2mask(xCont,yCont,yNum,xNum));
  
  imgMask = img(end:-1:1,:,:);
  
  for i = 1:3
    try
      imgMask(:,:,i) = (imgMask(:,:,i) ...
                        + double(mask-maskSoma) .* imgMask(:,:,i))/2;
    catch e
      getReport(e)
      keyboard
    end
  end
  
  figure('name',sprintf('Neuron %s', obj.xmlFile)), imshow(imgMask)
  
  if(0)
    % This is done in detectVAchT band
    
    obj.VAChT = zeros(size(obj.lsm.image,4),1);
    obj.zCoord = -(0:numel(obj.VAChT)-1)*obj.lsm.zRes*1e6;
  
    for i = 1:numel(obj.VAChT)
      obj.VAChT(i) = sum(sum(obj.lsm.image(:,:,3,i) .* mask));
    end
  
  
    [peakVal, peakIdx] = findpeaks(obj.VAChT);
  
    figure('name',sprintf('Neuron %s', obj.xmlFile))
    plot(obj.zCoord,obj.VAChT,'k-', ...
         obj.zCoord(peakIdx), obj.VAChT(peakIdx), 'r*');
    title(obj.filename)
    xlabel('Z depth')
    ylabel('Intensity')
  
    obj.VAChTpeaks = obj.zCoord(peakIdx);
  end


  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = allCoords(branch,res)

    res = [res; branch.coords];
  
  end  
  
end