function solve_gap12_avg_greedy()
    % Output file
    output_file = fopen('approximation_avg.txt', 'w');
    if output_file == -1
        error('Could not open output file.');
    end

    % Load only gap12.txt
    filename = './gap dataset files/gap12.txt';
    fid = fopen(filename, 'r');
    if fid == -1
        error('Error opening file %s.', filename);
    end

    % Read number of problems
    num_problems = fscanf(fid, '%d', 1);

    fprintf(output_file, '\n%s\n', filename(1:end-4));

    for p = 1:num_problems
        m = fscanf(fid, '%d', 1); % servers
        n = fscanf(fid, '%d', 1); % users

        c = fscanf(fid, '%d', [n, m])'; % cost m x n
        r = fscanf(fid, '%d', [n, m])'; % resource m x n
        b = fscanf(fid, '%d', [m, 1]);  % capacity m x 1

        total_objective = 0;

        for run = 1:20
            x = greedy_gap(m, n, c, r, b);
            objective_value = sum(sum(c .* x));
            total_objective = total_objective + objective_value;
        end

        avg_objective = total_objective / 20;
        fprintf(output_file, 'c%d-%d  %.2f\n', m * 100 + n, p, avg_objective);
    end

    fclose(fid);
    fclose(output_file);
end

function x = greedy_gap(m, n, c, r, b)
    x = zeros(m, n);           % assignment matrix
    remaining_b = b(:);        % copy of server capacities

    for j = 1:n  % For each user
        best_cost = Inf;
        best_server = -1;
        for i = 1:m  % For each server
            if r(i, j) <= remaining_b(i) && c(i, j) < best_cost
                best_cost = c(i, j);
                best_server = i;
            end
        end

        if best_server > 0
            x(best_server, j) = 1;
            remaining_b(best_server) = remaining_b(best_server) - r(best_server, j);
        end
    end
end





% function solve_large_gap_greedy()
%     % Open file to save output
%     output_file = fopen('gap_greedy_output.txt', 'w');
%     if output_file == -1
%         error('Could not open output file.');
%     end
% 
%     % Loop over all datasets
%     for g = 1:12
%         filename = sprintf('./gap dataset files/gap%d.txt', g);
%         fid = fopen(filename, 'r');
%         if fid == -1
%             error('Error opening file %s.', filename);
%         end
% 
%         % Read number of problems
%         num_problems = fscanf(fid, '%d', 1);
% 
%         fprintf(output_file, '\n%s\n', filename(1:end-4));
% 
%         for p = 1:num_problems
%             m = fscanf(fid, '%d', 1); % servers
%             n = fscanf(fid, '%d', 1); % users
% 
%             c = fscanf(fid, '%d', [n, m])'; % cost m x n
%             r = fscanf(fid, '%d', [n, m])'; % resource m x n
%             b = fscanf(fid, '%d', [m, 1]);  % capacity m x 1
% 
%             x = greedy_gap(m, n, c, r, b);
%             objective_value = sum(sum(c .* x));
% 
%             fprintf(output_file, 'c%d-%d  %d\n', m * 100 + n, p, round(objective_value));
%         end
% 
%         fclose(fid);
%     end
% 
%     fclose(output_file);
% end
% 
% function x = greedy_gap(m, n, c, r, b)
%     x = zeros(m, n);           % assignment matrix
%     remaining_b = b(:);        % copy of server capacities
% 
%     for j = 1:n  % For each user
%         best_cost = Inf;
%         best_server = -1;
%         for i = 1:m  % For each server
%             if r(i, j) <= remaining_b(i) && c(i, j) < best_cost
%                 best_cost = c(i, j);
%                 best_server = i;
%             end
%         end
% 
%         if best_server > 0
%             x(best_server, j) = 1;
%             remaining_b(best_server) = remaining_b(best_server) - r(best_server, j);
%         end
%     end
% end
