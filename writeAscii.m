fid = fopen('features-mat.txt','w');

fprintf(fid,'classID');

for i = 1:numel(r.featuresUsed)
	fprintf(fid, ',%s', r.featuresUsed{i});
end
fprintf(fid,'\n');

for i = 1:size(r.featureMat,1)
  fprintf(fid, '%d', r.RGCtypeID(i));

	for j = 1:size(r.featureMat,2)
    minVal = min(r.featureMat(:,j));
    maxVal = max(r.featureMat(:,j));
  	fprintf(fid, ',%g', (r.featureMat(i,j)-minVal)/(maxVal-minVal)*100);
  end

  fprintf(fid,'\n');
end


fclose(fid);
