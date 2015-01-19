classdef RGCgui < handle
  
  properties
    
    RGCclass = [];
    fig = [];
    
    guiTrainingPanel = [];
    guiClassificationPanel = [];
    
    guiTrainingList = [];
    guiClassificationList = [];
    
    guiButtonAddRandom = [];
    guiButtonClearTrainingSet = [];
    guiButtonVAChT = [];
    
    guiNeuronPanel = [];
    guiNeuronTop = [];
    guiNeuronSide = [];    
    
    guiNeuronSpace = [];
    guiNeuronSpaceAxis = [];
    guiAxisIdx = [8 11 15];

    currentNeuron = [];
    
    % classColours = [166,206,227; 31,120,180; ...
    %                 178,223,138; 51,160,44; ...
    %                 251,154,153; 227,26,28; ...
    %                 253,191,111] / 255;

    % Change these if you need more or different colours in the plots
    
    classColours = [228,26,28; 55,126,184; 
                    77,175,74; 152,78,163;
                    255,127,0] / 255;
    
    % classColours = [166,206,227;
    %                 31,120,180;
    %                 178,223,138;
    %                 51,160,44;
    %                 251,154,153;
    %                 227,26,28;
    %                 253,191,111;
    %                 255,127,0;
    %                 202,178,214;
    %                 106,61,154] /255;
    
  end
  
  methods
    
    function obj = RGCgui(RGCclassObj)
    
      obj.RGCclass = RGCclassObj;
    
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    setupGUI(obj);
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function updateFileLists(obj)
   
      % To get coloured text
      % set(g.guiTrainingList,'String','<html><font color=red>Test</font></html>')
      
      [correctFlag,group] = obj.classifyNeurons();
      
      
      if(~isempty(correctFlag))
        trainingList = {};
        for i = 1:numel(obj.RGCclass.trainingIdx)
          if(correctFlag(obj.RGCclass.trainingIdx(i)))
            trainingList{i} = sprintf('<html><font color=black>%s</font></html>',...
                                      obj.RGCclass.RGC(obj.RGCclass.trainingIdx(i)).xmlFile);
          else
            trainingList{i} = sprintf('<html><font color=red>%s</font></html>',...
                                      obj.RGCclass.RGC(obj.RGCclass.trainingIdx(i)).xmlFile);
            
          end
        end
        
        set(obj.guiTrainingList, 'String', char(trainingList));
        
        classificationList = {};
        for i = 1:numel(obj.RGCclass.RGC)
          if(correctFlag(i))
            classificationList{i} = sprintf('<html><font color=black>%s</font></html>',...
                                            obj.RGCclass.RGC(i).xmlFile);
            
          else
            classificationList{i} = sprintf('<html><font color=red>%s</font></html>',...
                                            obj.RGCclass.RGC(i).xmlFile);
            
          end
        end
      
        set(obj.guiClassificationList, 'string', classificationList)

        
      else
        try
          if(~isempty(obj.RGCclass.trainingIdx))
            set(obj.guiTrainingList, ...
                'String', char(obj.RGCclass.RGC(obj.RGCclass.trainingIdx).xmlFile));
          else
            set(obj.guiTrainingList, 'String', [])
          end
          
          set(obj.guiClassificationList, ...
              'String', char(obj.RGCclass.RGC(:).xmlFile));
        catch e
          getReport(e)
          keyboard
        end
      end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function [correctFlag,group] = classifyNeurons(obj)
      
      % Check that we have enough training data
      uID = unique(obj.RGCclass.RGCtypeID);
      
      allOK = true;
      for i = 1:numel(uID)
        % At least three of each
        if(nnz(uID(i) == obj.RGCclass.RGCtypeID(obj.RGCclass.trainingIdx)) < 3)
          allOK = false;
        end
      end
      
      if(~allOK || numel(uID) == 0)
        correctFlag = [];
        group = [];
        return
      end
      
      obj.RGCclass.train();
      group = obj.RGCclass.classify();
      
      try
        correctFlag = (group == obj.RGCclass.RGCtypeID);
      catch e
        getReport(e)
        keyboard
      end
      
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function setClassColours(obj,nColours)
      
      switch(nColours)
        
        case 5
          
          obj.classColours = [228,26,28; 55,126,184; 
                              77,175,74; 152,78,163;
                              255,127,0] / 255;
          
        case 10
          
          obj.classColours = [166,206,227;
                              31,120,180;
                              178,223,138;
                              51,160,44;
                              251,154,153;
                              227,26,28;
                              253,191,111;
                              255,127,0;
                              202,178,214;
                              106,61,154] /255;
          
        otherwise
          
          obj.classColours = [228,26,28; 55,126,184; 
                              77,175,74; 152,78,163;
                              255,127,0] / 255;
          
          
        
      end
      
    end
    
    
  end
  
end
