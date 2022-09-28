%%John Little
%MAE593A Robot Motion Planning
%Assignment 1

clc
clear all
close all

makeMap(100,100)
loadmap('test4.mat')

% Function to create the map and the obstacle polygons
% Takes in xlimit and ylimit to create the dimensions of the map
function mp = makeMap(xlim,ylim)
     
    axis([0 xlim 0 ylim])
    hold on

    %Matrix to hold the coordinates
    coords = zeros();
    A = zeros();
    B = zeros();
    obst = [];
    b=0;

    %While loop that checks for enter button to be pressed to end
    %obstacle creation
    while(b ~= 1)
        
        %Loop to gather input from user for creating obstacle shape
        for a = 1:4
            coords(a,[1,2]) = ginput(1);
   
            if(a > 1 &  a < 4)
                A = [coords(a,1), coords(a-1,1)];
                B = [coords(a,2), coords(a-1,2)];
                line(A,B) %%Nate gave me the idea to use line
            end
        end

        start = [coords(1,1) coords(1,2)];
        stop = [coords(a,1) coords(a,2)];

        %Determines if last user selected point is within 5 points 
        %of first point and closes the polygon
        if (norm(abs(start - stop)) < 5)
            coords(a,1) = start(1,1);
            coords(a,2) = start(1,2);
    
        end


        axis([0 xlim 0 ylim])
        hold on

        polygorn = polyshape(coords);
        plot(polygorn);
        obst = [obst, polygorn];

        b = waitforbuttonpress;
    end
    coords

    save test4.mat
end

function loadmap(filename)

    xlim = 100;
    ylim = 100; 

    axis([0 xlim 0 ylim])
    hold on

    load(filename)

    for polyshape = obst

        plot(polyshape);

    end

    checkisFree(obst);


end

function isFree(arry)

    point = ginput(1);
    
    for polyshape = arry
        TFin = isinterior(polyshape, point(1,1),point(1,2));

        if(TFin == 1)
            break
        end

    end

    if(TFin == 1)
        disp('Obstacle')
    elseif (TFin == 0)
        disp('Free Space')
    end
end

function checkisFree(arry)
    
    c = 0;
    while (c ~= 1)

        isFree(arry)
        c = waitforbuttonpress;
      
    end

end



