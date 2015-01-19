function plotVAChTbands(obj)

  figure('name','VAChT bands')
  hold on
  
  for i = 1:numel(obj.RGC)
    p = obj.RGC(i).VAChTpeaks;
    plot(i*ones(size(p)),p,'k*')
    xlabel('Z depth')
  end
  
end