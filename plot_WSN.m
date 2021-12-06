function plot_WSN(n, border, SN, SINK)
xm = border;
ym = border;
    for i=1:n
        hold on;
        figure(1)
        plot(0,0,xm,ym, SN(i).x ,SN(i).y,'ob',SINK.x,SINK.y,'*r');
        title 'Wireless Sensor Network';
        xlabel '(m)';
        ylabel '(m)';
    end
end