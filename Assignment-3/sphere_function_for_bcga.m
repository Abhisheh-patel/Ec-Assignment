function sphere_bcga_min_solver()
    % Binary-Coded Genetic Algorithm (BCGA) for Sphere Function Minimization
    bestFitnessHistory = run_bcga_sphere_min();

    % Plot convergence curve
    figure;
    plot(bestFitnessHistory, 'm-', 'LineWidth', 2);
    title('Convergence Curve - Binary-Coded GA Minimizing Sphere Function');
    xlabel('Generation');
    ylabel('Best Fitness Value (Sum of Squares)');
    grid on;

    % Save the plot as an image file
    resultsDir = 'results';
    if ~exist(resultsDir, 'dir')
        mkdir(resultsDir);
    end
    saveas(gcf, fullfile(resultsDir, 'sphere_bcga_min_convergence.png'));
end

function bestFitnessHistory = run_bcga_sphere_min()
    % Problem settings
    dim = 30;
    numBits = 16;               % bits per dimension
    chromosomeLength = dim * numBits;
    populationSize = 100;
    maxGenerations = 300;
    mutationProbability = 0.01;
    crossoverProbability = 0.9;
    lb = -5;
    ub = 5;

    % Initialize population (binary strings)
    population = randi([0, 1], populationSize, chromosomeLength);
    fitnessScores = evaluate_population(population, numBits, lb, ub, dim);
    bestFitnessHistory = zeros(maxGenerations, 1);

    for gen = 1:maxGenerations
        % Tournament selection
        matingPool = tournament_select_binary(population, fitnessScores);

        % Single-point crossover
        offspring = matingPool;
        for i = 1:2:populationSize-1
            if rand < crossoverProbability
                point = randi([2, chromosomeLength-1]);
                offspring([i, i+1], :) = [ ...
                    [matingPool(i, 1:point), matingPool(i+1, point+1:end)]; ...
                    [matingPool(i+1, 1:point), matingPool(i, point+1:end)] ...
                ];
            end
        end

        % Bit-flip mutation
        mutationCount = round(mutationProbability * numel(offspring));
        for m = 1:mutationCount
            row = randi(populationSize);
            col = randi(chromosomeLength);
            offspring(row, col) = 1 - offspring(row, col);
        end

        % Combine and select best individuals
        combinedPop = [population; offspring];
        combinedFitness = evaluate_population(combinedPop, numBits, lb, ub, dim);
        [~, sortedIndices] = sort(combinedFitness, 'ascend');
        population = combinedPop(sortedIndices(1:populationSize), :);
        fitnessScores = combinedFitness(sortedIndices(1:populationSize));

        % Store best fitness of current generation
        bestFitnessHistory(gen) = min(fitnessScores);
    end
end

function fitnessScores = evaluate_population(population, numBits, lb, ub, dim)
    % Decode binary population to real values, then compute fitness
    numIndividuals = size(population, 1);
    decodedValues = zeros(numIndividuals, dim);
    for i = 1:numIndividuals
        decodedValues(i, :) = decode_chromosome(population(i, :), numBits, lb, ub, dim);
    end
    fitnessScores = sum(decodedValues.^2, 2); % Sphere function
end

function values = decode_chromosome(chromosome, numBits, lb, ub, dim)
    values = zeros(1, dim);
    for d = 1:dim
        bits = chromosome((d-1)*numBits+1 : d*numBits);
        intVal = sum(bits .* 2.^(numBits-1:-1:0));
        values(d) = lb + (ub - lb) * double(intVal) / (2^numBits - 1);
    end
end

function selected = tournament_select_binary(population, fitness)
    numIndividuals = size(population, 1);
    selected = zeros(size(population));
    for k = 1:numIndividuals
        c1 = randi(numIndividuals);
        c2 = randi(numIndividuals);
        if fitness(c1) < fitness(c2)
            selected(k, :) = population(c1, :);
        else
            selected(k, :) = population(c2, :);
        end
    end
end
