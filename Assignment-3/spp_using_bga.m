function solve_large_gap_ga()
    % Open a file to save the output
    output_file = fopen('gap_ga_output.txt', 'w');
    if output_file == -1
        error('Could not open output file.');
    end

    % Only solve for gap12
    g = 12;
    filename = sprintf('./gap dataset files/gap%d.txt', g);
    fid = fopen(filename, 'r');
    if fid == -1
        error('Error opening file %s.', filename);
    end

    % Read the number of problem sets
    num_problems = fscanf(fid, '%d', 1);

    % Print dataset name (gap12)
    fprintf(output_file, '\n%s\n', filename(1:end-4)); % Removes .txt

    for p = 1:num_problems
        % Read problem parameters
        m = fscanf(fid, '%d', 1); % Number of servers
        n = fscanf(fid, '%d', 1); % Number of users

        % Read cost and resource matrices
        c = fscanf(fid, '%d', [n, m])';
        r = fscanf(fid, '%d', [n, m])';

        % Read server capacities
        b = fscanf(fid, '%d', [m, 1]);

        % Run GA 20 times and take average
        total_value = 0;
        convergence_all = zeros(20, 300); % 300 generations

        for run = 1:20
            [x_matrix, convergence] = solve_gap_ga(m, n, c, r, b);
            total_value = total_value + sum(sum(c .* x_matrix));
            convergence_all(run, :) = convergence;
        end

        avg_value = total_value / 20;

        % Print formatted output
        fprintf(output_file, 'c%d-%d  %.2f\n', m * 100 + n, p, avg_value);

        % Plot convergence for last instance
        if p == num_problems
            figure;
            plot(1:300, convergence_all(end, :), 'b-', 'LineWidth', 2);
            xlabel('Generation');
            ylabel('Best Fitness Value');
            title(sprintf('GA Convergence (Last Run) - c%d-%d', m * 100 + n, p));
            grid on;
            saveas(gcf, 'ga_convergence_gap12_last_instance.png');
        end
    end

    fclose(fid);
    fclose(output_file);
end

function [x_matrix, convergence] = solve_gap_ga(m, n, c, r, b)
    % GA Parameters
    pop_size = 100;
    max_gen = 300;
    crossover_rate = 0.8;
    mutation_rate = 0.1;

    % Initialize population
    population = zeros(pop_size, m * n);
    for i = 1:pop_size
        x_mat = zeros(m, n);
        for j = 1:n
            s = randi(m);
            x_mat(s, j) = 1;
        end
        population(i, :) = reshape(x_mat, [1, m * n]);
    end

    fitness = arrayfun(@(i) fitnessFcn(population(i, :)), 1:pop_size);
    convergence = zeros(1, max_gen); % Track best fitness over generations

    for gen = 1:max_gen
        parents = tournamentSelection(population, fitness);
        offspring = singlePointCrossover(parents, crossover_rate);
        mutated_offspring = mutation(offspring, mutation_rate);

        for i = 1:size(mutated_offspring, 1)
            mutated_offspring(i, :) = enforce_feasibility(mutated_offspring(i, :), m, n);
        end

        new_fitness = arrayfun(@(i) fitnessFcn(mutated_offspring(i, :)), 1:size(mutated_offspring, 1));

        population = [population; mutated_offspring];
        fitness = [fitness, new_fitness];

        [~, sorted_idx] = sort(fitness, 'descend');
        population = population(sorted_idx(1:pop_size), :);
        fitness = fitness(sorted_idx(1:pop_size));

        convergence(gen) = fitness(1);
    end

    [~, best_idx] = max(fitness);
    x_matrix = reshape(population(best_idx, :), [m, n]);

    function fval = fitnessFcn(x)
        x_mat = reshape(x, [m, n]);
        cost = sum(sum(c .* x_mat));
        capacity_violation = sum(max(sum(x_mat .* r, 2) - b, 0));
        assignment_violation = sum(abs(sum(x_mat, 1) - 1));
        penalty = 1e6 * (capacity_violation + assignment_violation);
        fval = cost - penalty;
    end
end

