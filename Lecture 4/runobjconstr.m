function [x,fval,exitflag,output] = runobjconstr(lb,ub,System,Options)

% Pomoćne promjenljive

x_last = [] ;
myf = [] ;
myc = [] ;
myceq = [] ;

% Kriterijumska funkcija i funkcija nelinearnih ograničenja

fun = @objective_function ;
cfun = @constraint_function ;

% Poziv optimizacionog algoritma

[x,fval,exitflag,output] = pso(fun,length(lb),[],[],[],[],lb,ub,cfun,Options) ; 

    % Lokalna funkcija za proračun kriterijumske funkcije

    function f = objective_function(x)

        if ~isequal(x,x_last)

            [myf,myc,myceq] = compute_all(x,System) ;
            x_last = x ;

        end

        f = myf ;

    end

    % Lokalna funkcija za proračun nelinearnih ograničenja
    
    function [c,ceq] = constraint_function(x)

        if ~isequal(x,x_last)

            [myf,myc,myceq] = compute_all(x,System) ;
            x_last = x ;

        end

        c = myc ;
        ceq = myceq ;

    end

end
