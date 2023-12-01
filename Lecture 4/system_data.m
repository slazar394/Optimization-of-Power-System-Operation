% Script to extract the system data from the .xlsx file and convert it to a
% .mat file

clear variables
close all
clc

% Load the bus and branch data

Buses = readtable("System data.xlsx","Sheet","Bus data") ; 
Branches = readtable("System data.xlsx","Sheet","Branch data") ;
Generators = readtable("System data.xlsx","Sheet","Generator data") ; 

% Store the bus and branch data in a System structure and save the data

System.Buses = Buses ;
System.Branches = Branches ; 
System.Generators = Generators ; 
save("Test system.mat","System") ; 