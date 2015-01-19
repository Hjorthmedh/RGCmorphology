function dendriticVAChT = measureDendriticVAChTstaining(obj)

  debugFigs = false;
  outsideFlag = 0;
  
  % We need the LSM info, so if not loaded, reload it
    
  if(isempty(obj.lsm))
    obj.readLSM(obj.lsmFile,obj.lsmDir);
    
    if(isempty(obj.lsm))
      % Read failed
      disp('Unable to read LSM file, not calculating VAChT measures')
      dendriticVAChT = NaN;
      return
    end
    
    clearLSM = true;
  else
    clearLSM = false;
  end
  
  xDim = size(obj.lsm.image,2);
  yDim = size(obj.lsm.image,1);
  zDim = size(obj.lsm.image,4);
  
  % Use the VAChT functions to get x,y,z coordinates
  v = VAChT();
  

  if(debugFigs)
    v.rgc = obj;
    v.downScaling = [];
    v.calculateCoords();
    obj.drawNeuron, hold on
    xlabel('x'), ylabel('y'), zlabel('z')
    maxVal = double(max(max(max(obj.lsm.image(:,:,v.VAChTchannel,:)))));
  end
  
  
  % For each dendrite, calculate the average VAChT staining

  function res = intensity(branch, res)    

    if(isempty(res))
      res = [0 0];
    end
        
    % 1. Find coordinates of the dendrites

    % 2. Transform coordinates to LSM coordinates      
    xPos = floor(branch.coords(:,1) / obj.xScaleXML) + 1;
    yPos = floor(-branch.coords(:,2) / obj.yScaleXML) + 1;
    zPos = floor((branch.coords(:,3) - obj.zCoordsXML(1)) / ...
                 (obj.zCoordsXML(2) - obj.zCoordsXML(1))) + 1;    
    
    % !!! Verify conversion
  
    for i = 1:numel(xPos)-1
    
      xDist = abs(xPos(i+1) - xPos(i));
      yDist = abs(yPos(i+1) - yPos(i));
      zDist = abs(zPos(i+1) - zPos(i));      
      
      
      if(xDist >= max(yDist,zDist))
        % x dominating axis
        
        nSteps = xDist+1;
                
      elseif(yDist >= zDist)
        % y dominating axis
        
        nSteps = yDist+1;
        
      else
        % z dominating axis
        
        nSteps = zDist+1;
        
      end

      % 3. Find all pixels under the lines      
      x = round(linspace(xPos(i),xPos(i+1),nSteps));
      y = round(linspace(yPos(i),yPos(i+1),nSteps));
      z = round(linspace(zPos(i),zPos(i+1),nSteps));      
      
      % Skip first pixel, to avoid double counting
      res(2) = res(2) + numel(x) - 1; % pixel count
      
      for j = 2:numel(x)
        % Pixel value sum (obs, coords are y,x,z in that order)
        try
          if(1 <= x(j) & x(j) <= xDim ...
             & 1 <= y(j) & y(j) <= yDim ...
             & 1 <= z(j) & z(j) <= zDim)
          
            res(1) = res(1) + double(obj.lsm.image(y(j),x(j),v.VAChTchannel,z(j)));
          else
            outsideFlag = outsideFlag + 1;
            res(2) = res(2) - 1; % Dont count bad pixel
            
            if(outsideFlag == 1)
              fprintf('!!! Trace outside image: %s\n', obj.xmlFile)
            end
          end
        catch e
          getReport(e)
          keyboard
        end
      end

      if(debugFigs)
        % Convert the coordinates back to real coordinate system,
        % then plot them in space. Compare to the old plot function.
        for k = 1:numel(x)
          if(1 <= x(k) & x(k) <= xDim ...
             & 1 <= y(k) & y(k) <= yDim ...
             & 1 <= z(k) & z(k) <= zDim)
            plot3(v.X(y(k),x(k),z(k)),v.Y(y(k),x(k),z(k)),v.Z(y(k),x(k),z(k)), '.',  ...
                  'color', [1 0 0]*double(obj.lsm.image(y(k),x(k),v.morphChannel,z(k)))/maxVal + [0 0 1]);
          else
          end
            
        end
        % keyboard
      end
      
    end
      
  end
    
  res = obj.parseDendrites(@intensity);
  VAChTsum = res(1);
  pixelCount = res(2);
  
  img = double(obj.lsm.image(:,:,v.VAChTchannel,:));
  % refVAChT = prctile(img(:),90); % Use upper 90% percentile as reference.
  refVAChT = max(img(:)); 

  % How is the dendritic VAChT staining compared to average in
  % entire slice. Higher, lower?
  dendriticVAChT = (VAChTsum / pixelCount) / refVAChT;
  % keyboard
  % Clear LSM if it did not exist before entering function
  
  if(clearLSM)
    obj.lsm = [];
  end
    
end