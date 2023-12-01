% Priprema okruženja

clear variables
close all
clc

% Učitavanje podataka o sistemu

load("Test system.mat","System") ; 

% Definisanje broja promjenljivih i njihovih graničnih vrijednosti

Number_of_Variables = 3 ;
Lower_Bounds = [0.9 0.9 0] ;
Upper_Bounds = [1.1 1.1 2] ;

% Definisanje opcija za optimizacioni algoritam (voditi računa da zbir
% socijalne i kognitivne komponente mora biti manji od 4, kao i da polovina
% njihovog zbira mora biti manja od 1 kako bi se osigurala konvergencija, 
% igrati se sa parametrima u cilju stabilnije konvergencije)

Options = psooptimset() ;
Options.CognitiveAttraction = 0.5 ; 
Options.SocialAttraction = 1.25 ; 
Options.PopulationSize = 50 ; 
Options.PlotFcns = @psoplotbestf ;

% Poziv optimizacionog algoritma

[x,fval,exitflag,~] = runobjconstr(Lower_Bounds,Upper_Bounds,System,Options) ; 