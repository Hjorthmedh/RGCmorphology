clear all, close all

r = RGCclass(0);
r.lazyLoad('knownSumbul');

uID = unique(r.RGCtypeID);
nID = numel(uID);

% Variable name, unit, scaling factor, mean formating, SD formating
printInfo = {{'biStratificationDistance', '$\mu m$', 1, '%.1f', '%.1f'}, ...
             {'branchAssymetry', [], 1, '%.2f', '%.2f'}, ...
             {'dendriticField', '$mm^2$', 1e-6, '%.2f', '%.2f'}, ...
             {'dendriticDensity', '$\mu m^{-1}$', 1, '%.2f', '%.2f'}, ...
             {'dendriticDiameter', '$\mu m$', 1, '%.0f', '%.0f'}, ...
             {'densityOfBranchPoints', '$mm^{-2}$', 1e6, '%.0f', '%.0f'}, ...
             {'fractalDimensionBoxCounting', [], 1, '%.2f', '%.2f'}, ...
             {'meanBranchAngle', 'degrees', 180/pi, '%.0f', '%.0f'}, ...
             {'meanSegmentLength', '$\mu m$', 1, '%.1f', '%.1f'}, ...
             {'meanSegmentTortuosity', [], 1, '%.2f', '%.2f'}, ...
             {'meanTerminalSegmentLength', '$\mu m$', 1, '%.1f', '%.1f'}, ...
             {'numBranchPoints', [], 1, '%.0f', '%.0f'}, ...
             ... % {'numLeaves', [], 1, '%.0f', '%.0f'}, ...
             ... % {'numSegments', [], 1, '%.0f', '%.0f'}, ...
             ... % {'somaArea', '$\mu m^2$', 1, '%.0f', '%.0f'}, ... % No soma area in dataset
             {'stratificationDepth', '$\mu m$', 1, '%.0f', '%.0f'}, ...
             {'totalDendriticLength', '$mm$', 1e-3, '%.1f', '%.1f'}};



headerStr1 = '\\begin{sidewaystable}\n\\begin{tabular}{llllllll}\n';
headerStr2 = ' & \\multicolumn{5}{c}{Cell Type}\\\\\n\\cline{2-6}\n';

fprintf(headerStr1)
fprintf(headerStr2)
fprintf('Feature name')



for i = 1:nID

  idx = find(r.RGCtypeID == uID(i));
  fprintf(' & %s', r.RGCtypeName{idx(1)})
  
end

fprintf('\\\\\n\\hline\n')



for i = 1:numel(r.allFeatureNames)
  
  feat = printInfo{i}{1};
  featName = r.featureNameDisplay(feat);
  unitStr = printInfo{i}{2};
  
  val = r.getVariable(feat);
  if(isempty(unitStr))
    fprintf('%s', featName)
  else
    fprintf('%s (%s)', featName, unitStr)
  end
  
  for j = 1:nID
    
    idx = find(r.RGCtypeID == uID(j));
  
    formatStr = sprintf('& $%s \\\\pm %s$', printInfo{i}{4}, printInfo{i}{5});
    
    scale = printInfo{i}{3};
    fprintf(formatStr,scale*mean(val(idx)),scale*std(val(idx)))
    
  end

  fprintf('\\\\\n')
  
end

fprintf('\\hline\n\\end{tabular}\n\\end{sidewaystable}\n')