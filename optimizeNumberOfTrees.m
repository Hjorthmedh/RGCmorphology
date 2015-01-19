clear all, close all

r = RGCclass(0); 
r.lazyLoad();

methodName = 'Bag';
% methodName = 'LPBoost'; % This algorithm selfterminates, chooses
% methodName = 'AdaBoostM2';
% methodName = 'TotalBoost'; % This algorithm selfterminates, chooses
% methodName = 'RUSBoost';
% methodName = 'Subspace';

nTrees = 200;

% useFeatures = setdiff(r.allFeatureNames, ...
%                       {'meanAxonThickness', ...
%                     'stratificationDepthScaled', ...
%                     'dendriticVAChT'});

useFeatures = { 'densityOfBranchPoints', ...
                'dendriticField', ...
                'somaArea', ...
                'fractalDimensionBoxCounting', ...
                    'meanTerminalSegmentLength' };


r.updateTables(useFeatures);

X = r.featureMat;
Y = r.RGCtypeID;

cvpart = cvpartition(Y,'holdout',0.3);
Xtrain = X(training(cvpart),:);
Ytrain = Y(training(cvpart),:);
Xtest = X(test(cvpart),:);
Ytest = Y(test(cvpart),:);

switch(methodName)
  case 'Subspace'

    bag = fitensemble(Xtrain,Ytrain,'Subspace',nTrees,'KNN',...
                      'NPredToSample', 1, ...
                      'Type','Classification');


    cv = fitensemble(X,Y,methodName,nTrees,'KNN',...
                     'type','classification','kfold',5)
    
    
  case 'AdaBoostM2'
    bag = fitensemble(Xtrain,Ytrain,methodName,nTrees,'Tree',...
                      'LearnRate', 0.1, ...
                      'Type','Classification');


    cv = fitensemble(X,Y,methodName,nTrees,'Tree',...
                     'type','classification','kfold',5)
    
  otherwise
    
    bag = fitensemble(Xtrain,Ytrain,methodName,nTrees,'Tree',...
                      'Type','Classification');


    cv = fitensemble(X,Y,methodName,nTrees,'Tree',...
                     'type','classification','kfold',5)
end

if(~strcmpi(methodName,'Bag'))
  figure;
  plot(loss(bag,Xtest,Ytest,'mode','cumulative'));
  hold on;
  plot(kfoldLoss(cv,'mode','cumulative'),'r.');
  hold off;
  xlabel('Number of trees','fontsize',25);
  ylabel('Classification error','fontsize',24);
  set(gca,'fontsize',20)
  legend('Test','Cross-validation','Location','NE');
else
  figure;
  plot(loss(bag,Xtest,Ytest,'mode','cumulative'),'linewidth',2);
  hold on;
  plot(kfoldLoss(cv,'mode','cumulative'),'r.','markersize',15);
  plot(oobLoss(bag,'mode','cumulative'),'k--','linewidth',2);
  hold off;
  xlabel('Number of trees','fontsize',25);
  ylabel('Classification error','fontsize',24);
  set(gca,'fontsize',20)
  
  legend('Test','Cross-validation','Out of bag','Location','NE');

  box off
end

figName = sprintf('FIGS/Forest-size-%s-%s.pdf', ...
                  methodName, ...
                  datestr(now,'yyyy-mm-dd-HH:MM:SS'));
saveas(gcf,figName,'pdf')
     