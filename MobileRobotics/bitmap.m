clear all
close all
clc

map = mpMap;
%map.makeMap(100,100);
obstArry = map.loadmap('test4.mat');
polygonArry = obstArry.obst;
%close all

world = PGraph();

discreteWorld = zeros(200);

xMin = 0;
xMax = 100;
yMin = 0;
yMax = 100;

j = 1;
i = 1;

for x = linspace(xMin,xMax,200)
    for y = linspace(yMin,yMax,200)
        
        coords = [x,y];
        flag = map.isFreePoint(polygonArry, coords);
        discreteWorld(i,j) = flag;
        j = j + 1;
    
    end
    j = 1;
    i = i + 1;
end



start = 100;
goal = discreteWorld(1000);
O = [];

dw = Bfs(discreteWorld,O,start,goal);

pcolor(dw)

%% BFS Function (Needs work)
function dw = Bfs(discreteWorld,O,start,goal)
    
    sz = size(discreteWorld);
    O = push2(O,start,2);
    C = zeros(0);
    distance = 2;
    discreteWorld(start) = distance; 
    

   %while(~isempty(O))
        
        [element,pointer,O] = pop2(O);


        if(~ismember(element,C));
            
            C = push2(C,element,pointer);
            neighbors = [];
            [i,j] = ind2sub(sz,element)
            
            if(i-1 < sz(2) && i-1 > 0)
                up = sub2ind(sz,i-1,j)
                if(discreteWorld(up) ~= 1)
                    neighbors = [neighbors up];
                end
            end

            if(i+1 > 0 && i+1 < sz(2))
                down = sub2ind(sz,i+1,j)
                if(discreteWorld(down) ~= 1)
                    neighbors = [neighbors down];
                end

            end

            if(j-1 > 0 && j-1 < sz(2))
                left = sub2ind(sz,i,j-1)
                if(discreteWorld(left) ~= 1)
                    neighbors = [neighbors left];
                end

            end
            
            if(j+1 < sz(2) && j + 1 > 0)
                right = sub2ind(sz,i,j+1)
                if(discreteWorld(right) ~= 1)
                    neighbors = [neighbors right];
                end

            end

            distance = distance + 1;
            for i = 1:size(neighbors,2)
                if(~ismember(neighbors(i),C))
                    O = push2(O,neighbors(i),distance);

                end
            end

                    
        end
        dw = discreteWorld;
    end
    
%end

%% Push function created to handle pointers and elements
function queue = push2(queue,element,pointer)

    
    if(isempty(queue))
        queue(1,1) = element;
        queue(1,2) = pointer;
    else
        pair = [element,pointer];
        queue = [pair;queue];
    end

end

%% Pop function created to handle pointers and elements
function [element,pointer,queue] = pop2(queue)

    element = queue(end,1);
    pointer = queue(end,2);

    if(size(queue,1) == 1)
        queue = zeros(0);
        return 
    end

    elementCol = queue(end-1,1);
    pointerCol = queue(end-1,2);
    queue = [elementCol,pointerCol];

end