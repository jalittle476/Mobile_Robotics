function isfree = isFree(q, Obstacles)
isfree = 1;
for n = 2:numel(Obstacles)
   isfree = isfree && (~inpolygon(q(1), q(2), Obstacles{n}(:,1),Obstacles{n}(:,2)));
   if ~isfree
       break;
   end
end
