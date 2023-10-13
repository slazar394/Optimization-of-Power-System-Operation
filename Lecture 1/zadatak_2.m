% Priprema okruženja

clear variables
close all
clc

% Definicija kriterijumske funkcije

H = diag(2*[0.004 0.006 0.009]) ;  
f = [5.3 5.5 5.8]' ;

% Definicija linearnih ograničenja tipa jednakosti (P1 + P2 + P3 = 975)

Aeq = [1 1 1] ; 
beq = 975 ; 

% Granične vrijednosti optimizacionih promjenljivih (Pmin <= P <= Pmax)

lb = [250 150 100] ; 
ub = [450 350 225] ; 

% Rješavanje optimizacionog problema

[P,fval] = quadprog(H,f,[],[],Aeq,beq,lb,ub) ; 