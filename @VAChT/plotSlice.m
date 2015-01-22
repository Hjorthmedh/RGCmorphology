function plotSlice(obj)

  img = double(obj.rgc.lsm.image(:,:,obj.morphChannel,:));

  xCompressedImage = transpose(squeeze(max(img,[],2)));
  yCompressedImage = transpose(squeeze(max(img,[],1)));

  figure('name',sprintf('Max proj: %s', obj.rgc.xmlFile))
  subplot(2,1,1)
  imagesc(obj.y,obj.z,xCompressedImage)
  hold on
  plotSomaYZ();
  obj.rgc.parseDendrites(@plotFlatNeuronYZ);
  xlabel('Y');
  ylabel('Z');
  set(gca,'ydir','normal')
  axis tight
  
  title(obj.rgc.xmlFile)
  
  subplot(2,1,2)
  imagesc(obj.x,obj.z,yCompressedImage)
  hold on
  plotSomaXZ();
  obj.rgc.parseDendrites(@plotFlatNeuronXZ);
  xlabel('X');
  ylabel('Z');
  set(gca,'ydir','normal')
  axis tight
  
  title('Max projection')
  
  fName = sprintf('FIGS/%s-summed-image-Z-check.pdf', obj.rgc.xmlFile);
  saveas(gcf,fName,'pdf');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = plotSomaXZ()

    for i = 1:numel(obj.rgc.somaContours)
      plot(obj.rgc.somaContours{i}(:,1), ...
           obj.rgc.somaContours{i}(:,3), 'k-');
    end
    
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = plotSomaYZ()

    for i = 1:numel(obj.rgc.somaContours)
      plot(obj.rgc.somaContours{i}(:,2), ...
           obj.rgc.somaContours{i}(:,3), 'k-');
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = plotFlatNeuronXZ(branch,res)

    plot(branch.coords(:,1), ...
         branch.coords(:,3), 'k-');
  
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = plotFlatNeuronYZ(branch,res)

    plot(branch.coords(:,2), ...
         branch.coords(:,3), 'k-');
  
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end