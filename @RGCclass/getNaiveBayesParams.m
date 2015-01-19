function [mu,sigma] = getNaiveBayesParams(obj)

  n = obj.classifier;

  mu = NaN*zeros(n.NClasses,n.NDims);
  sigma = NaN*zeros(n.NClasses,n.NDims);

  for i = 1:n.NClasses
    for j = 1:n.NDims

      mu(i,j) = n.Params{i,j}(1);
      sigma(i,j) = n.Params{i,j}(2);
      
    end
  end
  
end