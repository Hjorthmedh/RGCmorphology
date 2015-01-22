classdef VAChT < handle
  
  properties

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    rgc = []; % RGCmorph object
    
    x = []; y = []; z = []; 
    X = []; Y = []; Z = []; % Grids
    
    downScaling = 16; % Downscaling of grid for iso-contour, and
                      % fittings (only for X-Y coords)
    
    Xr = []; Yr = []; Zr = []; % Downsampled (reduced) grids
    imgR = [];                 % Downsampled image
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Histogram for VAChT bands and dendrite stratification
    
    nBins = 50;
    VAChThist = [];
    VAChTbinCenters = [];
    dendHist = [];
    dendbinCenters = [];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    manualOverride = false; % Has the user modified the automatic detection
    
    morphChannel = 2;
    VAChTchannel = 3;

    fractionOfVAChTpeak = 0.5;
    
    isoSurfaceThreshold = 99;
    
    % autoLowerPercentile = []; % [] instead of 0.2 means we use same
                              % absolute threshold as for high
                              % boundary, more consistent.
    % autoUpperPercentile = 0.8;
    
    % Slope of plane
    optimizePlane = true;
    manualPlaneTilt = false;
    
    planeTiltX = 0; % These are just GUI related variables, not
    planeTiltY = 0; % used for direct calculations
    manualPlaneNormal = [0; 0; 1];
    
    % These are in a coordinate frame where the soma is at origo
    planeNormal = [0; 0; 1];

    % The following three variables give the distance from the soma
    % along the planeNormal axis to the upper VAChT band, lower
    % VAChT band and the stratification depth.
    
    VAChTdUpper = 0 % For v vector in upper VAChT band we have v*planeNormal = VAChTdUpper
    VAChTdLower = 0 
    stratificationDepth = 0;
    biStratified = 0.5;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fig = [];
    
    guiNeuron = [];
    guiUpperVAChT = [];
    guiLowerVAChT = [];
    guiStratificationDepth = [];    
    guiHistogram = [];
    guiText = [];
    
    guiPlaneCheckbox = [];
    guiPlaneText = [];    
    
    guiSliceCheckbox = [];
    guiSliceText = [];
    guiContourCheckbox = [];
    guiContourText = [];
    
    guiContinueButton = [];
    guiStatus = [];
    guiRedetectButton = [];
   
    guiIsoThresholdText = [];
    guiIsoThreshold = [];
    
    guiStratificationText = [];
    guiStratificationButtonGroup = [];
    guiBiStratYes = [];
    guiBiStratNo = [];
    guiBiStratYesText = [];
    guiBiStratNoText = [];
    guiBiStratUnknown = [];
    guiBiStratUnknownText = [];
    
    guiPlaneTiltText = [];
    guiPlaneTiltX = [];
    guiPlaneTiltY = [];
        
    % Graphical handles, used for quickly removing old plot elements
        
    upperH = [];
    lowerH = [];
    stratH = [];
    sliceH = [];
    contourH = [];

    % Plane tilt x, y are only valid if manualPlaneNormal is set!!
    
    varToSave = {'planeNormal','VAChTdUpper','VAChTdLower', ...
                 'stratificationDepth', 'optimizePlane', ...
                 'manualOverride', 'biStratified', ...
                 'manualPlaneNormal','planeTiltX','planeTiltY', ...
                 'manualPlaneTilt'};
    
  end
  
  methods
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function obj = VAChT(rgc,loadFlag,skipGUI)
      
      if(~exist('rgc') | isempty(rgc))
        return
      end
         
      obj.VAChTchannel = rgc.VAChTchannel;
      obj.morphChannel = rgc.morphChannel;
      
      if(~exist('loadFlag') | isempty(loadFlag))
        loadFlag = false;
      end
      
      if(~exist('skipGUI'))
        skipGUI = false;
      end
      
      obj.rgc = rgc;
      
      % The number of bins we use are equal to the number of
      % z-planes
      obj.nBins = numel(obj.rgc.zCoordsXML);
      
      if(skipGUI & loadFlag & obj.loadVAChT())
        % Just load old values (done in if statement), apply them to RGC and continue
        obj.updateRGC();
        return
      end
     
      % Setup the coordinate system for the slice
      obj.calculateCoords();      
      
      obj.planeNormal = obj.getPlaneOrientation();

      try
      % Try an automatically detect VAChT bands
      [obj.VAChTdUpper, obj.VAChTdLower] = ...
          obj.calcVAChTHist(obj.fractionOfVAChTpeak);
      catch e
        getReport(e)
        keyboard
      end
      
      % Try and automatically detect stratification depth
      obj.stratificationDepth = obj.calcDendHist();
        
      obj.setupGUI();

      if(loadFlag)
        readFlag = obj.loadVAChT();
        if(readFlag)
          set(obj.guiStatus,'String','Previous VAChT settings loaded')
        end
        
        % Update the GUI with loaded values
        set(obj.guiPlaneCheckbox,'Value',obj.optimizePlane);
        set(obj.guiUpperVAChT,'Value',obj.VAChTdUpper);
        set(obj.guiLowerVAChT,'Value',obj.VAChTdLower);        
        
        if(~isempty(obj.biStratified) & ~isnan(obj.biStratified))
          switch(obj.biStratified)
            case 1
              set(obj.guiBiStratYes,'value',1)
              set(obj.guiBiStratNo,'value',0)            
              set(obj.guiBiStratUnknown,'value',0)  
              obj.biStratified = 1;
            case 0
              set(obj.guiBiStratYes,'value',0)
              set(obj.guiBiStratNo,'value',1)            
              set(obj.guiBiStratUnknown,'value',0)                        
              obj.biStratified = 0;
            case 0.5
              set(obj.guiBiStratYes,'value',0)
              set(obj.guiBiStratNo,'value',0)            
              set(obj.guiBiStratUnknown,'value',1)
              obj.biStratified = 0.5;
            otherwise
              fprintf('Unknown value for biStratified flag: %d\n', obj.biStratified)
          end
        end
        
        % Show the updated figures and texts
        obj.updateGUI();

      else
        
        if(0)
          obj.verifyOffset();
          obj.plotSlice();
        end
      end
      
      obj.plot();

    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function updateGUI(obj)
    
      disp('updateGUI called')
      
      set(obj.guiText,'string', ...
                      sprintf('VAChT upper : %.1f, lower : %.1f, stratification: %.1f',...
                              obj.VAChTdUpper, obj.VAChTdLower, ...
                              obj.stratificationDepth));
      
      % Plane orientation (if manual override)
      % set(obj.guiPlaneTiltX,'String',sprintf('%.3f',asin(obj.planeNormal(2))*180/pi));
      % set(obj.guiPlaneTiltY,'String',sprintf('%.3f',asin(obj.planeNormal(1))*180/pi));
      
      set(obj.guiPlaneTiltX,'String',sprintf('%.2f',obj.planeTiltX*180/pi));
      set(obj.guiPlaneTiltY,'String',sprintf('%.2f',obj.planeTiltY*180/pi));      
      
      set(obj.guiPlaneCheckbox,'Value', obj.optimizePlane)
      
      obj.plot();
      disp('updateGUI done')
      
    end
      

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Function definitions
    
    setupGUI(obj);
    plot(obj);
    obj.updateRGC(obj);
    [dUpper,dLower] = calcVAChTHist(obj,lowPer,highPer)
    stratificationDepth = calcDendHist(obj);
    verifyOffset(obj);
    plotSlice(obj); % To verify
    plotSum(obj);
    plotVolume(obj)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    % Calculates the coordinates for the VAChT staining image
    
    function calculateCoords(obj)
      
      tmp = obj.rgc.lsm.image(:,:,obj.VAChTchannel,:);
      assert(~all(tmp(:) == 0));
      clear tmp;
      
      % Coords for all LSM voxels
      obj.x = (0:size(obj.rgc.lsm.image,2)-1)*obj.rgc.lsm.xyRes*1e6;
      obj.y = -(0:size(obj.rgc.lsm.image,1)-1)*obj.rgc.lsm.xyRes*1e6;
      % obj.z = -(0:size(obj.rgc.lsm.image,4)-1)*obj.rgc.lsm.zRes*1e6;  
      obj.z = obj.rgc.zCoordsXML; % Take data from XML instead
      
      [obj.X,obj.Y,obj.Z] = meshgrid(obj.x,obj.y,obj.z);


      img = squeeze(obj.rgc.lsm.image(:,:,obj.VAChTchannel,:)); 

      if(~isempty(obj.downScaling))
      
        [obj.Xr,obj.Yr,obj.Zr] = meshgrid(obj.x(1:obj.downScaling:end),...
                                          obj.y(1:obj.downScaling:end),...
                                          obj.z);      
      
        obj.imgR = reducevolume(double(img),[obj.downScaling obj.downScaling 1]);
      
      end
              
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Save VAChT band to file
    function saveVAChT(obj)
      
      filename = strrep(obj.rgc.xmlFile,'.xml','-VAChT.mat');
      dataDir = strrep(obj.rgc.xmlDir,'XML','VAChT');
      
      % Just double check that nothing funny happened with file names
      assert(~strcmpi(filename,obj.rgc.xmlFile));
      assert(~strcmpi(dataDir,obj.rgc.xmlDir));
      
      if(~exist(dataDir))
        mkdir(dataDir);
      end
      
      old = struct([]);
      
      for i = 1:numel(obj.varToSave)
        str = sprintf('old(1).%s = obj.%s;', obj.varToSave{i}, obj.varToSave{i});
        eval(str);
      end

      fprintf('Saving VAChT info to %s/%s\n', dataDir,filename)
      save(sprintf('%s/%s',dataDir,filename), 'old');
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Load VAChT band from file
    function okFlag = loadVAChT(obj)
      
      filename = strrep(obj.rgc.xmlFile,'.xml','-VAChT.mat');
      dataDir = strrep(obj.rgc.xmlDir,'XML','VAChT');
      
      fName = sprintf('%s/%s',dataDir,filename);
      
      if(~exist(fName))
        fprintf('%s does not exist.\n', fName)
        okFlag = false;
        return
      end
      
      fprintf('Loading VAChT info from %s\n', filename)
      
      tmp = load(fName);
      old = tmp.old;
      
      savedFields = fieldnames(old);
      
      for i = 1:numel(savedFields)
        str = sprintf('obj.%s = old.%s;', savedFields{i}, savedFields{i});
        eval(str);
        fprintf('Eval: %s\n', str)
      end
      
      okFlag = true;
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
  end
  
end