function selected = tournamentSelection(population, fitness)
    pop_size = size(population, 1);
    selected = zeros(size(population));

    for i = 1:pop_size
        idx1 = randi(pop_size);
        idx2 = randi(pop_size);
        if fitness(idx1) > fitness(idx2)
            selected(i, :) = population(idx1, :);
        else
            selected(i, :) = population(idx2, :);
        end
    end
end

function offspring = singlePointCrossover(parents, crossover_rate)
    pop_size = size(parents, 1);
    num_genes = size(parents, 2);
    offspring = parents;

    for i = 1:2:pop_size - 1
        if rand < crossover_rate
            point = randi(num_genes - 1);
            offspring(i, point+1:end) = parents(i+1, point+1:end);
            offspring(i+1, point+1:end) = parents(i, point+1:end);
        end
    end
end

function mutated = mutation(offspring, mutation_rate)
    mutated = offspring;
    for i = 1:numel(offspring)
        if rand < mutation_rate
            mutated(i) = 1 - mutated(i);
        end
    end
end

function x_corrected = enforce_feasibility(x, m, n)
    x_mat = reshape(x, [m, n]);
    for j = 1:n
        [~, idx] = max(x_mat(:, j));
        x_mat(:, j) = 0;
        x_mat(idx, j) = 1;
    end
    x_corrected = reshape(x_mat, [1, m * n]);
end


% function solve_large_gap_ga()
%     % Open a file to save the output
%     output_file = fopen('gap_ga_output.txt', 'w');
%     if output_file == -1
%         error('Could not open output file.');
%     end
% 
%     % Only solve for gap12
%     g = 12;
%     filename = sprintf('./gap dataset files/gap%d.txt', g);
%     fid = fopen(filename, 'r');
%     if fid == -1
%         error('Error opening file %s.', filename);
%     end
% 
%     % Read the number of problem sets
%     num_problems = fscanf(fid, '%d', 1);
% 
%     % Print dataset name (gap12)
%     fprintf(output_file, '\n%s\n', filename(1:end-4)); % Removes .txt
% 
%     for p = 1:num_problems
%         % Read problem parameters
%         m = fscanf(fid, '%d', 1); % Number of servers
%         n = fscanf(fid, '%d', 1); % Number of users
% 
%         % Read cost and resource matrices
%         c = fscanf(fid, '%d', [n, m])';
%         r = fscanf(fid, '%d', [n, m])';
% 
%         % Read server capacities
%         b = fscanf(fid, '%d', [m, 1]);
% 
%         % Run GA 20 times and take average
%         total_value = 0;
%         for run = 1:20
%             x_matrix = solve_gap_ga(m, n, c, r, b);
%             total_value = total_value + sum(sum(c .* x_matrix));
%         end
%         avg_value = total_value / 20;
% 
%         % Print formatted output
%         fprintf(output_file, 'c%d-%d  %.2f\n', m * 100 + n, p, avg_value);
%     end
% 
%     % Close dataset file
%     fclose(fid);
%     % Close output file
%     fclose(output_file);
% end
% 
% function x_matrix = solve_gap_ga(m, n, c, r, b)
%     % GA Parameters
%     pop_size = 100;
%     max_gen = 300;
%     crossover_rate = 0.8;
%     mutation_rate = 0.1;
% 
%     % Initialize population
%     population = zeros(pop_size, m * n);
%     for i = 1:pop_size
%         x_mat = zeros(m, n);
%         for j = 1:n
%             s = randi(m);
%             x_mat(s, j) = 1;
%         end
%         population(i, :) = reshape(x_mat, [1, m * n]);
%     end
% 
%     fitness = arrayfun(@(i) fitnessFcn(population(i, :)), 1:pop_size);
% 
%     for gen = 1:max_gen
%         parents = tournamentSelection(population, fitness);
%         offspring = singlePointCrossover(parents, crossover_rate);
%         mutated_offspring = mutation(offspring, mutation_rate);
% 
%         for i = 1:size(mutated_offspring, 1)
%             mutated_offspring(i, :) = enforce_feasibility(mutated_offspring(i, :), m, n);
%         end
% 
%         new_fitness = arrayfun(@(i) fitnessFcn(mutated_offspring(i, :)), 1:size(mutated_offspring, 1));
% 
%         population = [population; mutated_offspring];
%         fitness = [fitness, new_fitness];
% 
%         [~, sorted_idx] = sort(fitness, 'descend');
%         population = population(sorted_idx(1:pop_size), :);
%         fitness = fitness(sorted_idx(1:pop_size));
%     end
% 
%     [~, best_idx] = max(fitness);
%     x_matrix = reshape(population(best_idx, :), [m, n]);
% 
%     function fval = fitnessFcn(x)
%         x_mat = reshape(x, [m, n]);
%         cost = sum(sum(c .* x_mat));
%         capacity_violation = sum(max(sum(x_mat .* r, 2) - b, 0));
%         assignment_violation = sum(abs(sum(x_mat, 1) - 1));
%         penalty = 1e6 * (capacity_violation + assignment_violation);
%         fval = cost - penalty;
%     end
% end
% 
% function selected = tournamentSelection(population, fitness)
%     pop_size = size(population, 1);
%     selected = zeros(size(population));
% 
%     for i = 1:pop_size
%         idx1 = randi(pop_size);
%         idx2 = randi(pop_size);
%         if fitness(idx1) > fitness(idx2)
%             selected(i, :) = population(idx1, :);
%         else
%             selected(i, :) = population(idx2, :);
%         end
%     end
% end
% 
% function offspring = singlePointCrossover(parents, crossover_rate)
%     pop_size = size(parents, 1);
%     num_genes = size(parents, 2);
%     offspring = parents;
% 
%     for i = 1:2:pop_size - 1
%         if rand < crossover_rate
%             point = randi(num_genes - 1);
%             offspring(i, point+1:end) = parents(i+1, point+1:end);
%             offspring(i+1, point+1:end) = parents(i, point+1:end);
%         end
%     end
% end
% 
% function mutated = mutation(offspring, mutation_rate)
%     mutated = offspring;
%     for i = 1:numel(offspring)
%         if rand < mutation_rate
%             mutated(i) = 1 - mutated(i);
%         end
%     end
% end
% 
% function x_corrected = enforce_feasibility(x, m, n)
%     x_mat = reshape(x, [m, n]);
%     for j = 1:n
%         [~, idx] = max(x_mat(:, j));
%         x_mat(:, j) = 0;
%         x_mat(idx, j) = 1;
%     end
%     x_corrected = reshape(x_mat, [1, m * n]);
% end



