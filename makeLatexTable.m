% Example: makeLatexTable({'a','b','c'},{'A','B','C','D'},rand(4,3),'%.2f')
% 

function latexStr = makeLatexTable(columnHeader, rowHeader, matrix, formatStr)

  latexStr = [];
  
  % Write header
  
  latexStr = sprintf('\\begin{table}\n');
  latexStr = [latexStr,sprintf('\\begin{tabular}{l%s}\n\\hline\n',repmat('r',1,numel(columnHeader)))];

  for i = 1:numel(columnHeader)
    
    latexStr = [latexStr,sprintf(' & %s', columnHeader{i})];
  
  end
  
  latexStr = [latexStr,sprintf('\\\\\n\\hline\n')];
  
  % Write the actual table

  for i = 1:size(matrix,1)
    for j = 1:size(matrix, 2)
      if(j > 1)
        separator = ' & ';
      else
        separator = sprintf('%s & ', rowHeader{i});
      end
      
      str = sprintf('%s%s', separator, formatStr);
      latexStr = [latexStr,sprintf(str, matrix(i,j))];
      
    end
    
    latexStr = [latexStr, sprintf('\\\\\n')];
    
  end

  % Write footer
  
  latexStr = [latexStr, sprintf('\\hline\n')];
  latexStr = [latexStr, sprintf('\\end{tabular}\n')];
  latexStr = [latexStr, sprintf('\\end{table}\n')];
  
end

