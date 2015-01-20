% RGCclass - Johannes Hjorth, j.j.j.hjorth@damtp.cam.ac.uk

classdef RGCclass < handle

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  properties
    
    % List of all RGC cells
    RGC = [];
    
    skipNeuronsWithoutVAChT = false;

    verbose = false;
    
    % These are for all
    RGCtypeID = [];
    RGCtypeName = {};
    
    % Unique class names
    RGCuniqueIDs = [];
    RGCuniqueNames = {};
    
    featureMat = [];
    classifier = [];
    trainingIdx = [];
    
    confusionMat = [];
    
    dataSetName = 'Default';
    
    % !!! If new features are added, update setNameLookup also
    
    allFeatureNames = {'stratificationDepth', ...
                       'biStratificationDistance', ...
                       'dendriticField', ...
                       'densityOfBranchPoints', ...
                       'somaArea', ...
                       'numBranchPoints', ...
                        ... % 'numSegments', ...
                       'totalDendriticLength', ...
                       ... % 'meanAxonThickness', ...
                       'meanSegmentLength', ...
                       'meanTerminalSegmentLength', ...
                       'meanSegmentTortuosity', ...
                       'meanBranchAngle', ...
                       'dendriticDensity', ...
                       'fractalDimensionBoxCounting', ...
                       'stratificationDepthScaled', ...
                       'dendriticVAChT', ...
                       'branchAssymetry', ... % SIC: asymmetry
                        ... % 'numLeaves', ...
                       'dendriticDiameter'};
    
    % numLeaves and numSegments removed because they had very high
    % correlation (1.00) with numBranchPoints
    
    featureNameDisplay = [];
    featureNameDisplayShort = [];
    unitDisplay = [];
    unitDisplayScaling = [];
    
                       % 'biStratified', ...

    % % Default feature set to use
    % featuresUsed = {'biStratificationDistance', ...
    %                  'dendriticDensity', ...
    %                  'dendriticField', ...
    %                  'meanSegmentTortuosity', ...
    %                  'somaArea', ...
    %                  'stratificationDepth', ...
    %                  'totalDendriticLength', ...
    %                  'numBranchPoints' };

    % Default feature set to use
    % featuresUsed = { 'dendriticDensity', ...
    %                  'somaArea', ...
    %                  'totalDendriticLength', ...
    %                  'meanTerminalSegmentLength' };

    % featuresUsed = { 'fractalDimensionBoxCounting', ...
    %                  'somaArea', ...
    %                  'meanTerminalSegmentLength' };

    featuresUsed = { 'fractalDimensionBoxCounting', ...
                     'somaArea', ...
                     'meanTerminalSegmentLength', ...
                     'densityOfBranchPoints', ...
                     'dendriticField'};
    
    
    % classifierMethod = 'FitEnsemble';
    classifierMethod = 'NaiveBayes';        
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  methods
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function obj = RGCclass(dataDir)
      
      if(~obj.skipNeuronsWithoutVAChT)
        % This feature comes from the VAChT bands, skip
        obj.allFeatureNames = setdiff(obj.allFeatureNames, ...
                                      {'stratificationDepthScaled', ...
                                       'dendriticVAChT'});
      end
      
      obj.setNameLookup();
      
      if(exist('dataDir'))

        switch(dataDir)
          case 0
            % Skip loading
            return
          case -1
            dataDir = 'DATA/RanaEldanaf/XML/';
          case -2

            dataDir = { 'DATA/RanaEldanaf/XML/', ...
                        '/Users/hjorth/DATA/Sumbul/SWC/'};
        end

        
        
        loadCache = true;
        reanalyse = true;
        randomOrder = false; % Turn off random order for now
        
        if(iscell(dataDir))
          for j = 1:numel(dataDir)
            obj.loadDirectory(dataDir{j},loadCache,reanalyse,randomOrder);            
          end
        else
          obj.loadDirectory(dataDir,loadCache,reanalyse,randomOrder);
        end
      else
        obj.loadDirectory();
      end
            
    end
    
    loadDirectory(obj,dataDir,loadCache,reanalyse,randomOrder);
    varVector = getVariable(obj,varName);
    plotSpace(obj, plotList, markClassification,showLegendFlag,reuseFigFlag)
    plotStratification(obj)
    plotVAChTbands(obj)  
    featureList = featureSelection(obj,method,runType)
    clusterID = blindClustering(obj,k,nReps,RGCidx)
    plotFeatures(obj,featureList,interactiveFlag)
    plotAllVAChT(obj)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function lazySave(obj,fName)
      
      if(~exist('fName') | isempty(fName))
        fName = 'SAVE/cache/lazyload.mat';
      else
        fName = sprintf('SAVE/cache/lazyLoad-%s.mat',fName);
      end
      
      % In future versions, possibly save more info
      RGC = obj.RGC;
      allFeatureNames = obj.allFeatureNames;
      featuresUsed = obj.featuresUsed;
      dataSetName = obj.dataSetName;
      save(fName,'RGC','allFeatureNames','featuresUsed','dataSetName');
      
      fprintf('Saved data to %s\n', fName)
    end
    
    function lazyLoad(obj,fName);

      if(~exist('fName') | isempty(fName))
        fName = 'SAVE/cache/lazyload.mat';
      else
        fName = sprintf('SAVE/cache/lazyLoad-%s.mat',fName);
      end
       
      fprintf('Loading data from %s\n', fName)
      tmp = load(fName);
      obj.RGC = tmp.RGC;
      try
        obj.allFeatureNames = tmp.allFeatureNames;
        obj.featuresUsed = tmp.featuresUsed;
        obj.dataSetName = tmp.dataSetName;
      catch 
        disp('OLD save file, allFeatureNames, featuresUsed and dataSetName not saved')
      end
      
      obj.updateTables(obj.featuresUsed);      
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function reanalyse(obj,loadVAChTflag)
      
      if(~exist('loadVAChTflag') | isempty(loadVAChTflag))
        loadVAChTflag = false;
      end
      
      for j = 1:numel(obj.RGC)
        if(~loadVAChTflag)
          obj.RGC(j).reloadLSM();
        end
        
        obj.RGC(j).analyse(loadVAChTflag);

        % Clear the lsm image afterwards
        obj.RGC(j).lsm = [];
        
        close all
      end
      
      obj.updateTables(obj.featuresUsed);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function setFeatureMat(obj, featureList)
 
      obj.featureMat = zeros(numel(obj.RGC),numel(featureList));
      
      for i = 1:numel(obj.RGC)
        obj.featureMat(i,:) = obj.RGC(i).featureVector(featureList);
      end
      
      obj.normaliseFeatureMat();
      
      obj.featuresUsed = featureList;
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function featureMat = getFeatureMat(obj, featureList)
      
      featureMat = zeros(numel(obj.RGC),numel(featureList)); 
      
      for i = 1:numel(obj.RGC)
        featureMat(i,:) = obj.RGC(i).featureVector(featureList);
      end
      
      featureMat = obj.normaliseMat(featureMat);
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function featureMat = normaliseMat(obj,featureMat)
      
      featureMat = featureMat ./ repmat(std(featureMat),size(featureMat,1),1);
      featureMat = featureMat - repmat(mean(featureMat),size(featureMat,1),1);
      
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function normaliseFeatureMat(obj)
      
      obj.featureMat = obj.featureMat ...
                      ./ repmat(std(obj.featureMat),size(obj.featureMat,1),1);

      obj.featureMat = obj.featureMat ...
          - repmat(mean(obj.featureMat),size(obj.featureMat,1),1);
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % This is used when manually setting the VAChT bands and
    % dendrite stratification, so that we are doing it blindly
    
    function randomizeOrder(obj)
      
      idx = randperm(numel(obj.RGC));
      obj.RGC = obj.RGC(idx);
      obj.updateTables(obj.featuresUsed);
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function updateTables(obj, featureList)
      
      if(isempty(obj.RGC))
        return
      end

      % The user must specify a featureList
      
      obj.setFeatureMat(featureList);
      
      try
        obj.RGCtypeID = cat(1,obj.RGC.typeID);
        
        for i = 1:numel(obj.RGC)
          obj.RGCtypeName{i} = obj.RGC(i).typeName;
        end
        
      catch e
        getReport(e)
        keyboard
      end
      
      obj.featuresUsed = featureList;
      
      % Finally update the class tables updated
      obj.getUniqueNames();
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function test(obj)
      
      n = numel(obj.RGC);
      perm = randperm(n);
      useIdx = perm(1:ceil(0.8*n));
      testIdx = setdiff(1:numel(obj.RGC),useIdx);

      obj.train(useIdx);
      
      [group,nCorr,nFalse] = obj.classify(testIdx);

      fprintf('%d/%d (%.1f %%)\n', nCorr, numel(testIdx), ...
              100*nCorr/numel(testIdx))
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function train(obj,trainingIdx)
      
      if(exist('trainingIdx') && ~isempty(trainingIdx))
        obj.trainingIdx = trainingIdx;
      end
      
      trainingMat = obj.featureMat;

      if(isempty(obj.trainingIdx))
        disp('No training set defined, aborting.')
        obj.classifier = [];
        return
      end

      if(size(trainingMat,2) == 0)
        disp('No features selected, aborting.')
        obj.classifier = [];
        return
      end
      
      try
        if(obj.verbose)
          fprintf('Using subset: %d/%d\n', numel(obj.trainingIdx), numel(obj.RGC))
          fprintf('Using: %s\n', obj.classifierMethod)        
        end
        
        switch(obj.classifierMethod)
          case 'SVM'
          
            % We are using our own homebrewed multi-class SVM 
            obj.classifier = SVM(trainingMat(obj.trainingIdx,:), ...
                                 transpose(obj.RGCtypeID(obj.trainingIdx))); 
            
          case 'NaiveBayes'
        
            obj.classifier = NaiveBayes.fit(trainingMat(obj.trainingIdx,:), ...
                                            transpose(obj.RGCtypeID(obj.trainingIdx)), ...
                                            'Distribution','normal');
            
            
            
          case {'FitEnsemble','Bags'}
            % Feature selection: 
            % http://www.mathworks.se/help/stats/ensemble-methods.html
            % http://www.mathworks.se/help/stats/fitensemble.html
            
            obj.classifier = fitensemble(trainingMat(obj.trainingIdx,:), ...
                                         transpose(obj.RGCtypeID(obj.trainingIdx)), ...
                                         'Bag', 100, 'Tree', ... 
                                         'type','classification');
            % 'PredictorNames', obj.featuresUsed);  
        
          otherwise
            fprintf('Unknown method: %s\n', obj.classifierMethod)
            keyboard
        end
        
      catch e
        getReport(e)
        keyboard
      end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % RGC can be a RGCmorph object or a vector of numbers
    
    function [group,nCorr,nFalse] = classify(obj, RGC)
      
      % No RGC parameter, classify all
      if(~exist('RGC') || isempty(RGC))
        RGC = 1:numel(obj.RGC);
      end
      
      if(RGC == -1)
        % Using all the RGC that were not used for training
        RGC = setdiff(1:numel(obj.RGC),obj.trainingIdx);
      end
      
      if(isempty(obj.classifier))
        disp('No classifier trained.')

        group = nan*zeros(numel(RGC),1);          

        nCorr = 0;
        nFalse = 0;
        return
      end
      
      for i = 1:numel(RGC)
        
        if(isa(RGC(i),'RGCmorph'))
          group(i,1) = obj.classifier.predict(RGC(i).featureVector());
          realGroup(i,1) = RGC(i).RGCtypeID;
        else
          group(i,1) = obj.classifier.predict(obj.featureMat(RGC(i),:));
          realGroup(i,1) = obj.RGCtypeID(RGC(i));
        end
        
      end
         
      nCorr = nnz(group == realGroup);
      nFalse = nnz(group ~= realGroup);
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function CM = confusionMatrix(obj,trainIdx,testIdx)

      if(~isempty(trainIdx))
        obj.train(trainIdx);
      else
        disp('No trainIdx specified, using the current classifier')
      end
      
      groupID = obj.classify(testIdx);
      
      uID = unique(obj.RGCtypeID);
      
      CM = zeros(numel(uID),numel(uID));      
      
      for i = 1:numel(testIdx)
      
        CM(obj.RGCtypeID(testIdx(i)),groupID(i)) = ...
            CM(obj.RGCtypeID(testIdx(i)),groupID(i)) + 1;
            
      end
        
    end
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % This calculates the confusion matrix using cross-validation
    
    function [CM,CMsd] = confusionMatrixCrossValidation(obj,nFolds, nReps)
      
      if(~exist('nFolds') | isempty(nFolds))
        nFolds = 5;
      end
      
      if(~exist('nReps') | isempty(nReps))
        nReps = 100;
      end
      
      nClasses = numel(unique(obj.RGCtypeID));
      CMsum = zeros(nClasses,nClasses,nReps);
      
      obj.setFeatureMat(obj.featuresUsed);
      
      for i = 1:nReps
        fprintf('%d/%d\n', i, nReps)
        
        % Split the data into n folds
        foldID = ceil(nFolds * rand(numel(obj.RGC),1));
        
        for j = 1:nFolds
        
          trainIdx = find(foldID ~= j);
          testIdx = find(foldID == j);
          
          obj.train(trainIdx);
          
          CMsum(:,:,i) = CMsum(:,:,i) + obj.confusionMatrix(trainIdx,testIdx);
          
        end
        
      end
      
      CM = mean(CMsum,3);
      CMsd = std(CMsum,[],3);
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % This calculates the confusion matrix using leave one out 
    
    function CM = confusionMatrixLeaveOneOut(obj)
      
      nClasses = numel(unique(obj.RGCtypeID));
      
      CM = zeros(nClasses, nClasses);
      
      obj.setFeatureMat(obj.featuresUsed);
      
      for i = 1:numel(obj.RGC)
        
        trainIdx = setdiff(1:numel(obj.RGC),i);
        testIdx = i;
      
        obj.train(trainIdx);
        
        CM = CM + obj.confusionMatrix(trainIdx,testIdx);
        
      end
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function checkVariables(obj)
      
      % Checking correlation of variables
      varMat = obj.featureMat;
      
      v2 = varMat - repmat(mean(varMat,1),size(varMat,1),1);
      v3 = v2 ./ repmat(std(varMat,1),size(varMat,1),1);
      
      C = cov(v3);
      
      R = corrcoef(C);
      
      keyboard
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function exportCSV(obj, filename)
      
      if(~exist('filename') | isempty(filename))
        filename = 'export.csv';
      end
      
      columns = {{'Filename', 'xmlFile'}, ...
                 {'ClassID', 'typeID'}, ...
                 {'DendFieldArea', 'stats.dendriticField' }, ...
                 {'NumBranchPoints', 'stats.numBranchPoints'}, ...
                 {'SomaArea', 'stats.somaArea'}, ...
                 {'NumSegments', 'stats.numSegments'}, ...
                 {'TotDendLength', 'stats.totalDendriticLength'}, ...
                 {'MeanAxonThickness', 'stats.meanAxonThickness'}, ...
                 {'BranchPointDensity', 'stats.densityOfBranchPoints'}, ...
                 {'MeanSegmentLength', 'stats.meanSegmentLength'}, ...
                 {'MeanTermSegmentLength', ...
                  'stats.meanTerminalSegmentLength'}, ...
                 {'MeanSegmentTortuosity', 'stats.meanSegmentTortuosity'}, ...
                 {'MeanBranchAngle', 'stats.meanBranchAngle'}, ...
                 {'DendriticArborDensity', 'stats.dendriticDensity'}, ...
                 {'Dendritic VAChT', 'stats.dendriticVAChT'}, ...
                 {'StratificationDepthScaled','stats.stratificationDepthScaled'},...
                 {'StratificationDepth','stats.stratificationDepth'},...
                 {'BistratificationDistance','stats.biStratificationDistance'}
                };
      
      fprintf('Opening: %s\n', filename)
      
      fid = fopen(filename, 'w')
      
      % Write header
      fprintf(fid, '%s', columns{1}{1});
      
      for i = 2:numel(columns)
        fprintf(fid, ',%s', columns{i}{1});
      end
      
      fprintf(fid, '\n');
      
      % Write data
      
      for i = 1:numel(obj.RGC)

        fprintf('Writing: %s\n', obj.RGC(i).xmlFile)
        
        cmd = sprintf('obj.RGC(i).%s', columns{1}{2});
        val = eval(cmd);
        fprintf(fid, '%s', val);
        
        for j = 2:numel(columns)
          cmd = sprintf('obj.RGC(i).%s', columns{j}{2});
          val = eval(cmd);
          fprintf(fid, ',%d', val);
        end

        fprintf(fid, '\n');        
        
      end
      
      fclose(fid);
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    chooseFeatures(obj)
    usedAll = setRandomTrainingSet(obj,nOfEach)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function setNameLookup(obj)
      
      obj.featureNameDisplay = containers.Map();
      
      % We do it this way, to avoid getting the key and value pairs missaligned by
      % specifying them as two long lists
      
      obj.featureNameDisplay('stratificationDepth') = 'Stratification Depth';
      obj.featureNameDisplay('biStratificationDistance') = 'Bistratification Distance';
      obj.featureNameDisplay('dendriticField') = 'Dendritic Area';
      obj.featureNameDisplay('densityOfBranchPoints') = 'Density of Branch Points';
      obj.featureNameDisplay('somaArea') = 'Soma Area';
      obj.featureNameDisplay('numBranchPoints') = 'Number of Branch Points';
      obj.featureNameDisplay('numSegments') = 'Number of Segements';
      obj.featureNameDisplay('totalDendriticLength') = 'Total Dendritic Length';
      obj.featureNameDisplay('meanSegmentLength') = 'Mean Segment Length';
      obj.featureNameDisplay('meanTerminalSegmentLength') = 'Mean Terminal Segment Length';
      obj.featureNameDisplay('meanSegmentTortuosity') = 'Mean Segment Tortuosity';
      obj.featureNameDisplay('meanBranchAngle') = 'Mean Branch Angle';
      obj.featureNameDisplay('dendriticDensity') = 'Dendritic Density';
      obj.featureNameDisplay('fractalDimensionBoxCounting') = 'Fractal Dimension Box Counting';      
      obj.featureNameDisplay('stratificationDepthScaled') = 'Stratification Depth Scaled';      
      obj.featureNameDisplay('dendriticVAChT') = 'Dendritic VAChT';      
      obj.featureNameDisplay('branchAssymetry') = 'Branch Assymetry';      
      obj.featureNameDisplay('numLeaves') = 'Number of Leaves';            
      obj.featureNameDisplay('dendriticDiameter') = 'Dendritic Diameter';            

      
      obj.featureNameDisplayShort = containers.Map();
      obj.featureNameDisplayShort('stratificationDepth') = 'SD';
      obj.featureNameDisplayShort('biStratificationDistance') = 'BD';
      obj.featureNameDisplayShort('dendriticField') = 'DA';
      obj.featureNameDisplayShort('densityOfBranchPoints') = 'DBP';
      obj.featureNameDisplayShort('somaArea') = 'SA';
      obj.featureNameDisplayShort('numBranchPoints') = 'NBP';
      obj.featureNameDisplayShort('numSegments') = 'NS';
      obj.featureNameDisplayShort('totalDendriticLength') = 'TDL';
      obj.featureNameDisplayShort('meanSegmentLength') = 'MSL';
      obj.featureNameDisplayShort('meanTerminalSegmentLength') = 'MTSL';
      obj.featureNameDisplayShort('meanSegmentTortuosity') = 'MST';
      obj.featureNameDisplayShort('meanBranchAngle') = 'MBA';
      obj.featureNameDisplayShort('dendriticDensity') = 'DD';
      obj.featureNameDisplayShort('fractalDimensionBoxCounting') = 'FDBC';      
      obj.featureNameDisplayShort('stratificationDepthScaled') = 'SDS';      
      obj.featureNameDisplayShort('dendriticVAChT') = 'DVAChT';      
      obj.featureNameDisplayShort('branchAssymetry') = 'BA';      
      obj.featureNameDisplayShort('numLeaves') = 'NL';            
      obj.featureNameDisplayShort('dendriticDiameter') = 'DDi';            
      
      obj.unitDisplay = containers.Map();
      
      obj.unitDisplay('stratificationDepth') = '\mum';
      obj.unitDisplay('biStratificationDistance') = '\mum';
      obj.unitDisplay('dendriticField') = 'mm^2';
      obj.unitDisplay('densityOfBranchPoints') = 'mm^{-2}';
      obj.unitDisplay('somaArea') = '\mum^2';
      obj.unitDisplay('numBranchPoints') = '';
      obj.unitDisplay('numSegments') = '';
      obj.unitDisplay('totalDendriticLength') = 'mm';
      obj.unitDisplay('meanSegmentLength') = '\mum';
      obj.unitDisplay('meanTerminalSegmentLength') = '\mum';
      obj.unitDisplay('meanSegmentTortuosity') = '';
      obj.unitDisplay('meanBranchAngle') = 'degrees';
      obj.unitDisplay('dendriticDensity') = '\mum^{-1}';
      obj.unitDisplay('fractalDimensionBoxCounting') = '';      
      obj.unitDisplay('branchAssymetry') = '';      
      obj.unitDisplay('numLeaves') = '';            
      obj.unitDisplay('dendriticDiameter') = '\mum';            
      
      obj.unitDisplayScaling = containers.Map();

      obj.unitDisplayScaling('stratificationDepth') = 1;
      obj.unitDisplayScaling('biStratificationDistance') = 1;
      obj.unitDisplayScaling('dendriticField') = 1e-6;
      obj.unitDisplayScaling('densityOfBranchPoints') = 1e6;
      obj.unitDisplayScaling('somaArea') = 1;
      obj.unitDisplayScaling('numBranchPoints') = 1;
      obj.unitDisplayScaling('numSegments') = 1;
      obj.unitDisplayScaling('totalDendriticLength') = 1e-3;
      obj.unitDisplayScaling('meanSegmentLength') = 1;
      obj.unitDisplayScaling('meanTerminalSegmentLength') = 1;
      obj.unitDisplayScaling('meanSegmentTortuosity') = 1;
      obj.unitDisplayScaling('meanBranchAngle') = 180/pi;
      obj.unitDisplayScaling('dendriticDensity') = 1;
      obj.unitDisplayScaling('fractalDimensionBoxCounting') = 1;      
      obj.unitDisplayScaling('branchAssymetry') = 1;      
      obj.unitDisplayScaling('numLeaves') = 1;            
      obj.unitDisplayScaling('dendriticDiameter') = 1;            
      
      
      
    end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function alphaIdx = getFeatureAlphabeticOrder(obj)
      
      try
      
        for i = 1:numel(obj.allFeatureNames)
          fullName{i} = obj.featureNameDisplay(obj.allFeatureNames{i});
        end
      
        [~,alphaIdx] = sort(fullName);
      catch e
        getReport(e)
        keyboard
      end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % This function gets the unique IDs and Names
    
    function getUniqueNames(obj)
      
      obj.RGCuniqueIDs = unique(obj.RGCtypeID);
      obj.RGCuniqueNames = {};
      
      for i = 1:numel(obj.RGCuniqueIDs)
        idx = find(obj.RGCtypeID == obj.RGCuniqueIDs(i));
        obj.RGCuniqueNames{i} = obj.RGCtypeName{idx(1)};
      end
        
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
  end
  
end