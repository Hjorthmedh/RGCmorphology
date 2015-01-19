% By doing loadDirectory(-1) you load the default directory (from cache if possible), (re)analyse
% loadDirectory(-1,false) --- skips cached data, and reloads and reanalyses
% loadDirectory(-1,true,false) --- loads cache, doesnt reanalyse

function loadDirectory(obj,dataDir,loadCache,reanalyse,randomOrder)

  if(~exist('dataDir') | isempty(dataDir))
    dataDir = uigetdir();
    
    if(dataDir == 0)
      % User cancelled
      return
    end
  end
  
  if(~exist('loadCache'))
    loadCache = true;
  end
  
  % Only valid if loadCache is set to true
  if(~exist('reanalyse'))
    reanalyse = true;
  end
  
  if(~exist('randomOrder'))
    randomOrder = false;
  end
  
  loadVAChTflag = true; % Should we use the previously stored VAChT
                        % band location?
  
  skipList = {};
  clearLSM = true;

  tic
  
  allFilesXML = dir(sprintf('%s/*.xml', dataDir));
  allFilesSWC = dir(sprintf('%s/*.swc', dataDir));  
  
  allFiles = [allFilesXML;allFilesSWC];
  
  allDirs = {};
  for i = 1:numel(allFiles)
    allDirs{i} = dataDir;
  end
    
  % Look through any subdirectories
  dirinfo = dir(dataDir);
  dirinfo(~[dirinfo.isdir]) = [];
  
  fid = fopen('loadlog.txt','w');
  
  for i = 1:numel(dirinfo)

    if(strcmp(dirinfo(i).name,'.') | strcmp(dirinfo(i).name,'..'))
      % Skip current directory, and parent directory
      continue
    end
    
    dPath = sprintf('%s/%s', dataDir, dirinfo(i).name);
    
    XMLfiles = dir(sprintf('%s/*.xml', dPath));
    SWCfiles = dir(sprintf('%s/*.swc', dPath));    

    allFiles = [allFiles;XMLfiles;SWCfiles];
    
    for j = 1:numel(XMLfiles)
      allDirs{end+1} = dPath;
    end

    for j = 1:numel(SWCfiles)
      allDirs{end+1} = dPath;
    end

    
  end
  
  if(randomOrder)
    disp('Shuffling the order of the files')
    randIdx = randperm(numel(allFiles));
    allFiles = allFiles(randIdx);
    allDirs = allDirs(randIdx);
  end
    
  for i = 1:numel(allFiles)
    try
      fprintf(fid,'Loading: %s\n', allFiles(i).name)
      loadFile(allFiles(i).name,allDirs{i});
    catch e
      getReport(e)
      keyboard
    end
  end
  
  fclose(fid);
  
  try
    obj.updateTables(obj.featuresUsed);
  catch e
    getReport(e)
    keyboard
  end
    
  for i = 1:numel(skipList)
    fprintf('Could not find VAChT bands for: %s (IGNORED)\n', ...
            skipList{i})
  end
  
  obj.getUniqueNames();
  
  if(isempty(obj.RGC))
    disp('No files loaded.')
  end
  
  toc
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function loadFile(name,dataPath)
    
    r = RGCmorph(name, dataPath, loadCache);
      
    if(~checkLSM(r) & obj.skipNeuronsWithoutVAChT)
      % Bad LSM file, no VAChT band
      skipList{end+1} = r.xmlFile;
      return
    end
      
    r.checkCoords();
    r.analyse(loadVAChTflag);
    r.save();
    
    if(clearLSM)
      % Clear the LSM file, because it takes a lot of memory
      disp('loadDirectory: Clearing LSM file')
      r.lsm.image = [];
      r.lsm.fileName = {};
      r.lsm = [];
    end
    
    % Remove plots from screen
    close all
    
    if(isempty(obj.RGC))
      obj.RGC = r;
    else
      obj.RGC(end+1) = r;
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function LSMok = checkLSM(rObj)
    
    LSMok = true;
    
    % Check to see if the LSM image exists, and is non-zero
    if(isempty(rObj.lsm) | nnz(rObj.lsm.image(:,:,3,:)) == 0)
      fprintf('!!! No VAChT band found, skipping VAChT analysis for cell: %s\n', rObj.xmlFile)
      LSMok = false;
      rObj.hasVAChT = false;
    end
      
    % Also we need to check that the number of images in the LSM
    % file matches the number of Z positions in the XML file
    
    if(LSMok & rObj.nSlicesXML ~= size(rObj.lsm.image,4))
      fprintf('!!! Found %d planes in LSM file, but only %d planes used in XML, skipping.', ...
              size(rObj.lsm.image,4), ...
              rObj.nSlicesXML)
      LSMok = false;
      rObj.hasVAChT = false;
    end
      
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end
