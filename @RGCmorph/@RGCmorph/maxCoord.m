function res = maxCoord(obj,branch,res)

	if(isempty(res))
		res = max(branch.coords);
	else
		res = max(res,max(branch.coords,[],1));
 end

end

