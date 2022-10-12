clear all
close all
clc

map = mpMap;
%map.makeMap(100,100);
obstArry = map.loadmap('test4.mat');
polygonArry = obstArry.obst;
%close all

%createBitMap(map,polygonArry);

xlim = 200;
ylim = 200;

axis([0 xlim 0 ylim])
hold on

load("discreteWorld.mat");


goal = 1000;
dw = wavefront(discreteWorld,start);

pcolor(dw)

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

%% Modified version of GP's BFW for Pgraph
function dw = wavefront(discreteWorld,start)

    O = zeros(40000,3);
    top = 1;
    bottom = 1;
    sz = size(discreteWorld);
    distance = 2;
    
    C = zeros(40000,3);
    
    V  = start; % Initial node
    %discreteWorld(V) = distance;
    
    % Add V to O
    O(bottom, 1) = V;
    O(bottom, 2) = V;% backpointer
    O(bottom, 3) = distance;
    discreteWorld(V) = distance;
    bottom = bottom + 1;
    if bottom > length(O)
        bottom = 1;
    end
    
    while (top ~= bottom)
        u = O(top,:);
        top = top + 1;
        if top > length(O)
            top = 1;
        end
        if C(u(1),1) == 0
            C(u(1),1) = 1;  % mark that u is in C
            C(u(1),2) = u(2); % store the backpointer
            C(u(1),3) = distance;
            neighbors = [];

            [i,j] = ind2sub(sz,u(1));
                if(i-1 < sz(2) && i-1 > 0)
                up = sub2ind(sz,i-1,j);
                    if(discreteWorld(up) ~= 1)
                        neighbors = [neighbors up];
                    end
                end

            if(i+1 > 0 && i+1 < sz(2))
                down = sub2ind(sz,i+1,j);
                if(discreteWorld(down) ~= 1)
                    neighbors = [neighbors down];
                end

            end

            if(j-1 > 0 && j-1 < sz(2))
                left = sub2ind(sz,i,j-1);
                if(discreteWorld(left) ~= 1)
                    neighbors = [neighbors left];
                end

            end
            
            if(j+1 < sz(2) && j + 1 > 0)
                right = sub2ind(sz,i,j+1);
                if(discreteWorld(right) ~= 1)
                    neighbors = [neighbors right];
                end

            end
            
            distance = distance + 1;
            for ne = neighbors
                if C(ne,1) == 0             % check if the neighbor is in C
                        O(bottom,1) = ne;   % Add the neighbor to set O
                        O(bottom,2) = u(1); % Add the backpointer of the neighbor to O.
                        O(bottom,3) = distance;
                        bottom = bottom + 1;
                        discreteWorld(ne) = distance;
                        if bottom > length(O)
                            bottom = 1;
                        end
                end
            end
        end
    end

    dw = discreteWorld;

end

%% function to create bitmap
function createBitMap(map,polygonArry)
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

save discreteWorld.mat

end