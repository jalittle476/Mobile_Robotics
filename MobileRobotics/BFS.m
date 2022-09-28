clc
clear all
close all

%%
startNode = 1;
O = zeros(0);
test = Bfs(O,startNode)


function q = Bfs(queue,startingNode)
    
    q = push(queue,startingNode)
    C = zeros(0)

    while(~isempty(q))
        
        [e,q] = pop(q)

        if(~ismember(e,C))
            
            C = push(C,e)
        
        end
    
    end

    
end

function queue = push(queue,element)

    
    if(isempty(queue))
        queue(1,1) = element;
    else
        queue(2,1) = queue(1,1);
        queue(1,1) = element;
    end

end

function [element,queue] = pop(queue)

    element = queue(end,end);
    queue = queue([1:end-1]);

end
