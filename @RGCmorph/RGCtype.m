function [type,name] = RGCtype(obj)

  % Create a subdirectory with the RGC type name, and then add that
  % name in nameList to define additional RGC types
    
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
  
  for i = 1:numel(obj.nameList)
    if(strcmpi(typeName,obj.nameList{i}))
      name = obj.nameList{i};
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
