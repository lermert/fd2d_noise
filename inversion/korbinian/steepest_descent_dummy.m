
function [x,info] = steepest_descent_dummy(x,funcs,options)
    
    path(path,genpath('../../'))
    [Lx,Lz,nx,nz,~,~,~,~] = input_parameters();
    [~,~,~,~,dx,dz] = define_computational_domain(Lx,Lz,nx,nz);
    
    % define trial step length
    step_length = [1; 10];
    
    i = 1;
    fprintf('\nIter. \t Obj. \t\talpha \t |g|')
    fprintf('\n------------------------------------------')
    while true
         
        % compute misfit
        f = funcs.objective(x, options.auxdata);
        
        
        % print output
        if( i==1 )
            fprintf('\n%i \t %-6.2f \t%-6.2f \t %-6.2f',i-1, f(1,1))
        else
            fprintf('\n%i \t %-6.2f \t%-6.2f \t %-6.2e',i-1, f(1,1), step_optimum, sqrt(A))
        end
        
        
        % check prediction of decreasing misfit
        if( i > 1 && (f-f_prev) >= 0 )
            
            step_iter = step_iter + 1;
            if( step_iter > 5 )
                info.f = f(1,1);
                info.exit = -1;
                
                fprintf('\n\n Could not get improvement!\n\n')
                return    
            end
            
            % test smaller step lengths
            % [step_optimum,step_length] = test_step_length(x_prev,funcs,options,f_prev,h,step_length/2^(step_iter));
            step_optimum = step_optimum/2;
            x = x_prev - step_optimum*g;
            continue;
            
        else
            step_iter = 0;
        end
        
        % check if converged
        if( f(1,1) <= options.tol )
            info.f = f(1,1);
            info.exit = 0;
            
            fprintf('\n\n Solved successfully!\n\n')
            return
            
        % max. number of iterations exceeded    
        elseif( i > options.max_iter )
            info.f = f(1,1);
            info.exit = 10;
            
            fprintf('\n\n Reached max. number of iterations!\n\n')
            return
        end
        
        % check if misfit still changes
        if( i > 1 && abs(f-f_prev) < options.acceptable_change )
            
            fprintf('*')
            accept_iter = accept_iter + 1;
            if( accept_iter >= options.acceptable_iter )
                info.f = f(1,1);
                info.exit = 1;
                
                fprintf('\n\n Converged!\n\n')
                return
            end
            
        else
            accept_iter = 0;
        end
        
        
        % compute steepest descent direction for first iteration
        if( i == 1 )
            g = funcs.gradient(x, options.auxdata);
            A = sum(g.^2)*dx*dz;
            h = -1.0 * g;
            
        % compute conjugate direction for following iterations
        else
            g_prev = g;
            g = funcs.gradient (x, options.auxdata);
            
            A = sum(g.^2)*dx*dz;
            B = sum(g_prev.^2)*dx*dz;         
            beta = A/B;
            
            h_prev = h;
            h = -1.0*g + beta * h_prev;
        end
            
        
        % test step length
        [step_optimum,step_length] = test_step_length_dummy(x,funcs,options,f,h,step_length);
        
        % compute update
        x_prev = x;
        x = x - step_optimum*g;
        
        % next iteration
        f_prev = f;
        i = i+1;
        
    end

end