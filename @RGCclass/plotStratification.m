function plotStratification(obj)

  if(0)

    figure('name','Stratification')
    hold on
  
    for i = 1:numel(obj.RGC)
      switch(obj.RGC(i).typeID)
        case 0
          % Unknown
          col = [0 0 0];
        case 1
          col = [1 0 0];
        case 2
          col = [0 0.5 0.5];
        case 3
          col = [0 0 1];
        case 4
          col = [0.5 0.5 0];
        case 5
          col = [0 1 0];
        otherwise
          col = [0.2 0.2 0.3];
          % This type is unknown!!
      end
      
      p(obj.RGC(i).typeID) = ...
          stairs(obj.RGC(i).stats.Zedges,obj.RGC(i).stats.Zbins,'color',col);
      pLeg{obj.RGC(i).typeID} = obj.RGC(i).typeName;
      
    end

    try
      legend(p,pLeg)
    catch e
      getReport(e)
      keyboard
    end
  
    xlabel('Z depth')
    ylabel('Count')
  
  end
  
  if(1)
    figure('name','Stratification')
    for j = 1:5
      subplot(5,1,j)
      idx = find(obj.RGCtypeID == j);

      hold all
      
      for i = 1:numel(idx)
        stairs(obj.RGC(idx(i)).stats.Zedges, ...
               obj.RGC(idx(i)).stats.Zbins);
      end
      title(obj.RGCtypeName{idx(i(1))})
    end

    xlabel('Z depth')
    ylabel('Count')    
    
  end
  
  
end