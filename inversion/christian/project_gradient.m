function [gp] = project_gradient(g, x, xl, xu)

    gp = zeros(length(x),1);
    for i=1:length(x)
        if ( x(i) == xl(i) )
               gp(i) = min(g(i), 0);
        elseif ( x(i) == xu(i) )
               gp(i) = max(g(i), 0);
        else
            gp(i) = g(i);
        end
    end

end