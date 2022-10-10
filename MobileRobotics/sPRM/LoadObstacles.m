function Obstacles = LoadObstacles
    close all; f = figure;  Obstacles = load('Obstacles.mat'); 
    Obstacles = Obstacles.Obstacles; axis(Obstacles{1}); grid on; ax = gca; 
    ax.YMinorGrid = 'on';ax.XMinorGrid = 'on'; hold on;
    dx = (ax.XTick(2) - ax.XTick(1))/5; dy = (ax.YTick(2) - ax.YTick(1))/5; 
    ax.XAxis.MinorTickValues = ax.XTick(1):dx:ax.XTick(end);
    ax.YAxis.MinorTickValues = ax.YTick(1):dy:ax.YTick(end);
    function resizefcn(H,~)
        if numel(H.Children)> 0
            ax = H.Children(end);
            dx = (ax.XTick(2) - ax.XTick(1))/5; 
            dy = (ax.YTick(2) - ax.YTick(1))/5; 
            ax.XAxis.MinorTickValues = ax.XTick(1):dx:ax.XTick(end);
            ax.YAxis.MinorTickValues = ax.YTick(1):dy:ax.YTick(end);
        end
    end
    f.SizeChangedFcn = @resizefcn; 
    for n = 2:numel(Obstacles)
        fill(Obstacles{n}(:,1),Obstacles{n}(:,2),[0.5,0.5,0.5],'Linewidth', 2); 
    end
    
    % test isfree
%     for n = 1:10
%         q = ginput(1);
%         disp(isFree(q, Obstacles));
%     end
end