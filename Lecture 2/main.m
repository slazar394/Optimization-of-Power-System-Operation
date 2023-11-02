% Script to minimize Rosenbrock's function constrained with a cubic and a
% line

clear variables
close all
clc

% Define the objective function

Problem.Objective_Function = @(x) (1-x(1))^2 + 100*(x(2)-x(1)^2)^2 ; 
Problem.Number_of_Variables = 2 ;
Problem.Lower_Bounds = [-1.5 -0.5] ;
Problem.Upper_Bounds = [1.5 2.5] ;
Problem.Constraint_Function = @(x) x(1)^2 - x(2)^2 - 2 ;
Problem.Problem_Type = "min" ;

% Define the algorithm parameters

Parameters.Population_Size = 20 ; 
Parameters.Number_of_Generations = 100 ;
Parameters.Scale_Factor = 0.8 ;
Parameters.Crossover_Probability = 0.9 ; 

% Call the optimization algorithm

Best_Individual = differential_evolution(Problem,Parameters) ; 