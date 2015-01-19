function readLSM(obj,filename,dataDir)

  % Sorry for poluting the path
  % We need these for the LSM reader
  addpath(strcat(pwd,'/LSM/lsm'));
  addpath(strcat(pwd,'/LSM/cstruct'));
  
  fprintf('Loading %s\n', filename)

  lsmFileName = sprintf('%s/%s', dataDir, filename);

  obj.lsmFile = filename;
  obj.lsmDir = dataDir;
  
  if(~exist(lsmFileName))
    fprintf('Unable to find %s\n', lsmFileName)
    return
  end
  
  [lsmInfo,scanInfo,imInfo] = lsminfo(lsmFileName);
  imgStack = tiffread(lsmFileName);
  
  obj.lsm.height = imgStack(1).height;
  obj.lsm.width = imgStack(1).width;
  obj.lsm.objective = scanInfo.ENTRY_OBJECTIVE;
  obj.lsm.zoom_X = scanInfo.ZOOM_X;
  obj.lsm.zoom_Y = scanInfo.ZOOM_Y;
  obj.lsm.zoom_Z = scanInfo.ZOOM_Z;
  
  fprintf('Reading: %s\n', lsmFileName)
  fprintf('Objective: %s (Zoom: %d, %d, %d)\n', ...
          obj.lsm.objective, ...
          obj.lsm.zoom_X, ...
          obj.lsm.zoom_Y, ...
          obj.lsm.zoom_Z)
  
  % Make sure everything is 16-bit data
  try
    assert(all(cat(1,imgStack.bits) <= 16))
  catch e
    getReport(e)
    keyboard
  end
    
    
  obj.lsm.image = zeros(obj.lsm.height,obj.lsm.width, ...
                        3,numel(imgStack), 'uint16');
    
  for j = 1:length(imgStack)

    if(iscell(imgStack(j).data))
      for i = 1:length(imgStack(j).data)
        obj.lsm.image(:,:,i,j) = imgStack(j).data{i};
      end
    else

      % Only one channel present, put it in red
      obj.lsm.image(:,:,1,j) = imgStack(j).data;      
    end
    
    if(j > 1)
      % Make sure voxel size etc matches
      if(imgStack(1).lsm.VoxelSizeX ~= imgStack(j).lsm.VoxelSizeX)
        disp('Voxel size inconsistent in the image! Not supported.')
      end
      
    end
    
    obj.lsm.fileName{j} = lsmFileName;
    
  end
  
  obj.lsm.xyRes = imgStack(1).lsm.VoxelSizeX;
  obj.lsm.zRes = imgStack(1).lsm.VoxelSizeZ;  
  
  fprintf('XY res: %d, Z res: %d (n = %d)\n', ...
          obj.lsm.xyRes, obj.lsm.zRes, numel(imgStack))
  
  if(imgStack(1).lsm.VoxelSizeX ~= imgStack(1).lsm.VoxelSizeY)
    % If you ever see this warning, let me know.
    disp('Warning: X and Y resolution differ, code assumes they are same.')
    disp(sprintf('Using %d m', obj.lsm.xyRes))
  end

  for i = 2:numel(imgStack)
    % Verifying that Z-stack is taken with constant spacing
    assert(imgStack(1).lsm.VoxelSizeZ == imgStack(i).lsm.VoxelSizeZ);
  end

  obj.hasVAChT = true;
  
  if(all(obj.lsm.image(:,:,obj.VAChTchannel,:) == 0))
    % There is a VAChT image, but all values are zero!
    obj.hasVAChT = false;
  end
  
end