% This is sPRM from Karaman 2011, Sampling-based algorithms for optimal 
% motion planning. Page 853, Algorithm 2

clear all
close all

O = LoadObstacles;  % Environment
n = 100;             % Number of samples
r = 3;              % Radius of proximity for function near
step = 0.1;         % Step for collision checking in a straight line


% Learning phase - graph creation

% Line 1
G = SampleFree(n, O);

% Line 2
for v = 1 : n
    
    % Line 3
    U = Near(G, v, r);

    % Line 4
    for u=U
        % Line 5
        if CollisionFree(G,u,v,step,O)
            G.add_edge(u,v);
        end    
    end
end


% Query phase 

% add initial position to the graph
init = [0,0]; % initial position
G.add_node(init);
near= Near(G, G.n, r); % G.n is the number of the node at init
for v=near
    if CollisionFree(G, v, G.n, step, O) 
        G.add_edge(v, G.n);
        %break;        % If we break, we will connect with a single edge 
    end
end

% add goal position to the graph
goal = [10,10]; % goal position
G.add_node(goal);
near= Near(G, G.n, r);
for v=near
    if CollisionFree(G, v, G.n, step, O) 
        G.add_edge(v, G.n);
        %break;
    end
end

hold on
G.plot();


% Functions

function G = SampleFree(n, O)
    G = PGraph(2);
    count = 0;
    while count < n
        qx = rand * (O{1}(2)-O{1}(1)) + O{1}(1);
        qy = rand * (O{1}(4)-O{1}(3)) + O{1}(3);
        q=[qx; qy];
        if isFree(q,O)
            G.add_node(q);
            count = count + 1;
        end
    end
end

function near = Near(G, v, r)
    [d, w] = G.distances(G.coord(v));
    near = w((d<r)&(d>0)); % This is to get all nodes smaller than n and greater than 0
end

function collision = CollisionFree(G, v, u, step, O)
    direction = (G.coord(v)-G.coord(u))/norm(G.coord(v)-G.coord(u));
    position = step;
    collision = false;
    while (position < norm(G.coord(v)-G.coord(u))) 
        if ~isFree(G.coord(u)+direction*position,O)
            return
        end
        position = position + step;
    end
    collision = true;
end
