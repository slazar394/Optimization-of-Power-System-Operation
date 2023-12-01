% Proračun kriterijumske funkcije i nelinearnih ograničenja tipa jednakosti i nejednakosti

function [f,c,ceq] = compute_all(x,System)

% Ažuriranje podataka o sistemu

System.Buses.V(1) = x(1) ;
System.Buses.V(2) = x(2) ;
System.Buses.P_gen(2) = x(3) ;

% Proračun tokova snaga

[V,P_gen,Q_gen,S_branch] = power_flow(System) ;

% Proračun troškova pogona

P_gen = P_gen*100 ;

f = 0 ;

for i = 1 : size(System.Generators,1)

    f = f + System.Generators.Alpha(i) + System.Generators.Beta(i)*P_gen(i) + ...
        System.Generators.Gamma(i)*P_gen(i)^2 ;

end

P_gen = P_gen/100 ;

% Proračun nelinearnih ograničenja tipa nejednakosti - granične vrijednosti
% napona u čvorovima sistema, opterećenosti mrežnih elemenata i aktivnih i
% reaktivnih snaga generatora

c = [abs(V)-1.1
    -abs(V)+0.9
    abs(S_branch)-System.Branches.S_max
    P_gen-System.Generators.P_max
    Q_gen-System.Generators.Q_max
    -Q_gen+System.Generators.Q_min]' ;
ceq = [] ;

end