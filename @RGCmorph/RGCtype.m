function [type,name] = RGCtype(obj)

  % Create a subdirectory with the RGC type name, and then add that
  % name in nameList to define additional RGC types
  
  nameList = {'CB2', ...           % 1 Unique
              'Cdh3', ...          % 2 Two subtypes?
              'DRD4', ...          % 3 Unique
              'Hoxd10', ...        % 4 Two subtypes?
              'TRHR', ...          % 5 Unique
              'BD', ...            % 6
              'JAM-B', ...         % 7
              'K', ...             % 8
              'W3', ...            % 9
              'W7', ...            % 10
              'Hoxd10-ON', ...     % 11
              'Hoxd10-ON-OFF', ... % 12
							'Cdh3-ON', ...       % 13 
							'Cdh3-diving'};   % 14
    
  dirName = upper(obj.xmlDir);

  % Remove trailing slashes
  while(dirName(end) == '/')
    dirName = dirName(1:end-1);
  end

  slashIdx = strfind(dirName,'/');

  if(isempty(slashIdx))
    typeName = dirName;
  end
  
  typeName = dirName(slashIdx(end)+1:end);
  
  if(isempty(typeName))
    disp('Using parent directory name to determine RGC type')
    keyboard
  end
    
  found = 0;
  
  for i = 1:numel(nameList)
    if(strcmpi(typeName,nameList{i}))
      name = nameList{i};
      type = i;
      found = found + 1;
    end
  end
  
  if(found == 0)
    fprintf('File has unknown type: %s\n', obj.xmlFile)
    name = 'Unknown';
    type = -1;
  end
    
  if(found > 1)
    fprintf('Multiple types in file name: %s\n', obj.RGC.filename)
    disp('I am confused!')
    name = 'Ambigious';        
  end
  
end
