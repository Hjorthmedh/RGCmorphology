clear all, close all
profile on

n = 16;
figCtr = 1;

figure
disp('Note how it slows down...')
for i = 1:n
  for j = 1:n
    fprintf('%d,%d\n', i,j)
    subplot(n,n,figCtr);

    data = rand(n,n);
    col = rand(3,1);
    mSize = rand(1)*10+5;
    
    plot(data(:,i),data(:,j), ...
         '.', 'color', col, ...
         'markersize', mSize);
    
    a = axis();
      
    h = text(0.1*(a(2)-a(1))+a(1),0.8*(a(4)-a(3))+a(3),sprintf('%.3f', mSize));
      
    % Column headers on top
    if(i == 1)
      h = text(0.5*(a(2)-a(1))+a(1),1.25*(a(4)-a(3))+a(3), ...
               sprintf('Feature %d', j));
        set(h,'HorizontalAlignment','center');
      end
      
      % Add row headers
      if(j == 1)
        h = text(-0.3*(a(2)-a(1))+a(1),0*(a(4)-a(3))+a(3), ...
                 sprintf('Feature %d', i), 'rotation',90);
        set(h,'verticalalignment','middle')
      end
    
    figCtr = figCtr + 1;
  end
end

profview