
function [step_optimum,step_length] = test_step_length_dummy(x,funcs,options,f,h,step_length)

while true
    
    % test step lengths
    for j = 1:length(step_length)
        f(j+1,1) = funcs.objective(x + step_length(j)*h, options.auxdata);
    end

    % find optimum step length
    p = polyfit([0; step_length],f,2);
    step_range = linspace(0,2*max(step_length),100);
    poly = polyval(p, step_range );

    [prediction, index] = min( poly );
    step_optimum = step_range(index);

    figure(1)
    clf
    hold on
    plot([0;step_length],f,'o')
    plot(step_range, poly)
    plot(step_optimum, prediction,'rx')

    xlabel('step length')
    ylabel('misfit')
    drawnow

    print('-dps','-append',sprintf('logs/Iteration.ps'))
    
    if( p(1) > 0 )
        break
    else
        step_length = step_length/2;
    end
        
    
end

end