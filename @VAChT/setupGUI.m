function setupGUI(obj)
      
  workBlind = true;
  
  if(workBlind)
    figName = 'Blind mode enabled, not showing filename in GUI';
  else
    figName = sprintf('VAChT band markup: %s', obj.rgc.xmlFile);
  end
  
  if(isempty(obj.fig) | isempty(findobj('type','figure','name',figName)))
    obj.fig = figure('name',figName);
    
    enableDebug = true;
    
    if(enableDebug)

      menuDebug = uimenu(obj.fig,'Label','Debug');
      menuItemDebug = uimenu(menuDebug, ...
                             'Label','Keyboard', ...
                             'Interruptible', 'off', ...
                             'Callback', @runDebug);
      
    end

    
    
    set(obj.fig,'units','pixels');
    set(obj.fig,'position',[50 50 1150 680]);
    
    % Set up axes
    obj.guiNeuron = axes('units','pixels', ...
                         'position',[50 50 615 615]);
  
    obj.guiHistogram = axes('units','pixels', ...
                            'position', [700 50 400 200]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    obj.guiUpperVAChT = uicontrol('style','slider', ...
                                  'Max',max(obj.z),'Min',min(obj.z), ...
                                  'Value', NaN, ...
                                  'Position', [700 300 400 50], ...
                                  'Callback', @setVAChT);
    
    obj.guiLowerVAChT = uicontrol('style','slider', ...
                                  'Max',max(obj.z),'Min',min(obj.z), ...
                                  'Value', NaN, ...
                                  'Position', [700 265 400 50], ...
                                  'Callback', @setVAChT);
  
    obj.guiText = uicontrol('style','text', ...
                            'string', 'Move sliders to set VAChT extent',  ...
                            'HorizontalAlignment', 'left', ...
                            'Foregroundcolor', 0*[1 1 1], ...
                            'Backgroundcolor', 0.8*[1 1 1], ...
                            'Position', [700 350 400 50], ...
                            'Fontsize',12);                                
  
    obj.guiStratificationDepth = uicontrol('style','slider', ...
                                           'Max',max(obj.dendbinCenters),'Min',min(obj.dendbinCenters), ...
                                           'Value', NaN, ...
                                           'Position', [700 230 400 50], ...
                                           'Callback', @setVAChT);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    obj.guiPlaneCheckbox = uicontrol('style','checkbox', ...
                                     'position', [700 450 15 15], ...
                                     'Value', obj.optimizePlane, ...
                                     'Callback', @setPlane);
    obj.guiPlaneText = uicontrol('style','text', ...
                                 'position', [725 450 200 15], ...
                                 'backgroundcolor',0.8*[1 1 1], ...
                                 'horizontalalignment','left',...
                                 'String','Optimize plane orientation', ...
                                 'fontsize', 12);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    obj.guiSliceCheckbox = uicontrol('style','checkbox', ...
                                     'position', [700 500 15 15], ...
                                     'Value', false, ...
                                     'Callback', @setVisible);
    obj.guiSliceText = uicontrol('style','text', ...
                                 'position', [725 500 200 15], ...
                                 'backgroundcolor',0.8*[1 1 1], ...
                                 'horizontalalignment','left',...
                                 'String','Show VAChT slice', ...
                                 'fontsize', 12);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    obj.guiContourCheckbox = uicontrol('style','checkbox', ...
                                       'position', [700 530 15 15], ...
                                       'Value', true, ...
                                       'Callback', @setVisible);
    obj.guiContourText = uicontrol('style','text', ...
                                   'position', [725 530 200 15], ...
                                   'backgroundcolor',0.8*[1 1 1], ...
                                   'horizontalalignment','left',...
                                   'String','Show VAChT iso contour', ...
                                   'fontsize', 12);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    obj.guiContinueButton = uicontrol('Style','pushbutton', ...
                                      'String','Continue (and save)', ...
                                      'Position', [700 570 150 25], ...
                                      'interruptible','off', ...
                                      'Callback', @saveVAChTandExit);
    
    obj.guiRedetectButton = uicontrol('Style','pushbutton', ...
                                      'String','Re-detect', ...
                                      'Position', [870 570 150 25], ...
                                      'Callback', @redetect);
    
    obj.guiIsoThresholdText = uicontrol('Style','text', ...
                                        'position', [930 400 160 25], ...
                                        'backgroundcolor',0.8*[1 1 1], ...
                                        'horizontalalignment','left',...
                                        'String','Iso Threshold (0.0-100.0):', ...
                                        'fontsize', 12);   
    
    obj.guiIsoThreshold = uicontrol('Style','edit', ...
                                    'String',sprintf('%.2f',obj.isoSurfaceThreshold), ...
                                    'Position', [1090 400 40 25], ...
                                    'Callback', @updateIsoContour);
    
    obj.guiPlaneTiltText = uicontrol('Style','text', ...
                                     'position', [700 400 100 25], ...
                                     'backgroundcolor',0.8*[1 1 1], ...
                                     'horizontalalignment','left',...
                                     'String','Plane tilt:', ...
                                     'fontsize', 12);  
    
    obj.guiPlaneTiltX = uicontrol('Style','edit', ...
                                  'String',sprintf('%.2f',obj.planeTiltX*180/pi), ...
                                  'Position', [800 400 40 25], ...
                                  'Callback', @updatePlaneTilt);
    
    obj.guiPlaneTiltY = uicontrol('Style','edit', ...
                                    'String',sprintf('%.2f',obj.planeTiltY*180/pi), ...
                                    'Position', [850 400 40 25], ...
                                    'Callback', @updatePlaneTilt);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    obj.guiStatus = uicontrol('Style','text', ...
                              'position', [700 610 250 25], ...
                              'backgroundcolor',0.8*[1 1 1], ...
                              'horizontalalignment','left',...
                              'String','', ...
                              'fontsize', 12);                              
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
                                           
    obj.guiStratificationButtonGroup = uibuttongroup('units','pixels', ...
                                                     'SelectionChangeFcn', ...
                                                     @setStratification, ...
                                                     'position', [930 470 180 80]);

    obj.guiStratificationText = uicontrol('style','text', ...
                                          'parent', obj.guiStratificationButtonGroup, ...
                                          'position', [10 40 140 30], ...
                                          'horizontalalignment','left',...
                                          'String','Bistratifying dendrites', ...
                                          'fontsize', 12);
    
    
    obj.guiBiStratYes =  uicontrol('style','radiobutton', ...
                                   'parent', obj.guiStratificationButtonGroup, ...
                                   'position', [10 20 20 20], ...
                                   'horizontalalignment','left',...
                                   'Min', 0, 'Max', 1, 'value', 0, ...
                                   'fontsize', 12);
    
    obj.guiBiStratNo =  uicontrol('style','radiobutton', ...
                                  'parent', obj.guiStratificationButtonGroup, ...
                                  'position', [70 20 20 20], ...
                                  'horizontalalignment','left',...
                                  'Min', 0, 'Max', 1, 'value', 0, ...
                                  'fontsize', 12);

    obj.guiBiStratUnknown =  uicontrol('style','radiobutton', ...
                                       'parent', obj.guiStratificationButtonGroup, ...
                                       'position', [130 20 20 20], ...
                                       'horizontalalignment','left',...
                                       'Min', 0, 'Max', 1, 'value', 1, ...
                                       'fontsize', 12);    
    
    obj.guiBiStratYesText = uicontrol('style','text', ...
                                      'parent', obj.guiStratificationButtonGroup, ...
                                      'position', [30 20 40 20], ...
                                      'horizontalalignment','left',...
                                      'String','Yes', ...
                                      'fontsize', 12);

    obj.guiBiStratNoText = uicontrol('style','text', ...
                                     'parent', obj.guiStratificationButtonGroup, ...
                                     'position', [90 20 40 20], ...
                                     'horizontalalignment','left',...
                                     'String','No', ...
                                     'fontsize', 12);

    obj.guiBiStratUnknown = uicontrol('style','text', ...
                                      'parent', obj.guiStratificationButtonGroup, ...
                                      'position', [150 20 20 20], ...
                                      'horizontalalignment','left',...
                                      'String','?', ...
                                      'fontsize', 12);
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % set(obj.fig,'toolbar','figure')
  
    % Make mouse rotate view
    set(obj.fig,'currentaxes',obj.guiNeuron);
    rotate3d on
    view([45 10])

    % Auto-detect plane
    setPlane();
    
    % Show/hide the 3D contours and slice
    setVisible();
    
  end
  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function val = onOff(flag)
    if(flag)
      val = 'on';
    else
      val = 'off';
    end
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function saveVAChTandExit(source,event)
    
    % Double check that bistratifying flag is set
    if(obj.biStratified ~= 0 & obj.biStratified ~= 1)
      answer = questdlg('Bistratified set to unknown, is that your wish?',...
                        'Input alert', 'Yes','No', 'No')
      
      if(strcmpi(answer,'No'))
        % Allow the user to change their answer
        disp('User wants to change bistratified flag, abort save')
        return
      end
    end
      
    obj.updateRGC();
    
    obj.saveVAChT();

    saveHistogram();
    
    f = obj.fig;
    obj.fig = [];
    close(f);
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function saveHistogram()
    
    fName = sprintf('FIGS/SliceHistogram-%s.pdf', strrep(obj.rgc.xmlFile,'.xml',''));
    fprintf('Writing %s\n', fName)
    f = figure('visible','off');
    c = copyobj(obj.guiHistogram,f);
    set(c,'units','normal')
    set(c, 'Position', get(0, 'DefaultAxesPosition'))
    title(obj.rgc.lsmFile)
    saveas(f,fName,'pdf');
    close(f);
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function redetect(source, event)
    
    % We can use the same function as the checkbox
    setPlane(source, event);
    
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function setVisible(source, event)

    set(obj.sliceH,'visible', onOff(get(obj.guiSliceCheckbox,'Value')));
    set(obj.contourH,'visible', onOff(get(obj.guiContourCheckbox,'Value')));  
  
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function setPlane(source, event)
    
    % Setting the planes overwrites any manual changes
    obj.manualOverride = false;
    
    obj.optimizePlane = get(obj.guiPlaneCheckbox,'Value');
    
    if(obj.optimizePlane)
      obj.nBins = numel(obj.rgc.zCoordsXML); % Used to be 50
      
    else
      obj.nBins = numel(obj.rgc.zCoordsXML);
    end

    % Clear user tilts
    obj.manualPlaneTilt = false;
    
    obj.planeNormal = obj.getPlaneOrientation();

    [obj.VAChTdUpper, obj.VAChTdLower] = ...
        obj.calcVAChTHist(obj.fractionOfVAChTpeak);
          
    obj.stratificationDepth = obj.calcDendHist();
    
    % When user switches plane orientation, we reautodetect the
    % plane location
    
    set(obj.guiUpperVAChT,'Value',obj.VAChTdUpper, ...
                      'min', min(obj.VAChTbinCenters), ...
                      'max', max(obj.VAChTbinCenters));
    
    set(obj.guiLowerVAChT,'Value',obj.VAChTdLower, ...    
                      'min', min(obj.VAChTbinCenters), ...
                      'max', max(obj.VAChTbinCenters));
    
    set(obj.guiStratificationDepth,'Value',obj.stratificationDepth, ...
                      'min', min(obj.dendbinCenters), ...
                      'max', max(obj.dendbinCenters));
    
    obj.updateGUI();
    obj.plot();
    
    set(obj.guiStatus,'String','VAChT bands auto-detected')

    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Internal function to handle GUI events
        
  function setVAChT(source, event)

    % The user has manually changed the values
    obj.manualOverride = true;
    
    obj.VAChTdUpper = get(obj.guiUpperVAChT,'Value');
    obj.VAChTdLower = get(obj.guiLowerVAChT,'Value');
    obj.stratificationDepth = get(obj.guiStratificationDepth,'Value')
    
    if(obj.VAChTdUpper < obj.VAChTdLower)
      disp('Upper VAChT must be above lower band')
      obj.VAChTdUpper = obj.VAChTdLower;
      
      set(obj.guiUpperVAChT,'value',obj.VAChTdUpper);
    end
    
    % Update graphics
          
    obj.updateGUI();
          
    set(obj.guiStatus,'String','VAChT bands manually adjusted')    
    
  end
        
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function setStratification(source, event)
  
    % Make sure this is the right function
    try
      assert(strcmpi(event.EventName,'SelectionChanged'))
    catch e
      getReport(e)
      keyboard
    end
      
    switch(event.NewValue)
      case obj.guiBiStratYes
        set(obj.guiBiStratYes,'value',1)
        set(obj.guiBiStratNo,'value',0)            
        set(obj.guiBiStratUnknown,'value',0)                        
        obj.biStratified = 1;    
        
      case obj.guiBiStratNo
        set(obj.guiBiStratYes,'value',0)
        set(obj.guiBiStratNo,'value',1)            
        set(obj.guiBiStratUnknown,'value',0)    
        obj.biStratified = 0;
        
      case obj.guiBiStratUnknown
    
        set(obj.guiBiStratYes,'value',0)
        set(obj.guiBiStratNo,'value',0)            
        set(obj.guiBiStratUnknown,'value',1)    
        obj.biStratified = 0.5;
        
      otherwise
        disp('Uh?!')
        keyboard
    end
    
  end
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function updateIsoContour(source, event)
    
    tmpVal = str2num(get(obj.guiIsoThreshold,'String'));
    if(~isempty(tmpVal))
      obj.isoSurfaceThreshold = tmpVal;
      set(obj.guiIsoThreshold,'String',sprintf('%.2f',obj.isoSurfaceThreshold))

      fprintf('Setting iso contour to %.3f percentile\n', obj.isoSurfaceThreshold)
    
      if(~isempty(obj.contourH))
        delete(obj.contourH);
        obj.contourH = [];
      end
    
      obj.plot();
    else
      % Unable to interpret number, overwrite string in input box
      set(obj.guiIsoThreshold,'String',sprintf('%.2f',obj.isoSurfaceThreshold))
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function updatePlaneTilt(source, event)
    
    tiltX = str2num(get(obj.guiPlaneTiltX,'String')) * pi/180;
    tiltY = str2num(get(obj.guiPlaneTiltY,'String')) * pi/180;
    
    if(isempty(tiltX) || isempty(tiltY))
      % Reset numbers
      set(obj.guiPlaneTiltX,'String',sprintf('%.2f',obj.planeTiltX))
      set(obj.guiPlaneTiltY,'String',sprintf('%.2f',obj.planeTiltY))
          
      return
    end
    
    RX = [1 0 0; 0 cos(tiltX) -sin(tiltX); 0 sin(tiltX) cos(tiltX)];
    RY = [cos(tiltY) 0 sin(tiltY); 0 1 0; -sin(tiltY) 0 cos(tiltY)];
    
    obj.manualPlaneNormal = RY*RX*[0; 0; 1];
    obj.planeNormal = obj.manualPlaneNormal;

    disp(['Input for plane normal are in degrees, but note that the ' ...
          'z-axis is scaled up, so the plane appears more tilted ' ...
          'than it is.'])
    
    obj.planeTiltX = tiltX;
    obj.planeTiltY = tiltY;    
    
    obj.manualOverride = true; % Flag to indiciate something changed
    obj.manualPlaneTilt = true;
    obj.optimizePlane = false;
    
    obj.stratificationDepth = obj.calcDendHist();

    [obj.VAChTdUpper, obj.VAChTdLower] = ...
        obj.calcVAChTHist(obj.fractionOfVAChTpeak);
    
    % When user changes plane orientation, we reautodetect the
    % plane location
    
    set(obj.guiUpperVAChT,'Value',obj.VAChTdUpper, ...
                      'min', min(obj.VAChTbinCenters), ...
                      'max', max(obj.VAChTbinCenters));
    
    set(obj.guiLowerVAChT,'Value',obj.VAChTdLower, ...    
                      'min', min(obj.VAChTbinCenters), ...
                      'max', max(obj.VAChTbinCenters));
    
    set(obj.guiStratificationDepth,'Value',obj.stratificationDepth, ...
                      'min', min(obj.dendbinCenters), ...
                      'max', max(obj.dendbinCenters));
    
    set(obj.guiStatus,'String','Manual adjusted plane orientation')
    
    obj.updateGUI();
    obj.plot();
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function runDebug(source, event)
    disp('Type return (or dbquit) to exit debug mode, dbstack gives the stack')
    keyboard
  end
  
end
