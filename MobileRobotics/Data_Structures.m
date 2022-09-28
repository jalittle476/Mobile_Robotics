clc
clear all
close all

% queue = zeros(0);
% queue = push(queue,1)
% queue = push(queue,2)
% queue = push(queue,3)
% [element,queue] = pop(queue)
% [element,queue] = pop(queue)

queue = zeros(0);
queue = push2(queue,1,28)
queue = push2(queue,2,32)
[element,queue] = pop2(queue)
[element,queue] = pop2(queue)
queue = push2(queue,1,89)



%%,
function queue = push(queue,element)

    
    if(isempty(queue))
        queue(1,1) = element;
    else
        queue = [element;queue];
    end

end

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
function [element,queue] = pop2(queue)

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