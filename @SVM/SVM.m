classdef SVM < handle
  
  properties
    
    svmModel = {};
    classID = [];
    C = 1;
    sigma = 1; % Not used by fitcsvm
    kernelFunc = 'rbf'; %'polynomial'; %'gaussian'; %'rbf';
    
  end

  methods
    
    % Constructor
    
    function obj = SVM(trainingMat,classID)
            
      if(~exist('trainingMat') | ~exist('classID'))
        disp('trainingMat or classID missing, doing nothign')
        return
      end
      
      obj = obj.train(trainingMat,classID);
      
    end
    
    function obj = train(obj,trainingMat,classID)
    
      obj.classID = unique(classID);
      
      % Clean old classifiers
      obj.svmModel = {};
      
      % Train multiple one class against rest of class SVMs

      for i = 1:numel(obj.classID)
        
        inIdx = find(obj.classID(i) == classID);
        outIdx = find(obj.classID(i) ~= classID);
        
        groupID = NaN*ones(size(classID));
        groupID(inIdx) = 1;
        groupID(outIdx) = -1;
        
        % Cant use svmtrain since svmclassify does not return score
        % obj.svmModel{i} = svmtrain(trainingMat,groupID, ...
        %                            'kernel_function',obj.kernelFunc, ...
        %                            'rbf_sigma',obj.sigma, ...
        %                            'BoxConstraint',obj.C);

        obj.svmModel{i} = fitcsvm(trainingMat,groupID, ...
                                  'kernelfunction',obj.kernelFunc, ...
                                  'kernelscale', 'auto', ...
                                  'BoxConstraint',obj.C, ...
                                  'ClassNames',[1 -1]);
        
      end
      
    end
    
    function classID = predict(obj,featureMat)

      classID = NaN * ones(size(featureMat,1),1);
      
      for i = 1:numel(classID)
        
       try 
        classID(i) = obj.predictVector(featureMat(i,:));
       catch e
         getReport(e)
         keyboard
       end
      end
      
    end
      
    function classID = predictVector(obj,featureVector)      
      
     try
       
      score = zeros(numel(obj.svmModel),1);
      
      % Classify by picking most likely predictor
      for i = 1:numel(obj.svmModel)
        try
          [~,classScores] = obj.svmModel{i}.predict(featureVector);
          % svmclassify does not return the score, cant use it... 
          % groupID = svmclassify(obj.svmModel{i},featureVector);
        catch e
          getReport(e)
          keyboard
        end
        
        scores(i) = classScores(1);
      end

      % First column is class score (second column is "all other
      % classes score")
      [~,sortIdx] = sort(scores,'descend');
      classID = obj.classID(sortIdx(1));
      
     catch e
       getReport(e)
       keyboard
     end
      
    end
      
  end
  
end
