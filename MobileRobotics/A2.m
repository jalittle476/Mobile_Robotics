clear all
close all
clc

map = mpMap;
%map.makeMap(10,10);
obstArry = map.loadmap('test4.mat');
polygonArry = obstArry.obst;
%close all

world = PGraph();


%% function execution for generating visibility diagram 
V = getmapVertices(polygonArry);

disp("Pick a starting point.")

[startCoords, startNode] = setStart(world);

disp("Pick a goal.")

[goalCoords, goalNode] = setGoal(world);

V = [V;startCoords;goalCoords];

addMapNodes(world,V);

addMapEdges(world,map,polygonArry,V);

% O = zeros(0);
% C = Bfs(world,O,startNode,goalNode)
% bp = findBackPointer(C,2)
%path = findPath(C)

world.plot

% highlightPath(world,path)



%% BFS Function (Needs work)
function C = Bfs(world,O,startNode,goalNode)
    
    O = push2(O,startNode,0)
    C = zeros(0)
    stop = 0;

    while(~isempty(O) & stop == 0)

        [element,pointer,O] = pop2(O)
%        elementIsNotMemberOfC = ~ismember(element,C)

        if(~ismember(element,C));
            
            C = push2(C,element,pointer)
            
            [node,neighbors] = findNeighbors(world,O,element)
            
            for i = 1:size(neighbors,2)
    
                if(neighbors(i) == goalNode)
                    C = push2(C,neighbors(i),element);
                    stop = 1;
                    return;
                end
                
                if(~ismember(neighbors(i),C))
                    O = push2(O,neighbors(i),element);
                    

                end

            end

         end
        
    end
    
end

%% Function to return path created by BFS
function path = findPath(queue)
    
    goalNode = queue(1,1);
    backPointer = findBackPointer(queue,goalNode);
    path = [goalNode,backPointer];

    while(true)
      
        backPointer = findBackPointer(queue,backPointer)

        if(backPointer == 0)
            return
        end

        path = [path,backPointer];
        
    end

    

end

%% Function to highlight BFS path
function highlightPath(world,path)

    for i = 1:size(path,2)
        world.highlight_node(path(i))
    end

end

%% Function to find backpointer in node queue
function backPointer = findBackPointer(queue, value)
    
    for i = 1: size(queue,1)

        if(queue(i,1) == value)
            backPointer = queue(i,2);
            return
        end
    end

end

%% Function to return neighbors of given node
function [node,neighbors] = findNeighbors(world,queue,node)

    neighbors = world.neighbours(node);
end

%% Original push function (depricated)
function queue = push(queue,element)

    
    if(isempty(queue))
        queue(1,1) = element;
    else
        queue = [element;queue];
    end

end

%% Original pop function (depricated)
function [element,queue] = pop(queue)

    element = queue(end,1);
    queue = queue([1:end-1]);

end

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

%% Function to return the vertices from an mpMap object
function V = getmapVertices(polygonArry)
    A = polygonArry(1,1).Vertices;
    obstLength = size(polygonArry,2);
    if(obstLength > 1)
        for i = 1:obstLength - 1
        
            B = polygonArry(1,i+1).Vertices;
            V = [A;B];
            A = V;
        
        end
    else
        V = polygonArry.Vertices;
    end
end

%% Function to set the starting node of the visibility diagram
function [startCoords,startingNode] = setStart(world)

    point = ginput(1);
    startingNode = world.add_node(point);
    startCoords = world.coord(startingNode)';


end

%% Function to set the goal node of the visibility diagram
function [goalCoords,goalNode] = setGoal(world)
    
    point = ginput(1);
    goalNode = world.add_node(point);
    goalCoords = world.coord(goalNode)';

end
    

%% Function to iteratively add all the nodes based on the map vertice locations
function addMapNodes(world,mapVertices)

    for j = 1:size(mapVertices,1)
    
        world.add_node([mapVertices(j,1),mapVertices(j,2)]);
       
    end
end

%% Function that iteratively adds edges between all map nodes 
function addMapEdges(world,map,polygonArry,mapVertices)

    for k = 1:size(mapVertices,1)
        
        for l = 1:size(mapVertices,1)
            
            if(binaryCheck(world,map,polygonArry,k,l) ~= 1)
                
                if(k > 0 & l >= k)
                world.add_edge(k,l);
                end
            
            end
        
        end
    end
end

%% Binary check method that creates multiple partitions to discretize the space
%  between two nodes
function TF = binaryCheck(world, mpObj,arry, n1,n2)

    n1Coord = world.coord(n1)';
    n2Coord = world.coord(n2)';

    [fullArry,midArry] = calcMidArry([n1Coord;n2Coord]);
    flag = mpObj.isFreePoint(arry,midArry);

%     A = [midArry(:,1)];
%     B = [midArry(:,2)];
%     scatter(A,B);

    if(flag ~= 1)

        for j = 1:3
    
            [fullArry,midArry] = calcMidArry(fullArry);
            

%             A = [midArry(:,1)];
%             B = [midArry(:,2)];
%             scatter(A,B);
%             size(midArry,1);

            for k = 1:size(midArry,1)
                
                x = midArry(k,1);
                y = midArry(k,2);

                flag = mpObj.isFreePoint(arry,[x,y]);

                if(flag == 1)
                    break
                end
            end

            if(flag == 1)
                break
            end


        end
    
    end

    TF = flag;
end

%% Function for calculating midpoint between two points
function mid = calcMidPoint(c1,c2)

    x1 = c1(1,1);
    y1 = c1(1,2);

    x2 = c2(1,1);
    y2 = c2(1,2);

    mid = [((x1+x2)/2),((y1 + y2)/2)];
end

%% Function for creating an evolving array of points and midpoints
function [fullArry,midArry] = calcMidArry(arry)

    fullArry = zeros(0);
    midArry = zeros(0);

    for i = 1: size(arry) -1

        a = arry(i,[1:2]);
        b = arry(i+1,[1:2]);
    
        mid = calcMidPoint(a,b);
        
        fullArry = unique([fullArry;a;mid;b],'rows');
        midArry = [midArry;mid];

    end

end
