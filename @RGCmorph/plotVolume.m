function plotVolume(obj)

  % Make sure we have the lsm data loaded
  obj.reloadLSM();
  
  v = VAChT();
  img = double(squeeze(obj.lsm.image(:,:,v.morphChannel,:)));

  figure
  p1 = patch(isosurface(img,max(img(:))*0.8),'FaceColor','blue','EdgeColor','none');
  isonormals(img,p1)
  view(3); 
  axis vis3d tight
  camlight left; 
  lighting phong
  
  % Clear lsm again
  % obj.lsm = [];

end