% function solve_large_gap_ga()
%     % Open a file to save the output
%     output_file = fopen('gap_ga_output.txt', 'w');
%     if output_file == -1
%         error('Could not open output file.');
%     end
% 
%     % Iterate through gap1 to gap12 dataset files
%     for g = 1:12
%         filename = sprintf('./gap dataset files/gap%d.txt', g);
%         fid = fopen(filename, 'r');
%         if fid == -1
%             error('Error opening file %s.', filename);
%         end
% 
%         % Read the number of problem sets
%         num_problems = fscanf(fid, '%d', 1);
% 
%         % Print dataset name (gapX)
%         fprintf(output_file, '\n%s\n', filename(1:end-4)); % Removes .txt
% 
%         for p = 1:num_problems
%             % Read problem parameters
%             m = fscanf(fid, '%d', 1); % Number of servers
%             n = fscanf(fid, '%d', 1); % Number of users
% 
%             % Read cost and resource matrices
%             c = fscanf(fid, '%d', [n, m])';
%             r = fscanf(fid, '%d', [n, m])';
% 
%             % Read server capacities
%             b = fscanf(fid, '%d', [m, 1]);
% 
%             % Solve using Genetic Algorithm (GA)
%             x_matrix = solve_gap_ga(m, n, c, r, b);
%             objective_value = sum(sum(c .* x_matrix)); % Maximization
% 
%             % Print formatted output
%             fprintf(output_file, 'c%d-%d  %d\n', m * 100 + n, p, round(objective_value));
%         end
% 
%         % Close dataset file
%         fclose(fid);
%     end
% 
%     % Close output file
%     fclose(output_file);
% end
% 
% function x_matrix = solve_gap_ga(m, n, c, r, b)
%     % GA Parameters
%     pop_size = 100; % Population size
%     max_gen = 300;  % Maximum generations
%     crossover_rate = 0.8;
%     mutation_rate = 0.1;
% 
%     % Feasible initial population: each user assigned to one server
%     population = zeros(pop_size, m * n);
%     for i = 1:pop_size
%         x_mat = zeros(m, n);
%         for j = 1:n
%             s = randi(m); % Random server
%             x_mat(s, j) = 1;
%         end
%         population(i, :) = reshape(x_mat, [1, m * n]);
%     end
% 
%     % Evaluate initial fitness
%     fitness = arrayfun(@(i) fitnessFcn(population(i, :)), 1:pop_size);
% 
%     % Main GA loop
%     for gen = 1:max_gen
%         % Selection (Tournament)
%         parents = tournamentSelection(population, fitness);
% 
%         % Crossover
%         offspring = singlePointCrossover(parents, crossover_rate);
% 
%         % Mutation
%         mutated_offspring = mutation(offspring, mutation_rate);
% 
%         % Enforce feasibility
%         for i = 1:size(mutated_offspring, 1)
%             mutated_offspring(i, :) = enforce_feasibility(mutated_offspring(i, :), m, n);
%         end
% 
%         % Evaluate fitness of new population
%         new_fitness = arrayfun(@(i) fitnessFcn(mutated_offspring(i, :)), 1:size(mutated_offspring, 1));
% 
%         % Elitism and merging
%         population = [population; mutated_offspring];
%         fitness = [fitness, new_fitness];
% 
%         % Select top individuals
%         [~, sorted_idx] = sort(fitness, 'descend');
%         population = population(sorted_idx(1:pop_size), :);
%         fitness = fitness(sorted_idx(1:pop_size));
%     end
% 
%     % Return best solution
%     [~, best_idx] = max(fitness);
%     x_matrix = reshape(population(best_idx, :), [m, n]);
% 
%     % Fitness Function
%     function fval = fitnessFcn(x)
%         x_mat = reshape(x, [m, n]);
%         cost = sum(sum(c .* x_mat)); % Maximize
% 
%         % Penalty for constraint violation
%         capacity_violation = sum(max(sum(x_mat .* r, 2) - b, 0)); % Server capacity
%         assignment_violation = sum(abs(sum(x_mat, 1) - 1));       % User assignment
%         penalty = 1e6 * (capacity_violation + assignment_violation);
% 
%         fval = cost - penalty;
%     end
% end
% 
% function selected = tournamentSelection(population, fitness)
%     pop_size = size(population, 1);
%     selected = zeros(size(population));
% 
%     for i = 1:pop_size
%         idx1 = randi(pop_size);
%         idx2 = randi(pop_size);
%         if fitness(idx1) > fitness(idx2)
%             selected(i, :) = population(idx1, :);
%         else
%             selected(i, :) = population(idx2, :);
%         end
%     end
% end
% 
% function offspring = singlePointCrossover(parents, crossover_rate)
%     pop_size = size(parents, 1);
%     num_genes = size(parents, 2);
%     offspring = parents;
% 
%     for i = 1:2:pop_size - 1
%         if rand < crossover_rate
%             point = randi(num_genes - 1);
%             offspring(i, point+1:end) = parents(i+1, point+1:end);
%             offspring(i+1, point+1:end) = parents(i, point+1:end);
%         end
%     end
% end
% 
% function mutated = mutation(offspring, mutation_rate)
%     mutated = offspring;
%     for i = 1:numel(offspring)
%         if rand < mutation_rate
%             mutated(i) = 1 - mutated(i); % Flip bit
%         end
%     end
% end
% 
% function x_corrected = enforce_feasibility(x, m, n)
%     % Ensure one server per user
%     x_mat = reshape(x, [m, n]);
%     for j = 1:n
%         [~, idx] = max(x_mat(:, j)); % Assign to best candidate
%         x_mat(:, j) = 0;
%         x_mat(idx, j) = 1;
%     end
%     x_corrected = reshape(x_mat, [1, m * n]);
% end
