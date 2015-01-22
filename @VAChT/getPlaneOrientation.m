function c = getPlaneOrientation(obj)

  if(obj.optimizePlane)
    % We try and fit the best plane to the VAChT band

    useReduced = false;
    
    if(useReduced)
      c = fitPlaneToPoints(obj.Xr-obj.rgc.xSoma, ...
                           obj.Yr-obj.rgc.ySoma, ...
                           obj.Zr-obj.rgc.zSoma, obj.imgR);
    else
      
      VAChTimg = double(obj.rgc.lsm.image(:,:,obj.VAChTchannel,:));
      VAChTthr = prctile(VAChTimg(:),98);
      
      idx = find(VAChTimg > VAChTthr);
      
      try
        c = fitPlaneToPoints(obj.X(idx)-obj.rgc.xSoma, ...
                             obj.Y(idx)-obj.rgc.ySoma,...
                             obj.Z(idx)-obj.rgc.zSoma, ...
                             VAChTimg(idx));
      catch e
        disp(['getPlaneOrientation: Something went wrong with plane ' ...
              'fitting'])
        getReport(e)
        keyboard
      end
        
      % c = fitPlaneToPoints(obj.X,obj.Y,obj.Z, ...
      %                      double(squeeze(obj.rgc.lsm.image(:,:,obj.VAChTchannel,:))));
    end
  else
    if(obj.manualPlaneTilt)
      c = manualPlaneNormal;
    else
      % Use the default coordinate system
      c = [0; 0; 1];
    end
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Plane equation a*x + b*y + c = z
  
  function planeNormal = fitPlaneToPoints(xp,yp,zp,wp)

    disp('Optimizing plane orientation... (this can take some time)')
  
    Ap = [xp(:), yp(:), ones(size(xp(:)))];
    Wp = sparse(1:numel(wp),1:numel(wp),wp(:)); % Weights
    
    % Square weights
    Wp = Wp.^2;
    
    % Solved weighted least squares
    %keyboard
    try
      cp = transpose(Ap)*Wp*Ap \ (transpose(Ap) * Wp * zp(:));
    catch e
      getReport(e)
      keyboard
    end
      
    % cp = Ap \ zp(:);
    
    % Added the minus sign in front, so that the direction of the
    % coordinate system will align with default z-direction
    % in the case where they match
    planeNormal = - [cp(1); cp(2); -1];
    planeNormal = planeNormal / norm(planeNormal);
    
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end