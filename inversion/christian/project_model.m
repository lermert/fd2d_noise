function [xp] = project_model(x, xl, xu)
    xp = zeros(length(x),1);
    for i=1:length(x)
        xp(i) = max(min(x(i), xu(i)),xl(i));
    end
end