function readXML(obj,filename,dataDir)

  obj.xmlFile = filename;
  obj.xmlDir = dataDir;
  
  % Lets clear the old tree first

  obj.somaContours = {};
  obj.axon = [];
  obj.dendrite = [];
  
  % filename = '/Users/hjorth/DATA/RanaEldanaf/CB2-06202012-new.xml';
  fprintf('Loading neuron: %s\n', filename)
  
  if(~isempty(dataDir))
    fName = sprintf('%s/%s',dataDir,filename);
  else
    fName = filename;
  end
  
  xDoc = xmlread(fName);
  xRoot = xDoc.getDocumentElement();
  xChild = xRoot.getFirstChild();
  
  while(~isempty(xChild))
    switch(char(xChild.getNodeName))
      
      case 'contour'
        % disp('Contour found.')
        
        obj.somaContours{end+1} = parseContour(xChild);
        
      case 'tree'
        % disp('Found tree')
        [aTree,aType] = parseTree(xChild,0,0);
        
        switch(aType)
          case 'Axon'
            if(isempty(obj.axon))
              obj.axon = aTree;
            else
              obj.axon(end+1) = aTree;
            end
          case 'Dendrite'
            if(isempty(obj.dendrite))
              obj.dendrite = aTree;
            else
              obj.dendrite(end+1) = aTree;
            end
            
        end
        
      case '#text'
        % Just ignore text

      case {'filefacts','thumbnail'}
        % Ignore
        
      case {'images'}

        % Just display some debug info
        parseImages(xChild)
        
      otherwise
        fprintf('Unknown NodeName: %s\n', char(xChild.getNodeName))

    end
    
    xChild = xChild.getNextSibling();
  end
  
  % Finally update z-coordinates
  
  obj.zCoordsXML = (0:(obj.nSlicesXML-1))*obj.zScaleXML + obj.zOffsetXML;
  
  % Save coordinates for soma
  getSomaCentre();
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function getSomaCentre()
      
    s = NaN*zeros(numel(obj.somaContours),2);
    maxZ = -inf;  
    
    for i = 1:numel(obj.somaContours)
      if(~isempty(obj.somaContours{i}))
        try
          s(i,:) = mean(obj.somaContours{i}(:,1:2));
          maxZ = max(max(obj.somaContours{i}(:,3)),maxZ);
        catch e
          getReport(e)
          keyboard
        end
      end
    end

    obj.xSoma = mean(s(:,1));
    obj.ySoma = mean(s(:,2));
    obj.zSoma = maxZ; % Use the top of the soma as reference point
            
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function parseImages(node)
    
    % This just displays the resolution of the images
    nChild = node.getFirstChild();
    nLSMfound = 0;
    
    while(~isempty(nChild))

      switch(char(nChild.getNodeName))
        
        case 'image'
         
          nCh = nChild.getFirstChild();
          filenameChecked = false;
          
          while(~isempty(nCh))
            % We have to be careful here, we only want the data
            % that is associated with our lsm image, not the jpx
            % image that might be around.
            
            switch(char(nCh.getNodeName))
              
              case 'filename'
                fullFile = char(nCh.getTextContent());
                try
                  if(numel(fullFile) > 4 & ...
                     strcmpi(fullFile(end-3:end),'.lsm'))
                    % lsm file, good to go.
                    fprintf('Reading xml image info for: %s\n', fullFile)
                    filenameChecked = true;
                    nLSMfound = nLSMfound + 1;
                    
                    if(nLSMfound > 1)
                      fprintf(['!!! Found more than one LSM image, ' ...
                               'double check z offsett for VAChT band.\n'])
                      beep
                      nCh = nCh.getNextSibling();
                                  
                    end
                  else
                    % This is not a lsm file, skip the rest of the attributes
                    fprintf('Skipping non-lsm info for offset and scale: %s\n', fullFile)
                    nCh = [];
                    filenameChecked = false;
                    continue
                  end
                catch e
                  getReport(e)
                  keyboard
                end
                
              case 'scale'
                
                try
                  assert(filenameChecked); % The filename should be
                                           % first value read and checked
                catch e
                  getReport(e)
                  keyboard
                end
                  
                xScale = str2num(nCh.getAttribute('x'));
                yScale = str2num(nCh.getAttribute('y'));
            
                fprintf('xScale: %d, yScale: %d\n', ...
                        xScale, yScale)

                if(nLSMfound > 1)
                  % Do not overwrite info from first file
                  nCh = nCh.getNextSibling();
                  continue
                end                
                
                obj.xScaleXML = xScale;
                obj.yScaleXML = yScale;
                
              case 'zspacing'
                
                assert(filenameChecked); % The filename should be
                                         % first value read and checked
                
                zScale = str2num(nCh.getAttribute('z'));
                nSlices = str2num(nCh.getAttribute('slices'));
                
                fprintf('zScale: %d (n = %d)\n', ...
                        zScale, nSlices)
                
                if(nLSMfound > 1)
                  % Do not overwrite info from first file
                  nCh = nCh.getNextSibling();
                  continue
                end                
                
                obj.zScaleXML = zScale;
                obj.nSlicesXML = nSlices;
                
              case 'coord'
                
                assert(filenameChecked); % The filename should be
                                         % first value read and checked
                
                xOffset = str2num(nCh.getAttribute('x'));
                yOffset = str2num(nCh.getAttribute('y'));
                zOffset = str2num(nCh.getAttribute('z'));
                
                % This should never be non-zero
                if(abs(xOffset) > 1 || abs(yOffset) > 1);
                  fprintf('!!! xOffset = %.3f, yOffset = %.3f\n', ...
                          xOffset, yOffset)
                  beep
                end
                  
                if(nLSMfound > 1)
                  % Do not overwrite info from first file
                  nCh = nCh.getNextSibling();
                  continue
                end
                
                obj.xOffsetXML = xOffset;
                obj.yOffsetXML = yOffset;
                
                % This seems to change...
                obj.zOffsetXML = zOffset;                
                
            end
            
            nCh = nCh.getNextSibling();
          
          end
          
      end
      
      nChild = nChild.getNextSibling();

    end
      
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function coords = parseContour(node)

    nChild = node.getFirstChild();
    coords = [];
    
    while(~isempty(nChild))
    
      switch(char(nChild.getNodeName))
        case 'point'
          x = str2num(nChild.getAttribute('x'));
          y = str2num(nChild.getAttribute('y'));
          z = str2num(nChild.getAttribute('z'));
          coords = [coords; x,y,z];
        case '#text'
          % Just ignore text
        case 'property'
          % Ignore the GUID property
        case 'resolution'
          % Ignoring resolution
        otherwise
          % Ignore
          fprintf('Ignoring: %s\n', char(nChild.getNodeName))
      end
      
      nChild = nChild.getNextSibling();
    end
      
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function [tree,type] = parseTree(node,somaDist,branchOrder)

    type = char(node.getAttribute('type'));
    
    % somaDist is the distance to the soma for the proximal end of the branch
    tree = struct('coords',[],'diameter',[],'branches',[],'somaDist',0,'branchOrder',0);
      
    tree.somaDist = somaDist;
    tree.branchOrder = branchOrder;
    
    nChild = node.getFirstChild();
    while(~isempty(nChild))
      
      switch(char(nChild.getNodeName))
        case 'point'
          x = str2num(nChild.getAttribute('x'));
          y = str2num(nChild.getAttribute('y'));
          z = str2num(nChild.getAttribute('z'));
          tree.coords = [tree.coords; x,y,z];

          d = str2num(nChild.getAttribute('d'));          
          tree.diameter = [tree.diameter; d];
          
        case 'branch'
          x = tree.coords(:,1);
          y = tree.coords(:,2);
          z = tree.coords(:,3);
          len = sum(sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2));
          somaDist = tree.somaDist + len;
          branchOrder = tree.branchOrder + 1;
          
          [branch,~] = parseTree(nChild,somaDist,branchOrder);
          
          try
          if(isempty(tree.branches))
            tree.branches = branch;
          else
            tree.branches(end+1) = branch;
          end
          catch e
            getReport(e)
            keyboard
          end
            
        case '#text'
          % Just ignore text
        case 'property'
          % Ignore the GUID property
          
        otherwise
          fprintf('Ignoring: %s\n', char(nChild.getNodeName))        
      end
      
      nChild = nChild.getNextSibling();
    end

  end
  
end