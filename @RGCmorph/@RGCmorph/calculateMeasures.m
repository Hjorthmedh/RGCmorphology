% Helper function called from analyse
%
% This calculates all non-VAChT-band-related measures

function results = calculateMeasures(obj,showFigures)

  if(~exist('showFigures') | isempty(showFigures))
    showFigures = true;
  end

  %% Soma area, and soma depth
  
  [results.somaArea, results.somaZ] = obj.measureSomaArea();    % Verified.

  
  %% Stratification depth

  [obj.stratificationDepth,obj.biStratificationDistance] = obj.getStratification();
  
  results.stratificationDepth = obj.stratificationDepth;  
  results.biStratificationDistance = obj.biStratificationDistance;
  
  if(obj.hasVAChT)
    % These are now calculated by the VAChT object directly, so just
    % copy along to results.

    results.stratificationDepthScaled = obj.stratificationDepthScaled;
  else
    results.stratificationDepthScaled = NaN;
  end
    
  % [results.upperDendExtent, results.lowerDendExtent, ...
  %  results.dendBinCount, results.dendBinEdges] = ...
  %    obj.measureDendriteLocation(obj.dendPercentiles(1), ...
  %                                obj.dendPercentiles(2), obj.useScaledZcoordinates);

  
  % Add it to previous figure
  % a = axis();
  % hold on
  % plot(results.meanStratificationDepth*[1 1], a(3:4),'r-')
  % fName = sprintf('FIGS/%s-stratification-depth.pdf',obj.xmlFile);
  % saveas(gcf,fName,'pdf');

  
  %% Total length 
  
  totalDendriticLength = obj.parseDendrites(@obj.measureTotalLength,true);
  results.totalDendriticLength = totalDendriticLength;
  
  %% Total complexity
  
  c = obj.parseDendrites(@obj.measureComplexity);
  results.complexity = c;
  results.totalComplexity = sum(c);
  
  if(showFigures)
    f = figure('visible','off', ...
               'name',sprintf('Dendritic complexity %s', ...
                              obj.xmlFile));
    plot(0:numel(c)-1,c,'ko-')
    xlabel('Complexity')
    ylabel('Count')
    title(sprintf('Dendritic complexity: %s', obj.xmlFile))
  
    fName = sprintf('FIGS/%s-dendritic-complexity.pdf',obj.xmlFile);
    saveas(gcf,fName,'pdf');
    close(f);
  end
  
  %% Soma diameter
  
  results.somaDiameter = obj.measureSomaDiameter();
  

  %% Total dendritic field
  results.dendriticField = obj.measureTotalDendriticField();

  
  %% Number of branch points
  results.numBranchPoints = obj.parseDendrites(@obj.measureCountBranchPoints);
  
  results.numLeaves = obj.parseDendrites(@obj.measureCountLeaves);
  
  %% Number of segments
  results.numSegments = obj.parseDendrites(@obj.measureNumSegments);
  
  %% Average segment length 
  results.meanSegmentLength = results.totalDendriticLength ...
                             / results.numSegments;
  
  %% Average terminal segment length
  tmp = obj.parseDendrites(@obj.measureMeanTerminalSegmentLength);
  results.meanTerminalSegmentLength = tmp(1);
  results.totalTerminalSegmentLength = tmp(2);
  
  %% Density of branch points
  results.densityOfBranchPoints = ...
      results.numBranchPoints / results.dendriticField;

  
  results.dendriticDensity = results.totalDendriticLength ...
                             / results.dendriticField;
  
  %% Maximum diameter of dendritic field
  results.dendriticDiameter = obj.measureDendriticDiameter();
  

  %% Mean thickness of axon (first 50 micrometers)
  results.meanAxonThickness = obj.measureMeanAxonThickness(50);
  
    
  
  %% Segment tortuosity: path length / euclidean length of end
  %% points
  
  tmp = obj.parseDendrites(@obj.measureSegmentTortuosity);
  results.meanSegmentTortuosity = tmp(1);
  
  %% Branch assymetry
  results.branchAssymetry = obj.measureBranchAssymetry();
  
  %% 3D angle between branches
  
  tmp = obj.parseDendrites(@obj.measureMeanBranchAngle);
  results.meanBranchAngle = tmp(1);
  
  %% Fractal dimension
  
  results.fractalDimensionBoxCounting = obj.measureFractalDimensionBoxCounting();
  
  % Dendritic VAChT staining, compared to average VAChT staining in
  % slice
  results.dendriticVAChT = obj.measureDendriticVAChTstaining();
  
  % Bi stratified flag
  results.biStratified = obj.biStratified;
  
  
  % Save the stats for the object
  obj.stats = results;


end