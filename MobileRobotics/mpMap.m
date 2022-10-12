%John Little
%Assignment 2
%Support class for verifying obtacle placement and free space 

classdef mpMap < handle


    properties
        coords;
        obst;
        coordsList;
    end

    methods
        % Function to create the map and the obstacle polygons
        % Takes in xlimit and ylimit to create the dimensions of the map
        function makeMap(self,xlim,ylim)
             
            axis([0 xlim 0 ylim])
            hold on
        
            %Matrix to hold the coordinates
            self.coords = zeros();
            A = zeros();
            B = zeros();
            self.obst = [];
            b=0;
        
            %While loop that checks for enter button to be pressed to end
            %obstacle creation
            while(b ~= 1)
                
                %Loop to gather input from user for creating obstacle shape
                for a = 1:4
                    self.coords(a,[1,2]) = ginput(1);
           
                    if(a > 1 &  a < 4)
                        A = [self.coords(a,1), self.coords(a-1,1)];
                        B = [self.coords(a,2), self.coords(a-1,2)];
                        line(A,B) %%Nate gave me the idea to use line
                    end
                end
        
                start = [self.coords(1,1) self.coords(1,2)];
                stop = [self.coords(a,1) self.coords(a,2)];
        
                %Determines if last user selected point is within 5 points 
                %of first point and closes the polygon
                if (norm(abs(start - stop)) < 0.5)
                    self.coords(a,1) = start(1,1);
                    self.coords(a,2) = start(1,2);
            
                end
        
        
                axis([0 xlim 0 ylim])
                hold on
        
                polygorn = polyshape(self.coords);
                plot(polygorn);
                self.obst = [self.obst, polygorn];
        
                b = waitforbuttonpress;
            end
        
        
            save test4.mat
        end
        
        function lm = loadmap(self,filename)
        
            xlim = 10;
            ylim = 10; 
        
            axis([0 xlim 0 ylim])
            hold on
        
            load(filename);

            for polyshape = self.obst
        
                plot(polyshape);
        
            end
        
            %checkisFree(self,self.obst);
        
        lm = struct('obst',self.obst);

       
        end
        
        function isFree(self,arry)
        
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

        function flag = isFreePoint(self,arry,coords)
        
            point = coords;
            flag = 0; 

            for polyshape = arry
              
                [TFin,TFon] = isinterior(polyshape, point(1,1),point(1,2));
                %scatter(point(1,1),point(1,2),'x');
                if((TFin == 1 & TFon == 0))
                    flag = 1;
                    break
                end

                %disp('free');
        
            end
        
        end


        
        function checkisFree(self,arry)
            
            c = 0;
            while (c ~= 1)
        
                isFree(self,arry)
                c = waitforbuttonpress;
              
            end
        
        end
    
        end
end

