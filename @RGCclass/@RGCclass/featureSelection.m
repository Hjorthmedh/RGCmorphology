function featureList = featureSelection(obj, method, runType)
    
  if(~exist('runType') || isempty(runType))
    runType = 'findBestSet';
    % runType = 'showLandscape';
  end
    
  if(~exist('method') || isempty(method))
    method = 'Bag';
  end

  % featureChoice = 'noVAChT';
  featureChoice = 'nonCorr';
  % featureChoice = 'onemore'; % !!! BEST
  
  % For find best set
  MCreps = 30;

  % For show landscape
  nReps = 30;
  
  met = {'naiveBayes', 'Bag', 'LPBoost', 'AdaBoostM2', ...
        'TotalBoost', 'RUSBoost', 'SubspaceKNN'}
  % for i = 1:7, r.featureSelection(met{i}), end
  
  seed = NaN;
  
  useStreams = false;
  
  if(useStreams)
    % Fix random seed for this
    seed = 0;
    s = RandStream('mlfg6331_64','Seed',seed)
    RandStream.setGlobalStream(s)
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function incorrect = critFun(XTrain, yTrain, XTest, yTest)

    % fprintf('Method: %s\n', method)
    
    switch(method)
      case 'naiveBayes'
        classifier = NaiveBayes.fit(XTrain,yTrain);
        % assert(false) % Please use the other method
        
      case 'Bag'
        classifier = fitensemble(XTrain,yTrain,'Bag', ...
                                 100, 'Tree', ...
                                 'type','classification');        
      case 'LPBoost'
        classifier = fitensemble(XTrain,yTrain,'LPBoost', ...
                                 100, 'Tree', ...
                                 'type','classification');        
        
      case 'AdaBoostM2'
        classifier = fitensemble(XTrain,yTrain,'AdaBoostM2', ...
                                 200, 'Tree', ...
                                 'type','classification');
        
      case 'TotalBoost'
        classifier = fitensemble(XTrain,yTrain,'TotalBoost', ...
                                 100, 'Tree', ...
                                 'type','classification');

      case 'RUSBoost'
        classifier = fitensemble(XTrain,yTrain,'RUSBoost', ...
                                 100, 'Tree', ...
                                 'type','classification');
        
      case 'SubspaceKNN'
        classifier = fitensemble(XTrain,yTrain,'Subspace', ...
                                 100, 'KNN', ...
                                 'type','classification');
        
      otherwise 
        disp('Unknown classifier')
        keyboard
    end
  
    group = classifier.predict(XTest);
    
    incorrect = nnz(abs(group-yTest) > 1e-9);

  end

  disp('Feature selection... (please wait)')

  
  switch(featureChoice)
    case 'noVAChT'
      useFeatures = setdiff(obj.allFeatureNames, ...
                            {'meanAxonThickness', ...
                             'stratificationDepthScaled', ...
                             'dendriticVAChT'});
  
    case 'nonCorr'
      % Remove highly correlated features
  
      useFeatures = {'biStratificationDistance', ...
                     'dendriticDensity', ...
                     'dendriticField', ...
                     'fractalDimensionBoxCounting', ...
                     'meanBranchAngle', ...
                     'meanSegmentTortuosity', ...
                     'somaArea', ...
                     'stratificationDepth', ...
                     'totalDendriticLength' };

    case 'onemore'
      % Remove highly correlated features
  
      useFeatures = {'biStratificationDistance', ...
                     'dendriticDensity', ...
                     'dendriticField', ...
                     'meanSegmentTortuosity', ...
                     'somaArea', ...
                     'stratificationDepth', ...
                     'totalDendriticLength', ...
                     'numBranchPoints' };
      
      
    case 'twmore'
      % Remove highly correlated features
  
      useFeatures = {'biStratificationDistance', ...
                     'dendriticDensity', ...
                     'dendriticField', ...
                     'meanSegmentTortuosity', ...
                     'somaArea', ...
                     'stratificationDepth', ...
                     'totalDendriticLength', ...
                     'numBranchPoints', ...
                     'meanBranchAngle' };
      
      
  end
      
  obj.updateTables(useFeatures);

  useFeatures
  
  disp('Automatically trying to find good feature set')
  
  foldedCVP = cvpartition(obj.RGCtypeID,'kfold',5); % 10
  
  %  [inmodel, history] = sequentialfs(@critFun,obj.featureMat,obj.RGCtypeID, ...
  %                                    ... %'mcreps',10, ... % must be 1 for CV, otherwise use 10 or so.
  %'cv', tenfoldCVP, ...
  %...% 'cv', cvpartition(numel(obj.RGCtypeID),'leaveout'), ...
  %                                  ... % 'nfeatures', 3, ...
  %                                  'direction','forward', ...
  %                                  'options', statset('useparallel',true));
  
  tic 
  
  
  switch(runType)
    case 'findBestSet'
      [inmodel, history] = sequentialfs(@critFun,obj.featureMat,obj.RGCtypeID, ...
                                        'cv', foldedCVP, ...
                                        'mcreps', MCreps, ...
                                        'direction','forward', ...
                                        'options', statset('useparallel',true,...
                                                           'UseSubstreams', true));

      % Trying to run serial, this seems to be
      % replicable. Parallel gives different errors (same answer though)
      %
      % [inmodel, history] = sequentialfs(@critFun,obj.featureMat,obj.RGCtypeID, ...
      %                                   'cv', foldedCVP, ...
      %                                   'mcreps', 1, ...
      %                                   'direction','forward');

      
      
    case 'showLandscape'
      
      for rep = 1:nReps

        fprintf('Starting repeat %d/%d\n', rep, nReps)
        
        foldedCVP = cvpartition(obj.RGCtypeID,'kfold',5); % 10
        
        if(useStreams)
          opt = statset('useparallel',true, ...
                        'UseSubstreams', true, ...
                        'streams', seed);
        else
          opt = [];
        end
          
        [inmodel{rep}, history{rep}] = sequentialfs(@critFun,obj.featureMat,obj.RGCtypeID, ...
                                                    'cv', foldedCVP, ...
                                                    'nfeatures', numel(useFeatures), ...
                                                    'direction','forward', ...
                                                    'options', opt);
      
      end
      
      try
      
        fileName = sprintf('FIGS/FeatureNumberErrorPlot-%s-nFeatures-%d-seed-%d-%s.txt', ...
                           method, ...
                           numel(useFeatures), ...
                           seed, ...
                           datestr(now,'yyyy-mm-dd-HH:MM:SS'));
        
        fid = fopen(fileName,'w');
        
        figure
        % Plot error for different features
        for rep = 1:numel(history)
          n = numel(history{rep}.Crit);
          x = (1:n) + 0.1*rand(1,n);
          plot(x,history{rep}.Crit,'ko')
          hold all
      
          for k = 1:numel(useFeatures)
            % Save what features were used
            featureList{k,rep,1} = useFeatures(find(history{rep}.In(k,:)));
            featureList{k,rep,2} = history{rep}.Crit(k);
            featureList{k,rep,3} = history{rep}.In(k,:);            
          end
        end
        
        meanVals = mean(cell2mat(featureList(:,:,2)),2);
        [minVal,minIdx] = min(meanVals)
        
        for i = 1:size(featureList,2)
          fprintf(fid,'%.3f (%d features) ', featureList{minIdx,i,2},minIdx)
          for j = 1:numel(featureList{minIdx,i,1})
            fprintf(fid,'%s ', featureList{minIdx,i,1}{j})
          end
          fprintf(fid,'\n')
        end

        plot(1:numel(meanVals),meanVals,'r-')
        
        % Score = how often the feature was choosen as one of the
        % used ones
        featureScores = sum(cell2mat(transpose(featureList(minIdx,:,3))),1);
        
        [~,sortIdx] = sort(featureScores,'descend');
        
        fprintf(fid,['\nHow often does a feature occur (for best %d ' ...
                     'features):\n'], minIdx)
        for i = 1:numel(sortIdx)
          
          fprintf(fid,'%d - %s\n', featureScores(sortIdx(i)),useFeatures{sortIdx(i)})
          
        end
          
        %% Lets also show scores for 3 feature selection, and 4
        %% feature selection
        
        for nFeat = 3:4
          fprintf(fid,'\n\nFeature selection for best %d features\n', nFeat)
          
          featScore = sum(cell2mat(transpose(featureList(nFeat,:,3))),1);
          [~,sortIdx] = sort(featScore,'descend');

          for i = 1:numel(sortIdx)
          
            fprintf(fid,'%d - %s\n', featScore(sortIdx(i)),useFeatures{sortIdx(i)})
          
          end
   
        end
          
        fclose(fid);
        
        system(sprintf('cat %s', fileName))
        
        % keyboard
        
      catch e
        getReport(e)
        keyboard
      end
      
      % Make sure our y axis starts at 0
      a = axis; a(3) = 0; axis(a);
      set(gca,'fontsize',20)
      xlabel('Number of features','fontsize',24)
      ylabel('Error','fontsize',24)
      title(sprintf('Method: %s, Number of features: %d', method, numel(useFeatures)))
     
     figName = sprintf('FIGS/FeatureNumberErrorPlot-%s-nFeatures-%d-seed-%d-%s.pdf', ...
                       method, ...
                       numel(useFeatures), ...
                       seed, ...
                       datestr(now,'yyyy-mm-dd-HH:MM:SS'))
     saveas(gcf,figName,'pdf')
     
     %featureList = {};
     return
  end
  
  toc
                                    
  %  [inmodel, history] = sequentialfs(@critFun,obj.featureMat,obj.RGCtypeID, ...
  %                                  'mcreps',1, ... % must be 1 for CV, otherwise use 10 or so.
  %                                  'cv', cvpartition(numel(obj.RGCtypeID),'leaveout'), ...
  %                                  ... % 'nfeatures', 3, ...
  %                                  'direction','backward', ...
  %                                  'options', statset('useparallel',true));

  fprintf('Error: %.3f, features: ', history.Crit(end))
  
  for i = 1:numel(inmodel)
    if(inmodel(i))
      fprintf('%s ', useFeatures{i})
    end
  end
  fprintf('\n')
  
  featureList = useFeatures{find(inmodel)};
  % keyboard
end