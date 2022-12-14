clear all
close all
clc

map = mpMap;
%map.makeMap(100,100);
obstArry = map.loadmap('test4.mat');
polygonArry = obstArry.obst;
%close all

world = PGraph();

n = 1;
r = 5;

[startCoords, startNode] = setStart(world)
[goalCoords, goalNode] = setGoal(world)


JRRT(world,map,polygonArry,startCoords,startNode,goalCoords,goalNode)
plot(world)
highlightRRTPath(world,goalNode,startNode);

% setData = world.setvdata(startNode,a);
% test = world.vdata(startNode)

%% function to highlight RRT Path

function highlightRRTPath(world,goalNode,startNode)
    world.highlight_node(startNode);
    world.highlight_node(goalNode);
    stepNode = world.vdata(goalNode);
    world.highlight_node(stepNode);
    
    while(stepNode ~= 1)

        stepNode = world.vdata(stepNode)
        world.highlight_node(stepNode);
    
    end

end


%% Function for generating RRT

function JRRT(world,map,polygonArry,startCoords,startNode,goalCoords,goalNode)

    while(~world.samecomponent(startNode,goalNode))
        sampleCoords = SampleFree(map,polygonArry,1);
        %    world.add_node(sampleCoords);

        if(i ~= 1 && world.closest(sampleCoords) ~= goalNode)
            startNode = world.closest(sampleCoords);
            startCoords = world.coord(startNode)';
        end
        
         % code for unit vector referenced from
        % https://www.mathworks.com/matlabcentral/answers/45376-create-cartesian-unit-vectors-from-2-points
        d0=startCoords;
        d1=sampleCoords;
        nd=(d1-d0)./norm(d1-d0);%normalize
        step = 5*nd + startCoords;
    
        if(~binaryCheck2(world,map,polygonArry,startNode,step))
            stepNode = world.add_node(step);
            world.setvdata(stepNode,startNode);
            world.add_edge(startNode,stepNode);
        end

        if(norm(abs(startCoords - goalCoords)) < 10)
            world.add_edge(startNode,goalNode);
            world.setvdata(goalNode,startNode);
            world.highlight_node(goalNode);
        end
         
    end

end

%% Function to set the starting root of RRT
function [startCoords,startingNode] = setStart(world)

    point = ginput(1);
    startingNode = world.add_node(point);
    startCoords = world.coord(startingNode)';

end

%% Function to set the goal
function [goalCoords,goalNode] = setGoal(world)
    
    point = ginput(1);
    goalNode = world.add_node(point);
    goalCoords = world.coord(goalNode)';

end


%% Based on GP's Sample Free function
function sample = SampleFree(map,polygonArry,n)
    count = 0;
    while count < n
        qx = floor(rand * 100);
        qy = floor(rand * 100);
        q =[qx qy];
        if ~map.isFreePoint(polygonArry,q)
            %world.add_node(q);
            sample = q;
            count = count + 1;
        end
    end
    
    end

%% Binary check method that creates multiple partitions to discretize the space
%  between two nodes
function TF = binaryCheck2(world, map,arry, n1,c2)

    n1Coord = world.coord(n1)';
    n2Coord = c2;

    [fullArry,midArry] = calcMidArry([n1Coord;n2Coord]);
    flag = map.isFreePoint(arry,midArry);

%     A = [midArry(:,1)];
%     B = [midArry(:,2)];
%     scatter(A,B);

    if(flag ~= 1)

        for j = 1:5
    
            [fullArry,midArry] = calcMidArry(fullArry);
            

%             A = [midArry(:,1)];
%             B = [midArry(:,2)];
%             scatter(A,B);
%             size(midArry,1);

            for k = 1:size(midArry,1)
                
                x = midArry(k,1);
                y = midArry(k,2);

                flag = map.isFreePoint(arry,[x,y]);

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
%% Binary check method that creates multiple partitions to discretize the space
%  between two nodes
function TF = binaryCheck(world, map,arry, n1,n2)

    n1Coord = world.coord(n1)';
    n2Coord = world.coord(n2)';

    [fullArry,midArry] = calcMidArry([n1Coord;n2Coord]);
    flag = map.isFreePoint(arry,midArry);

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

                flag = map.isFreePoint(arry,[x,y]);

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