function index = getRGCSubset(obj,subsetType)

  switch(lower(subsetType))
    case 'rana'
      ranaFlag = zeros(numel(obj.RGC),1);
      
      for i = 1:numel(obj.RGC)
        if(strcmpi(obj.RGC(i).xmlFile(end-2:end),'xml'))
          ranaFlag(i) = 1;
        end
      end
      
      index = find(ranaFlag);
      
    case 'sumbul'

      sumbulFlag = zeros(numel(obj.RGC),1);
      
      for i = 1:numel(obj.RGC)
        if(strcmpi(obj.RGC(i).xmlFile(end-2:end),'swc'))
          sumbulFlag(i) = 1;
        end
      end
      
      index = find(sumbulFlag);
      
    otherwise
      fprintf('Unknown subset type: %s, use Rana or Sumbul (or add your own to getRGCSubset)\n',subsetType)
      index = [];
  end
  
end