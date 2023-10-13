% Priprema okruženja

clear variables
close all
clc

% Definicija kriterijumske funkcije

fun = @(P) 0.008*P(1)^2 + 7*P(1) + 200 + ...
    0.009*P(2)^2 + 6.3*P(2) + 180 + ...
    0.007*P(3)^2 + 6.8*P(3) + 140 ; 

% Granične vrijednosti promjenljivih (Pmin <= P <= Pmax)

lb = [10 10 10] ;
ub = [85 80 70] ; 

% Definicija nelinearnih ograničenja

nonlcon = @nonlinear_constraints ; 

% Rješavanje optimizacionog problema

[P,fval] = fmincon(fun,lb,[],[],[],[],lb,ub,nonlcon) ; 

% Funkcija za proračun nelinearnih ograničenja tipa jednakosti (ceq(x)=0) i 
% nelinearnih ograničenja tipa nejednakosti (c(x)<=0)

function [c,ceq] = nonlinear_constraints(P)

% Nelinearna ograničenja tipa nejednakosti nijesu zastupljena u
% optimizacionom problemu

c = [] ;

% Bilansna jednačina se predstavlja nelinearnim ograničenjima tipa
% jednakosti (P1 + P2 + P3 = Pp + Pl, odnosno P1 + P2 + P3 - Pp - Pl = 0)

ceq = P(1) + P(2) + P(3) - 150 - 0.000218*P(1)^2 - 0.000228*P(2)^2 - ...
    0.000179*P(3)^2 ; 

end