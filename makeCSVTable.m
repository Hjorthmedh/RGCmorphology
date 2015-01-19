% Save as CSV, open in Excel, then copy into word... (wish there
% was a simpler way)

% columnHeader is Ncols + 1, first column label the row headers

function makeCSVTable(fileName, columnHeader,rowHeader,matrix,formatStr)

  % Just double check before writing file
  assert(strcmpi(fileName(end-2:end),'csv'))
  assert(numel(columnHeader) == size(matrix,2)+1)
  assert(numel(rowHeader) == size(matrix,1))
  assert(~iscell(formatStr) | numel(formatStr) == size(matrix,2))

  % Lets get cracking
  fid = fopen(fileName,'w');
  
  for i = 1:numel(columnHeader)
    if(i == 1)
      fprintf(fid,'%s', columnHeader{i});    
    else
      fprintf(fid,', %s', columnHeader{i});
    end
  end

  fprintf(fid,'\n');
  
  for i = 1:numel(rowHeader)
    
    % Left most column is row headers
    fprintf(fid,'%s',rowHeader{i});
    
    for j = 1:size(matrix,2)
      if(islogical(matrix(i,j)))
        if(matrix(i,j))
          fprintf(fid,',•')
        else
          fprintf(fid,', ')
        end
      else
        if(iscell(formatStr))
          if(strcmpri(formatStr,'binary'))
            if(matrix(i,j))
              fprintf(fid,',•')
            else
              fprintf(fid,', ')
            end
          else
            fprintf(fid, [',' formatStr{j}], matrix(i,j));
          end
                
        else
          fprintf(fid, [',' formatStr], matrix(i,j));
        end
      end
    end
    fprintf(fid,'\n');
  end
  
  fclose(fid);

end