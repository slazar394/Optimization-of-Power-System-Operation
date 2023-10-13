% Priprema okruženja

clear variables
close all
clc

% Definicija kriterijumske funkcije

H = diag(2*[0.004 0.006 0.009]) ;  
f = [5.3 5.5 5.8]' ;

% Definicija linearnih ograničenja tipa jednakosti (P1 + P2 + P3 = 800)

Aeq = [1 1 1] ; 
beq = 800 ; 

% Rješavanje optimizacionog problema

[P,fval] = quadprog(H,f,[],[],Aeq,beq) ;