function solve_gap12_average()
    % Output file
    output_file = fopen('gap12_average_output.txt', 'w');
    if output_file == -1
        error('Could not open output file.');
    end

    % Only run for gap12.txt
    filename = './gap dataset files/gap12.txt';
    fid = fopen(filename, 'r');
    if fid == -1
        error('Error opening file %s.', filename);
    end

    % Read number of problem sets
    num_problems = fscanf(fid, '%d', 1);

    % Print dataset name
    fprintf(output_file, '\n%s\n', filename(1:end-4));

    for p = 1:num_problems
        % Read parameters
        m = fscanf(fid, '%d', 1);
        n = fscanf(fid, '%d', 1);
        c = fscanf(fid, '%d', [n, m])';
        r = fscanf(fid, '%d', [n, m])';
        b = fscanf(fid, '%d', [m, 1]);

        total_objective = 0;
        for iter = 1:20
            x_matrix = solve_gap_max(m, n, c, r, b);
            total_objective = total_objective + sum(sum(c .* x_matrix));
        end

        avg_objective = total_objective / 20;
        fprintf(output_file, 'c%d-%d  %d\n', m * 100 + n, p, round(avg_objective));
    end

    fclose(fid);
    fclose(output_file);
end

function x_matrix = solve_gap_max(m, n, c, r, b)
    f = -c(:); % For maximization
    Aeq_jobs = kron(eye(n), ones(1, m));
    beq_jobs = ones(n, 1);

    Aineq_agents = zeros(m, m * n);
    for i = 1:m
        for j = 1:n
            Aineq_agents(i, (j - 1) * m + i) = r(i, j);
        end
    end
    bineq_agents = b;

    lb = zeros(m * n, 1);
    ub = ones(m * n, 1);
    intcon = 1:(m * n);

    options = optimoptions('intlinprog', 'Display', 'off');
    x = intlinprog(f, intcon, Aineq_agents, bineq_agents, Aeq_jobs, beq_jobs, lb, ub, options);

    x_matrix = reshape(x, [m, n]);
end



% function solve_large_gap()
%     % Open output file
%     output_file = fopen('gap_max_output.txt', 'w');
%     if output_file == -1
%         error('Could not open output file.');
%     end
% 
%     % Iterate through gap1 to gap12
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
%         fprintf(output_file, '\n%s\n', filename(1:end-4)); % Removes .txt for display
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
%             % Solve the problem
%             x_matrix = solve_gap_max(m, n, c, r, b);
%             objective_value = sum(sum(c .* x_matrix));
% 
%             % Write formatted output
%             fprintf(output_file, 'c%d-%d  %d\n', m * 100 + n, p, round(objective_value));
%         end
% 
%         fclose(fid);
%     end
% 
%     % Close output file
%     fclose(output_file);
% end
% 
% function x_matrix = solve_gap_max(m, n, c, r, b)
%     f = -c(:); % Convert to column vector for maximization
% 
%     % Constraint 1: Each user assigned exactly once
%     Aeq_jobs = kron(eye(n), ones(1, m));
%     beq_jobs = ones(n, 1);
% 
%     % Constraint 2: Server resource constraints
%     Aineq_agents = zeros(m, m * n);
%     for i = 1:m
%         for j = 1:n
%             Aineq_agents(i, (j - 1) * m + i) = r(i, j);
%         end
%     end
%     bineq_agents = b;
% 
%     % Define variable bounds
%     lb = zeros(m * n, 1);
%     ub = ones(m * n, 1);
%     intcon = 1:(m * n);
% 
%     % Solve with intlinprog
%     options = optimoptions('intlinprog', 'Display', 'off');
%     x = intlinprog(f, intcon, Aineq_agents, bineq_agents, Aeq_jobs, beq_jobs, lb, ub, options);
% 
%     % Reshape to m × n matrix
%     x_matrix = reshape(x, [m, n]);
% end
