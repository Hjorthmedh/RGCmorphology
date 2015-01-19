% Example: makeLatexTable({'a','b','c'},{'A','B','C','D'},rand(4,3),'%.2f')
% 

function latexStr = makeLatexTableHeaders(columnHeader, rowHeader, matrix, formatStr,topHeader,sideHeader)

  latexStr = [];
  
  % Write header
  
  latexStr = sprintf('\\begin{table}\n');
  latexStr = [latexStr,sprintf('\\begin{tabular}{ll%s}\n\\hline\n',repmat('r',1,numel(columnHeader)))];

  % This is for the top header
  latexStr = sprintf('%s & & \\multicolumn{%d}{c}{%s}\\\\\n', ...
                     latexStr, numel(columnHeader), topHeader);
  
  % This is for the side header
  latexStr = [latexStr, ' &'];
  
  for i = 1:numel(columnHeader)
    
    latexStr = [latexStr,sprintf(' & %s', columnHeader{i})];
  
  end
  
  latexStr = [latexStr,sprintf('\\\\\n\\cline{3-%d}\n', 2+numel(columnHeader))];
  
  % Write the actual table

  for i = 1:size(matrix,1)
    
    if(i == 1)
      latexStr = sprintf('%s\\multirow{%d}{*}{\\rotatebox{90}{%s}}', ...
                         latexStr, size(matrix,1), sideHeader);
    end
    
    for j = 1:size(matrix, 2)
      if(j > 1)
        separator = ' & ';
      else
        separator = sprintf('& %s & ', rowHeader{i});
      end
      
      str = sprintf('%s%s', separator, formatStr);
      latexStr = [latexStr,sprintf(str, matrix(i,j))];
      
    end
    
    latexStr = [latexStr, sprintf('\\\\\n')];
    
  end

  % Write footer
  
  latexStr = [latexStr, sprintf('\\cline{3-%d}\n', 2+numel(columnHeader))];
  latexStr = [latexStr, sprintf('\\end{tabular}\n')];
  latexStr = [latexStr, sprintf('\\end{table}\n')];
  
end

