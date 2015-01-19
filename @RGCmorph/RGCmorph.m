% RGCmorph - Johannes Hjorth, j.j.j.hjorth@damtp.cam.ac.uk

classdef RGCmorph < handle
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  properties
    
    HDF5 = false;
    useScaledZcoordinates = true;
    
    hasVAChT = false;
    morphChannel = 2;
    VAChTchannel = 3;
    
    lsmFile = [];
    lsmDir  = [];
    
    xmlFile = [];
    xmlDir  = [];
    
    xScaleXML = NaN;
    yScaleXML = NaN;
    zScaleXML = NaN;
    
    xOffsetXML = NaN;
    yOffsetXML = NaN;
    zOffsetXML = NaN;
    
    nSlicesXML = NaN;
    
    zCoordsXML = []; % Z-position of planes, data taken from XML
    
    somaContours = {};
    axon = [];
    dendrite = [];
    
    % The fields axon and dendrite are structs with the following
    % contents. In the case of multiple dendrites there is a vector
    % of dendrites.
    %
    % coords - x,y,z (n x 3)
    % diameter - d (n x 1)
    % branches - children to branch
    % somaDist - path length to soma
    % branchOrder - order of the branch
    
    stats = [];
    
    typeID = [];
    typeName = [];
    
    lsm = [];
    
    VAChTnormal = [];
    VAChTdUpper = [];
    VAChTdLower = [];
    stratificationDepth = [];
    biStratificationDistance = [];
    
    stratificationDepthScaled = [];
    biStratified = []; % 1 = yes, 0 = no, 0.5 = unknown
    
    manualOverride = false; % Has the user modified the automatic detection
    
    dendPercentiles = [0.1 0.9];
    
    xSoma = []; ySoma = []; zSoma = [];
       
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  methods
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% Constructor
    
    function obj = RGCmorph(fileName,dataDir,loadCache)

        if(~exist('dataDir'))
          dataDir = [];
        end
      
      if(~exist('loadCache'))
        loadCache = true;
      end
      
      % if(~exist('clearLSMflag'))
      %  clearLSMflag = false;
      % end
      
      if(exist('fileName') & ~isempty(fileName))
      
        % A good test file
        if(fileName == -1)
          fileName = 'Cdh3-07-18-2012-a2r2-cell2-40x-corrected.xml';
          % dataDir = '/home/hjorth/DATA/RanaEldanaf/XML/Cdh3';
          dataDir = '/Users/hjorth/DATA/RanaEldanaf/XML/Cdh3';        
        end
        
        if(isempty(dataDir))
          fIdx = find(fileName == '/',1,'last');
          dataDir = fileName(1:fIdx-1);
          fileName = fileName(fIdx+1:end);
          fprintf('Split file name. Dir: %s File: %s\n', ...
                  dataDir, fileName)
        end
        
        if(loadCache)
          
          % Load the preexisting state
          okLoad = obj.load(fileName);
        end
        
        % If not asked to load cache, or if load failed
        if(~loadCache | ~okLoad)

          switch(lower(fileName(end-2:end)))
            case 'xml'
              obj.readXML(fileName,dataDir);
              lsmFile = strrep(fileName,'.xml','.lsm');
              lsmDir = strrep(dataDir,'/XML/','/LSM/');

            case 'swc'
              obj.readSWC(fileName,dataDir);
              lsmFile = strrep(fileName,'.swc','.lsm');
              lsmDir = strrep(dataDir,'/SWC/','/LSM/');
              
            otherwise
              % Lets try the xml reader anyway
              obj.readXML(fileName,dataDir);
              lsmFile = [];
              lsmDir = [];
          end
                      
          obj.readLSM(lsmFile,lsmDir);
        
          % obj.detectVAChTband();
          % obj.drawNeuronOverlay()

          % if(clearLSMflag)
          %   disp('RGCmorph: Clearing LSM file')
          %  
          %  % Clear the LSM file, because it takes a shitload of memory
          %  obj.lsm.image = [];
          %  obj.lsm.fileName = {};
          %  obj.lsm = [];
          % end
        end
      end
      
      disp('Constructor finished.')
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    readXML(obj,filename,dataDir);
    readLSM(obj,filename,dataDir);
    drawNeuron(obj,draw3D,newFigFlag,offset); % default 3D
    drawNeuronOverlay(obj)

    % detectVAChTband(obj); % !!! Obsolete, remove
    % [c1,c2] = fitVAChTband(obj); % !!! Obsolete, remove
    
    % Helper function, applies func to all branches
    result = parseDendrites(obj, func, passParentFlag)

    % If loadVAChT flag is true, the program will load previously
    % stored VAChT band data if it exists.
    results = analyse(obj,loadVAChTflag)
    results = calculateMeasures(obj,showFigures)
    
    checkCoords(obj);

    % Measures
    sd = measureSomaDiameter(obj);
    tdf = measureTotalDendriticField(obj);
    res = allCoords(obj,branch,res);
    mt = measureMeanAxonThickness(obj,axonLen);
    res = measureCountBranchPoints(obj,branch,res);
    res = measureMeanTerminalSegmentLength(obj,branch,res);
    res = measureSegmentTortuosity(obj,branch,res);
    res = measureMeanBranchAngle(obj,branch,res);
    [type,name] = RGCtype(obj);
    res = measureNumSegments(obj,branch,res);
    res = measureTotalLength(obj,branch,parent,res);
    [sa,z] = measureSomaArea(obj)
    res = allCoordsWeight(obj,branch,parent,res)
    res = measureComplexity(obj,branch,res)
    res = measureZlensum(obj,branch,res)

    [zA,zB,dendHistBins,dendHistEdges] = ...
      measureDendriteLocation(obj, percentileA, percentileB, useScaled)

    res = measureZdistrib(obj,branch,res)
    res = measureZdistribVAChTcoordsScaled(obj,branch,res)
    res = measureZdistribVAChToffset(obj,branch,res)
    
    D = measureFractalDimensionBoxCounting(obj)    
    
    dendriticVAChT = measureDendriticVAChTstaining(obj)
    
    res = minCoord(obj,branch,res);
    res = maxCoord(obj,branch,res);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % !!! Obsolete, remove
    %
    % function zNew = Zremap(zOld)
    %   
    %  % Make sure there are two peaks!
    %  assert(numel(obj.VAChTpeaks) == 2)
    %  
    %  k = 1/(obj.VAChTpeaks(2)-obj.VAChTpeaks(1));
    %  
    %  zNew = k * (zOld - obj.VAChTpeaks(2));
    %  
    % end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function save(obj,filename)
      
      if(~exist('SAVE'))
        disp('Creating SAVE directory')
        mkdir('SAVE')
      end
      
      if(~exist('filename') | isempty(filename))
        filename = strrep(obj.xmlFile,'.xml','');
        filename = sprintf('SAVE/%s-cache.mat',filename);
      end
      
      old = struct([]);
      
      saveFields = fieldnames(obj); 
      saveFields = setdiff(saveFields,'lsm');
      
      old = struct('stats',[]);
      
      for i = 1:numel(saveFields)
        eval(sprintf('old.%s = obj.%s;', saveFields{i}, saveFields{i}));
      end
      
      fprintf('Saving state to %s\n', filename)

      if(obj.HDF5)
        save(filename,'old','-v7.3'); % HDF5
      else
        save(filename,'old');
      end
      
    end
    
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    function status = load(obj,filename)

      dataFile = strrep(filename,'.xml','');
      dataFile = sprintf('SAVE/%s-cache.mat',dataFile);
      
      allFields = fieldnames(obj); 
      allFields = setdiff(allFields,'lsm');
      
      if(~exist(dataFile,'file'))
        fprintf('File not found: %s\n', dataFile)
        status = 0;
        return
      end
      
      try
        fprintf('Loading cache: %s\n', dataFile)
        old = load(dataFile);
      catch e
        disp('!!! Loading FAILED')
        getReport(e)
        status = 0;
        return
      end
      
      for i = 1:numel(allFields)
        try
          eval(sprintf('obj.%s = old.old.%s;', ...
                       allFields{i}, ...
                       allFields{i}));
        catch 
          fprintf('Unable to load field %s\n', allFields{i})
        end
      end
      
      % Load LSM file
      obj.readLSM(obj.lsmFile,obj.lsmDir);
      status = 1;
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function fv = featureVector(obj,featureList)
    
      fv = zeros(1,numel(featureList));
    
      for i = 1:numel(featureList)
        try
          fv(1,i) = eval(sprintf('obj.stats.%s;', featureList{i}));
        catch e
          getReport(e)
          keyboard
        end
      end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function reloadLSM(obj)
      
      % Only loads LSM if it does not exist
      if(isempty(obj.lsm))
        obj.readLSM(obj.lsmFile,obj.lsmDir);
      end
      
    end
    
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Use checkcode, to check the code.
  
end