function setupGUI(obj)

  obj.fig = figure('name', 'RGC classification');
  
  set(obj.fig,'units','pixels');
  set(obj.fig,'position',[50 50 1150 680]);
  
  obj.guiTrainingPanel = uipanel('Title','Training set', ...
                                 'position', [0.02 0.02 0.15 0.96]);
  
  obj.guiClassificationPanel = uipanel('Title','Classification set', ...
                                       'position', [(0.02*2 + 0.15) 0.02 0.15 0.96]);
  
  obj.guiTrainingList = uicontrol('Style','listbox', ...
                                  'String', 'None', ...
                                  'ToolTipString', ...
                                  'Training set for classification', ...
                                  'Value', [1], ...
                                  'Max', 1, 'Min', 1, ...
                                  'Callback', @removeTrainingSet, ...
                                  'Interruptible', 'off', ...
                                  'Position',[10 10 152 622], ...
                                  'Parent', obj.guiTrainingPanel);
  

  obj.guiClassificationList = uicontrol('Style','listbox', ...
                                        'String', 'None', ...
                                        'ToolTipString', ...
                                        'Data set for classification', ...
                                        'Value', [1], ...
                                        'Max', 1, 'Min', 1, ...
                                        'Callback', @addTrainingSet, ...
                                        'Interruptible', 'off', ...
                                        'Position',[10 10 152 622], ...
                                        'Parent', obj.guiClassificationPanel);

  
  obj.guiButtonAddRandom = uicontrol('Style','pushbutton', ...
                                     'String', 'Add random', ...
                                     'Callback', @addRandomOrdered, ...
                                     'Position', [410 640 90 20]);
  
  obj.guiButtonClearTrainingSet = uicontrol('Style','pushbutton', ...
                                            'String', 'Clear', ...
                                            'Callback', @clearTrainingSet, ...
                                            'Position', [410 610 90 20]);
 
  obj.guiButtonVAChT = uicontrol('Style','pushbutton', ...
                                 'String', 'Edit VAChT', ...
                                 'Callback', @editVAChT, ...
                                 'Position', [410 580 90 20], ...
                                 'interruptible','off');


  obj.guiNeuronPanel = uipanel('Title','No neuron selected', ...
                               'position', [0.45 0.5 0.53 0.48]);
  
  obj.guiNeuronTop = axes('position', [0 0.55 0.5 0.45], ...
                          'parent', obj.guiNeuronPanel);

  obj.guiNeuronSide = axes('position', [0.5 0.55 0.5 0.45], ...
                          'parent', obj.guiNeuronPanel);
  
  
  obj.guiNeuronSpace = axes('Position', [0.1 0.1 0.4 0.4], ...
                            'parent', obj.guiNeuronPanel);

  % By listing feature name and variable as pairs I hope to
  % minimize the risk of mixing them up.
  features = {{'Bistratification distance', 'biStratificationDistance' }, ...
              { 'Stratification depth', 'stratificationDepth' }, ...
              { 'Dendritic Field', 'dendriticField'}, ...
              { 'Density of Branch Points', 'densityOfBranchPoints'},  ...
              { 'Soma Area', 'somaArea'}, ...
              { 'Number of Branch Points', 'numBranchPoints'}, ...
              { 'Number of Segments', 'numSegments'}, ...
              { 'Total Dendriticl Length', 'totalDendriticLength'}, ...
              { 'Mean Axon Thickness', 'meanAxonThickness'}, ...
              { 'Mean Segment Length', 'meanSegmentLength'}, ...
              { 'Mean Terminal Segment Length', 'meanTerminalSegmentLength'}, ...
              { 'Mean Segment Tortuosity', 'meanSegmentTortuosity'}, ...
              { 'Mean Branch Angle', 'meanBranchAngle'}, ...
              { 'Fractal dimension (box counting)', 'fractalDimensionBoxCounting'},...
              { 'Dendritic Density', 'dendriticDensity'}, ...
              { 'Branch assymetry', 'branchAssymetry'}, ...
              { 'Number of leaves', 'numLeaves'}};
  

  featureList = {};
  for iFeat = 1:numel(features)
    featureList{iFeat} = features{iFeat}{1};
  end
  
  obj.guiNeuronSpaceAxis(1) = uicontrol('Style','popupmenu', ...
                                        'String', featureList, ...
                                        'Position', [330 120 180 10], ...
                                        'Parent', obj.guiNeuronPanel, ...
                                        'Value', obj.guiAxisIdx(1), ...
                                        'Callback', @setSpaceAxes);

  obj.guiNeuronSpaceAxis(2) = uicontrol('Style','popupmenu', ...
                                      'String', featureList, ...
                                      'Position', [330 90 180 10], ...
                                      'Parent', obj.guiNeuronPanel, ...
                                      'Value', obj.guiAxisIdx(2), ...
                                      'Callback', @setSpaceAxes);

  obj.guiNeuronSpaceAxis(3) = uicontrol('Style','popupmenu', ...
                                      'String', featureList, ...
                                      'Position', [330 60 180 10], ...
                                      'Parent', obj.guiNeuronPanel, ...
                                      'Value', obj.guiAxisIdx(3), ...
                                      'Callback', @setSpaceAxes);
  
  
  % List the files in the boxes
  obj.updateFileLists();

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function setSpaceAxes(source, event)
    for i = 1:3
      obj.guiAxisIdx(i) = get(obj.guiNeuronSpaceAxis(i),'Value');
    end
    
    plotSpace();
  
  end
  
  function plotSpace()
    
    neuronIdx = obj.currentNeuron;
    
    if(isempty(neuronIdx))
      return
    end
    
    set(obj.fig,'CurrentAxes', obj.guiNeuronSpace);    

    xLab = features{obj.guiAxisIdx(1)}{1};
    yLab = features{obj.guiAxisIdx(2)}{1};
    zLab = features{obj.guiAxisIdx(3)}{1};    
    
    xVal = obj.RGCclass.getVariable(features{obj.guiAxisIdx(1)}{2});
    yVal = obj.RGCclass.getVariable(features{obj.guiAxisIdx(2)}{2});    
    zVal = obj.RGCclass.getVariable(features{obj.guiAxisIdx(3)}{2});  
  
    cla
    % plot3(xVal, yVal, zVal, '.k');
    hold on
    try
      for i = 1:numel(xVal)
        col = obj.classColours(obj.RGCclass.RGC(i).typeID,:);
        plot3(xVal(i), yVal(i), zVal(i), '.', 'color', col);    
      end
    catch e
      getReport(e)
    end
    hold on
    plot3(xVal(neuronIdx),yVal(neuronIdx),zVal(neuronIdx),'ro');
    hold off
    axis tight
    
    xlabel(xLab);
    ylabel(yLab);
    zlabel(zLab);
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function addTrainingSet(source, event)

    if(strcmpi(get(obj.fig,'SelectionType'),'Open'))
      addIdx = get(obj.guiClassificationList,'Value');
      
      obj.RGCclass.trainingIdx = union(addIdx,obj.RGCclass.trainingIdx);
      
      obj.updateFileLists();
    else
      % disp('Add: single click ignored')
      obj.currentNeuron = get(obj.guiClassificationList,'Value');
      showNeuron();
      plotSpace();
    end
      
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function removeTrainingSet(source, event)

    if(strcmpi(get(obj.fig,'SelectionType'),'Open'))
      removeIdx = obj.RGCclass.trainingIdx(get(obj.guiTrainingList,'Value'));
      obj.RGCclass.trainingIdx = setdiff(obj.RGCclass.trainingIdx, removeIdx);
    
      if(get(obj.guiTrainingList,'Value') > 1)
        set(obj.guiTrainingList,'Value',get(obj.guiTrainingList,'Value')-1)
      else
        set(obj.guiTrainingList,'Value',1)        
      end
        
      obj.updateFileLists();
    else
      % disp('Remove: single click ignored')
      obj.currentNeuron = get(obj.guiTrainingList,'Value');
      showNeuron();
      plotSpace();
    
    end
      
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function showNeuron()

    neuronIdx = obj.currentNeuron;    
    
    if(isempty(neuronIdx))
      return
    end
    
    set(obj.guiNeuronPanel,'Title', obj.RGCclass.RGC(neuronIdx).xmlFile);
    set(obj.fig,'CurrentAxes', obj.guiNeuronTop);
    cla
    obj.RGCclass.RGC(neuronIdx).drawNeuron(true,false);
    title([])
    rotate3d on
    axis tight
    axis off
    
    set(obj.fig,'CurrentAxes', obj.guiNeuronSide);    
    cla
    obj.RGCclass.RGC(neuronIdx).drawNeuron(true,false);
    title([])
    rotate3d on
    axis normal
    view([45 10])
    axis tight
    axis off
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function addRandom(source, event)

    allIdx = 1:numel(obj.RGCclass.RGC);
    freeIdx = setdiff(allIdx,obj.RGCclass.trainingIdx);
    
    perm = randperm(numel(freeIdx));
    randIdx = freeIdx(perm(1:min(5,numel(perm))));
    
    obj.RGCclass.trainingIdx = union(obj.RGCclass.trainingIdx, randIdx);

    obj.updateFileLists();
  
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function addRandomOrdered(source, event)

    allIdx = 1:numel(obj.RGCclass.RGC);
    freeIdx = setdiff(allIdx,obj.RGCclass.trainingIdx);
    
    uID = unique(obj.RGCclass.RGCtypeID);
    
    randIdx = [];
    
    for i = 1:numel(uID)

      % Make sure we add one of each type, randomly
      candidateIdx = freeIdx(find(obj.RGCclass.RGCtypeID(freeIdx) == uID(i)));
      perm = randperm(numel(candidateIdx));
      
      if(~isempty(perm))
        randIdx(end+1) = candidateIdx(perm(1));
      end
      
    end

    obj.RGCclass.trainingIdx = union(obj.RGCclass.trainingIdx, randIdx);
    obj.updateFileLists();
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function clearTrainingSet(source, event)
    
    obj.RGCclass.trainingIdx = [];
    obj.updateFileLists();
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Show and edit the VAChT of current neuron shown
  
  function editVAChT(source, event)
  
     if(isempty(obj.currentNeuron))
       disp('No neuron selected')
       return
     end
       
     curRGC = obj.RGCclass.RGC(obj.currentNeuron);
     loadVAChT = true;
     skipGUI = false;
     
     % We need to temporarily reload the VAChT data from disk
     if(isempty(curRGC.lsm))
       curRGC.readLSM(curRGC.lsmFile,curRGC.lsmDir);
       clearLSM = true;
     else
       clearLSM = false;
     end
     
     v = VAChT(curRGC, loadVAChT, skipGUI);
     
     disp('Waiting for user to finish...')

     if(~isempty(v.fig))
       uiwait(v.fig);
       disp('VAChT done, resuming')
     end

     % We need to reanalyse since VAChT might have changed
     showFigures = false;
     curRGC.calculateMeasures(showFigures);
     obj.RGCclass.updateTables(obj.RGCclass.featuresUsed)
     obj.updateFileLists();
     showNeuron();
     plotSpace();
     
     % Throw away LSM file
     if(clearLSM)
       curRGC.lsm = [];
     end
     
  end
  
end



  
