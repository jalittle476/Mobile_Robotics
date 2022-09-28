clear all
close all

makeMap(100,100)
%loadmap('test.mat')
%isFree


function map = makeMap(xlim,ylim)
    xlim = 100;
    ylim = 100;
    axis([0 xlim 0 ylim])
    hold on

    coords = zeros()
    A = zeros()
    B = zeros()
    obst = []
    b=0

    while(b ~= 1)

        for a = 1:4
            coords(a,[1,2]) = ginput(1)
   
            if(a > 1 &  a < 4)
                A = [coords(a,1), coords(a-1,1)];
                B = [coords(a,2), coords(a-1,2)];
                line(A,B) %%Nate gave me the idea to use line
            end
        end

        start = [coords(1,1) coords(1,2)];
        stop = [coords(a,1) coords(a,2)];

        if (norm(abs(start - stop)) < 5)
            coords(a,1) = start(1,1);
            coords(a,2) = start(1,2);
    
        end


        axis([0 xlim 0 ylim])
        hold on

        polygorn = polyshape(coords);
        plot(polygorn)
        obst = [obst, polygorn];

        b = waitforbuttonpress
        %isFree
    end


    save test.mat
end