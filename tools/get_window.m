function win = get_window(t,t_min,t_max,type)

%This is a row vector. 
win = ones(1,length(t));


if strcmp(type,'box')
    win = win.*(t>t_min).*(t<t_max);
    
elseif strcmp(type,'hann')
    win = win.*(t>t_min).*(t<t_max);
    i1 = find(win,1);
    i2 = find(win,1,'last');
    
    win(i1:i2) = hann(i2-i1+1);
    
elseif strcmp(type, 'cos_taper')
    % tapering width
    width = abs(t_max-t_min)*0.1;

    % this matlab functionality selects the parts of win between t_min and 
    % t_max
    win = win.*(t>t_min).*(t<t_max);
    win = win + (0.5+0.5*cos(pi*(t_max-t)/(width))).*(t>=t_max).*(t<t_max+width);
    win = win + (0.5+0.5*cos(pi*(t_min-t)/(width))).*(t>t_min-width).*(t<=t_min);
    
end

