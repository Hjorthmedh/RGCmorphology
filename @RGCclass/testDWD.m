% Testing Distance Weighted Discrimination to see if we can figure
% out which feature vectors are good

function testDWD(obj, featureSet)

  pathToDWD = '../DWD/BatchAdjust/';

  addpath(pathToDWD);
  
  weight = 1; % Not handling weights atm
  testdata = [];
  
  if(~exist('featureSet') || isempty(featureSet))
    featureSet = setdiff(obj.allFeatureNames, ...
                         {'meanAxonThickness', ...
                        'stratificationDepthScaled', ...
                        'dendriticVAChT'});
    
  end
    
  obj.setFeatureMat(featureSet);
  
  RGCID = unique(obj.RGCtypeID);
  
  figure
  figCtr = 1;
  
  for iA = 1:numel(RGCID)

    idxA = find(obj.RGCtypeID == RGCID(iA));
    
    fvA = transpose(obj.featureMat(idxA,:));
    
    for iB = 1:numel(RGCID)
      
      if(iA == iB)
        % Skip if same
        figCtr = figCtr + 1;
        continue;
      end
      
      idxB = find(obj.RGCtypeID == RGCID(iB));
      
      fvB = transpose(obj.featureMat(idxB,:));
      
      [dirvec{iA}{iB},beta{iA}{iB},~] = DWD2XQ(fvA,fvB,weight,testdata);
      
      % Plotting
      subplot(numel(RGCID),numel(RGCID),figCtr)
      figCtr = figCtr + 1;
      % subplot(numel(RGCID)-1,numel(RGCID)-1,(iA-1)*(numel(RGCID)-1) + iB-1)
      
      xA = obj.featureMat(idxA,:) * dirvec{iA}{iB};
      xB = obj.featureMat(idxB,:) * dirvec{iA}{iB};      

      yA = rand(size(xA));
      yB = rand(size(xB));
      
      plot(xA,yA,'ro', xB,yB,'bx');
      a = axis; a(3:4) = [-2 3]; axis(a);
      set(gca,'yticklabel',[])
      
    end
    

  end
  
  
  saveas(gcf,'FIGS/DWD-summary-figure.pdf','pdf')
  
  keyboard
  
  rmpath(pathToDWD);

end