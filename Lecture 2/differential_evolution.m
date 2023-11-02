function Best_Individual = differential_evolution(Problem,Parameters)

% Define the optimization problem: objective function, number of variables,
% variable limits, constraint function, problem type (minimization or
% maximization)

Objective_Function = Problem.Objective_Function ;
Number_of_Variables = Problem.Number_of_Variables ;
Lower_Bounds = Problem.Lower_Bounds ;
Upper_Bounds = Problem.Upper_Bounds ;
Constraint_Function = Problem.Constraint_Function ;
Problem_Type = Problem.Problem_Type ;

% Convert the objective to the fitness function based on problem type

if strcmp(Problem_Type,"min")

    Fitness_Function = @(x) 1/(1+Objective_Function(x)) ;

else

    Fitness_Function = @(x) Objective_Function(x) ;

end

% Define the algorithm parameters: population size, number of generations,
% scale factor and crossover probability

Population_Size = Parameters.Population_Size ;
Number_of_Generations = Parameters.Number_of_Generations ;
Scale_Factor = Parameters.Scale_Factor ;
Crossover_Probability = Parameters.Crossover_Probability ;

% Initialize the population

Individual.Genes = zeros(1,Number_of_Variables) ;
Individual.Fitness = -Inf ;
Individual.Constraints = Inf ;
Population = repmat(Individual,[Population_Size 1]) ;
New_Population = Population ;
Best_Individual = Individual ;

for i = 1 : Population_Size

    % Generate the genes of the individual within the variable bounds

    Population(i).Genes = unifrnd(Lower_Bounds,Upper_Bounds,[1 Number_of_Variables]) ;

    % Evaluate individual's fitness

    Population(i).Fitness = Fitness_Function(Population(i).Genes) ;

    % Evaluate the constraints

    Population(i).Constraints = Constraint_Function(Population(i).Genes) ;

    % Update the best individual

    if all(Population(i).Constraints<=0) && Population(i).Fitness >= Best_Individual.Fitness

        Best_Individual = Population(i) ;

    end

end

% Main loop: perform operations of mutation, crossover and selection until
% convergence

for Generation = 1 : Number_of_Generations

    % Loop through each individual

    for i = 1 : Population_Size

        % Select the target individual

        Target_Individual = Population(i) ;

        % Choose three individuals that will be used in differential
        % mutation (the target individual can't be chosen neither as base,
        % nor as differential vectors)

        Possible_Individual_IDs = [1:i-1 i+1:Population_Size] ;
        Selected_Individual_IDs = Possible_Individual_IDs(randperm(length(Possible_Individual_IDs),3)) ;
        Selected_Individuals = Population(Selected_Individual_IDs) ;

        % Generate a mutated individual

        Mutated_Individual = Individual ;
        Mutated_Individual.Genes = Selected_Individuals(1).Genes + ...
            Scale_Factor*(Selected_Individuals(2).Genes - ...
            Selected_Individuals(3).Genes) ;

        % Perform crossover to generate a trial individual

        Trial_Individual = Individual ;
        Selected_Variable = randperm(Number_of_Variables,1) ;

        for j = 1 : Number_of_Variables

            if Number_of_Variables == 1 || Selected_Variable == j || rand() <= Crossover_Probability

                Trial_Individual.Genes(j) = Mutated_Individual.Genes(j) ;

            else

                Trial_Individual.Genes(j) = Target_Individual.Genes(j) ;

            end

        end

        % Limit the genes of the trial individual within specified bounds

        Trial_Individual.Genes = min(Trial_Individual.Genes,Upper_Bounds) ;
        Trial_Individual.Genes = max(Trial_Individual.Genes,Lower_Bounds) ;

        % Evaluate the fitness and the constraints of the trial individual

        Trial_Individual.Fitness = Fitness_Function(Trial_Individual.Genes) ;
        Trial_Individual.Constraints = Constraint_Function(Trial_Individual.Genes) ;

        % Perform selection of the individual for the new population based on
        % the following rules:
        % 1. If both individuals satisfy the constraints, the better individual
        % is the one with the higher fitness.
        % 2. If one of the individuals doesn't satisfy the constraints and the
        % other one does, the better individual is the one that satisfies the
        % constraints.
        % 3. If none of the individuals satisfy the constraints, the trial
        % individual is chosen for the new population.

        if all(Target_Individual.Constraints <= 0) && all(Trial_Individual.Constraints <= 0)

            if Trial_Individual.Fitness >= Target_Individual.Fitness

                New_Population(i) = Trial_Individual ;

                % Compare the trial individual with the best individual

                if Trial_Individual.Fitness >= Best_Individual.Fitness

                    Best_Individual = Trial_Individual ;

                end

            else

                New_Population(i) = Target_Individual ;

            end

        elseif all(Target_Individual.Constraints <= 0) && any(Trial_Individual.Constraints > 0)

            New_Population(i) = Target_Individual ;

        elseif all(Trial_Individual.Constraints <= 0) && any(Target_Individual.Constraints > 0)

            New_Population(i) = Trial_Individual ;

        else

            New_Population(i) = Trial_Individual ;

        end

    end

    % Update the population

    Population = New_Population ;

    % Plot the current population

    if Number_of_Variables == 2

        if Generation == 1

            figure

        end

        X = reshape([Population.Genes],[Population_Size Number_of_Variables]) ;
        f = reshape([Population.Fitness],[Population_Size 1]) ;
        scatter(X(:,1),X(:,2),25,f,'filled') ;
        xlim([Lower_Bounds(:,1) Upper_Bounds(:,1)])
        ylim([Lower_Bounds(:,1) Upper_Bounds(:,1)])
        pause(0.1)

    end

    % Display the best individual

    disp(strcat("Generation ",num2str(Generation),": the position of the best individual is ",...
        num2str(Best_Individual.Genes)))

    % Check for convergence

    if abs(max([Population.Fitness])-min([Population.Fitness])) <= 1e-6

        break

    end

end

end