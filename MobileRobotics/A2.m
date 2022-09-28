clear all
close all
clc

map = mpMap;
%mpObj.makeMap(100,100);
obstArry = map.loadmap('test4.mat');
polygonArry = obstArry.obst;
%close all

world = PGraph();


%% function execution
V = getmapVertices(polygonArry);

disp("Pick a starting point.")

[startCoords, startNode] = setStart(world);

disp("Pick a goal.")

[goalCoords, goalNode] = setGoal(world);

V = [V;startCoords;goalCoords];

addMapNodes(world,V);

addMapEdges(world,map,polygonArry,V);

world.plot


O = zeros(0);
test = Bfs(world,O,startNode,goalNode);


%%
function O = Bfs(world,O,startingNode,goalNode)
    
    O = push(O,startingNode)
    C = zeros(0)

    while(~isempty(O))
        
        [e,O] = pop(O)

        if(~ismember(e,C))
            
            C = push(C,e)

            if(e == goalNode)
                  break
            end

            neighbors = findNeighbors(world,O,e);

            for i = 1:size(neighbors,2)
                
                if(~ismember(neighbors(i),C))
                    O = push(O,neighbors(i));
                    

                end

            end

         end
        
    end
    
end

%%



%%
function neighbors = findNeighbors(world,queue,node)

    neighbors = world.neighbours(node);

end

%%
function queue = push(queue,element)

    
    if(isempty(queue))
        queue(1,1) = element;
    else
        queue = [element;queue];
    end

end

%%
function [element,queue] = pop(queue)

    element = queue(end,1);
    queue = queue([1:end-1]);

end

%%
function queue = push2(queue,element,pointer)

    
    if(isempty(queue))
        queue(1,1) = element;
        queue(1,2) = pointer;
    else
        pair = [element,pointer]
        queue = [pair;queue];
    end

end

%%
function [element,pointer,queue] = pop2(queue)

    element = queue(end,1)
    pointer = queue(end,2)

    if(size(queue,1) == 1)
        queue = zeros(0);
        return 
    end

    elementCol = queue(end-1,1)
    pointerCol = queue(end-1,2)
    queue = [elementCol,pointerCol]

end

%% 
function V = getmapVertices(polygonArry)
    A = polygonArry(1,1).Vertices;
    obstLength = size(polygonArry,2);
    for i = 1:obstLength - 1
    
        B = polygonArry(1,i+1).Vertices;
        V = [A;B];
        A = V;
    
    end
end

%%
function [startCoords,startingNode] = setStart(world)

    point = ginput(1);
    startingNode = world.add_node(point);
    startCoords = world.coord(startingNode)';


end

%%
function [goalCoords,goalNode] = setGoal(world)
    
    point = ginput(1);
    goalNode = world.add_node(point);
    goalCoords = world.coord(goalNode)';

end
    

%%
function addMapNodes(world,mapVertices)

    for j = 1:size(mapVertices,1)
    
        world.add_node([mapVertices(j,1),mapVertices(j,2)]);
       
    end
end

%%
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

%% 
function TF = binaryCheck(world, mpObj,arry, n1,n2)

    n1Coord = world.coord(n1)';
    n2Coord = world.coord(n2)';

%     mid = calcMidPoint(n1Coord,n2Coord);
%     flag = mpObj.isFreePoint(arry,mid);

    [fullArry,midArry] = calcMidArry([n1Coord;n2Coord]);
    flag = mpObj.isFreePoint(arry,midArry);

%     A = [midArry(:,1)];
%     B = [midArry(:,2)];
%     scatter(A,B);

    if(flag ~= 1)

        for j = 1:3
    
            [fullArry,midArry] = calcMidArry(fullArry);
            
            %fullArry = unique(fullArry,'rows');

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

%%
function mid = calcMidPoint(c1,c2)

    x1 = c1(1,1);
    y1 = c1(1,2);

    x2 = c2(1,1);
    y2 = c2(1,2);

    mid = [((x1+x2)/2),((y1 + y2)/2)];
end

%%
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
