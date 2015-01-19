clear all, close all

%reloadData = true;
reloadData = false;

% On/Off Cluster 1: Hoxd10-06112012-corrected.xml
% On/Off Cluster 1: Hoxd10-03132012-r1c3-corrected.xml
% On/Off Cluster 1: Hoxd10-leftear-righteyecontrol-04292013-40x-cell1-07zoom.xml
% On/Off Cluster 1: Hoxd10-bothears-righteyecontrol-04302013-40x-cell1-09zoom.xml
% On/Off Cluster 1: Hoxd10-none-righteyecontrol-04292013-40x-cell3.xml
% On/Off Cluster 1: P25Hoxd10-07132012-retina1-40x-stitch.xml
% On/Off Cluster 1: Hoxd10-03122012.xml
% On/Off Cluster 1: Hoxd10-04022012.xml
% On/Off Cluster 1: Hoxd10-leftear-righteyecontrol-04292013-40x-cell2-07zoom.xml
% On/Off Cluster 1: Hoxd10-bothears-righteyecontrol-04302013-40x-cell2-09zoom.xml
% On/Off Cluster 1: Hoxd10-none-righteyecontrol-04292013-40x-cell2-09zoom.xml
% On        Cluster 1: Hoxd10-04032012-corrected.xml
% On        Cluster 1: Hoxd10-03122012-c1-corrected.xml
% On        Cluster 1: hoxd10-04302013-bothears-righteyecontrol-cell3-40x-06zoom.xml
% On        Cluster 1: Hoxd10-06062012-c2-corrected.xml
% On        Cluster 2: P25-Hoxd1007132012-r2-25x-06zoom.xml
% On        Cluster 3: Hoxd10-07022012-retina1-cell3-40x-stitch.xml
% On        Cluster 3: Hoxd10-none-righteyecontrol-04292013-40x-cell4-zoom07-stitch.xml
% On        Cluster 3: Hoxd10-none-righteyecontrol-04292013-40x-cell1-stitch.xml
% On        Cluster 3: Hoxd10-none-righteyecontrol-04292013-40x-cell5-stitch.xml
% On        Cluster 3: P82-Hoxd10-retina2-cell4-07022012.xml
% On        Cluster 3: Hoxd10-04292013-leftear-righteyecontrol-cell3-40x-tile_Stitch.xml
% On        Cluster 3: Hoxd10-06082012-c1-corrected.xml
% On        Cluster 3: P82-Hoxd10-retina3-07022012-cell6-40x-stitch.xml
% On        Cluster 3: Hoxd10-04292013-rightear-righteyecontrol-cell1-40x-tile_Stitch.xml
% On        Cluster 3: P82-Hoxd10-retina3-07022012-cell5-40x-stitch.xml
% On        Cluster 3: Hoxd10-04292013-rightear-righteyecontrol-cell2-40x-tile.xml
% On        Cluster 3: hoxd10-04302013-bothears-righteyecontrol-cell4-40x-06zoom.xml
% On        Cluster 3: Hoxd10-02242012.xml


% On       Cluster 1: Cdh3-a3r3-07172012-cell3-40x-0.xml
% On       Cluster 1: Cdh3-07172012-a1r1-cell1-40x-0.xml
% On       Cluster 2: Cdh3-07-17-2012-a2-r2-cell2-40x-0.xml
% On       Cluster 2: cdh3-03122012-corrected.xml
% On       Cluster 2: Cdh3-07172012-a3r3-cell2-40x-0.xml
% On       Cluster 2: Cdh3-07-17-2012-a2-r2-cell1-40x-0.xml
% Diving Cluster 2: Cdh3-07172012-a3r3-cell1-40x-09zoom-2.xml
% On       Cluster 2: Cdh3-07-18-2012--cell1-40x-0-corrected.xml
% Diving Cluster 2: Cdh3-07-18-2012-a2r2-cell1-40x-0-corrected.xml
% Diving Cluster 2: Cdh3-06112012-corrected.xml
% Diving Cluster 3: Cdh3-07-18-2012-a2r2-cell2-40x-corrected.xml


if(~reloadData)
  r = RGCclass('/Users/hjorth/DATA/RanaEldanaf/Cdh3-Hoxd10-both-split/XML/');
  r.lazySave('Cdh3-Hoxd10-split')
else
  r = RGCclass(0);
  r.lazyLoad('Cdh3-Hoxd10-split')
end



