% Shows the image

function plot(obj)

  disp('Plot called')
  figure(obj.fig);
  set(obj.fig,'currentaxes',obj.guiHistogram);
  
  
  % Draw histogram
  cla
  
  try
    bVAChT = bar(obj.VAChTbinCenters,obj.VAChThist/max(obj.VAChThist));
    set(bVAChT,'facecolor',[0 0 0]);
    hold on
    bDend = bar(obj.dendbinCenters,obj.dendHist/max(obj.dendHist));
    set(bDend,'facecolor',[0 0 1]);
    set(get(bDend,'children'),'facealpha',0.8);
  catch e
    getReport(e)
    keyboard
  end
    
  a = axis;
  upperLine = obj.VAChTdUpper;
  lowerLine = obj.VAChTdLower;
  stratLine = obj.stratificationDepth;
  plot(upperLine*[1 1],a(3:4),'r-','linewidth',3)
  plot(lowerLine*[1 1],a(3:4),'r-','linewidth',3)
  plot(stratLine*[1 1],a(3:4),'g-','linewidth',3)
  
  % Plot a 5 micrometer bar
  plot(upperLine + [0 -5],[0 0], 'r-', 'linewidth', 3)
  hold off
  
  if(obj.optimizePlane)
    % Changed the direction of the normal, so that it now matches
    % set(gca,'xdir','reverse')
    xlabel('Z-depth (rotated coordinate system)')
  else
    xlabel('Z-coordinate (shifted, so top of soma at 0)')    
  end
  
  set(obj.fig,'currentaxes',obj.guiNeuron);
  
  % Draw neuron
  
  if(isempty(obj.upperH))
    cla

    obj.rgc.drawNeuron(true,false); % in 3D, but not new fig

    xlabel('x')
    ylabel('y')
    zlabel('z')
    
    % Draw the slices
    img = single(squeeze(obj.rgc.lsm.image(:,:,obj.VAChTchannel,:)));

    [~,somaIdxX] = min(abs(obj.x-obj.rgc.xSoma));
    [~,somaIdxY] = min(abs(obj.y-obj.rgc.ySoma));
    
    obj.sliceH(1) = surface(squeeze(obj.X(:,somaIdxX,:)), ...
                            squeeze(obj.Y(:,somaIdxX,:)), ...
                            squeeze(obj.Z(:,somaIdxX,:)), ...
                            double(squeeze(obj.rgc.lsm.image(:,somaIdxX,obj.VAChTchannel,:))));

    obj.sliceH(2) = surface(squeeze(obj.X(somaIdxY,:,:)), ...
                            squeeze(obj.Y(somaIdxY,:,:)), ...
                            squeeze(obj.Z(somaIdxY,:,:)), ...
                            double(squeeze(obj.rgc.lsm.image(somaIdxY,:,obj.VAChTchannel,:))));

    %obj.sliceH = slice(obj.X,obj.Y,obj.Z, img, obj.xSoma,obj.ySoma,[]);

    set(obj.sliceH,'edgealpha',0)
    set(obj.sliceH,'facealpha',1)
    
    axis normal
  else
    delete(obj.upperH)
    delete(obj.lowerH)
    delete(obj.stratH)
  end
  
  if(isempty(obj.contourH))
    % Draw the iso-surface
    disp('Calculating iso-surface')
    % fv = isosurface(obj.X,obj.Y,obj.Z,img);
    
    imgThresh = prctile(obj.imgR(:),obj.isoSurfaceThreshold);
    fv = isosurface(obj.Xr,obj.Yr,obj.Zr,obj.imgR, imgThresh);
    obj.contourH = patch(fv);
    
    set(obj.contourH,'facealpha',0.1);
    set(obj.contourH,'edgealpha',0);
    set(obj.contourH,'facecolor',[1 0 0]);
  end
  
  % Draw upper plane
  obj.upperH = plotPlane(obj.planeNormal,obj.VAChTdUpper,obj.X,obj.Y,obj.Z,[0 0 0]);
  
  % Draw lower plane
  obj.lowerH = plotPlane(obj.planeNormal,obj.VAChTdLower,obj.X,obj.Y,obj.Z,[0 0 0]);
    
  obj.stratH = plotPlane(obj.planeNormal,obj.stratificationDepth, ...
                         obj.X,obj.Y,obj.Z,[0 1 0]);
    

  % Clear title
  title([])
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function pp = plotPlane(n,d,xp,yp,zp,colour)
  
    % xp, yp, zp are in the slice coordinate system
    % when we plot the plane we need to translate the coordinate system
    % so that the soma is in origo, calculate the plane, then move
    % back to the slice coordinate system. Hence the obj.rgc.xSoma etc.
      
    hold on
  
    % Get range
    [Xp,Yp] = meshgrid([min(xp(:)) max(xp(:))], ...
                       [min(yp(:)) max(yp(:))]);
    idx = [1 2 4 3];
    Zp = (d - n(1)*(Xp(:) - obj.rgc.xSoma) ...
             -n(2)*(Yp(:) - obj.rgc.ySoma)) / n(3) ...
         + obj.rgc.zSoma;
    %Zp = (d - n(1)*(Xp(:) - obj.rgc.xSoma) ...
    %         -n(2)*(Yp(:) - obj.rgc.ySoma)) / n(3) ...
    %     + obj.rgc.zSoma;
          
    try
      pp = patch(Xp(idx),Yp(idx),Zp(idx),colour);
      set(pp,'edgealpha',0)
      set(pp,'facealpha',0.5)
    catch e
      getReport(e)
      keyboard
    end
      
    %keyboard
    
    hold off
    
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

end