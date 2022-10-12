            xlim = 200;
            ylim = 200; 
        
            axis([0 xlim 0 ylim])
            hold on
        
            load("discreteWorld.mat");

            pcolor(discreteWorld)