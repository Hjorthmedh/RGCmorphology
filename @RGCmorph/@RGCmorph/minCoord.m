function res = minCoord(obj,branch,res)

	if(isempty(res))
		res = min(branch.coords);
	else
		res = min(res,min(branch.coords,[],1));
  end

end
