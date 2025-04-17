function compare_gap_outputs_bar()
    % Load data from all files
    data1 = read_gap_output('approximation_avg.txt');
    data2 = read_gap_output('gap12_average_output.txt');
    data3 = read_gap_output('gap_ga_output.txt');

    % Extract instance names and objective values
    instance_names = data1(:, 1);
    y1 = str2double(data1(:, 2));
    y2 = str2double(data2(:, 2));
    y3 = str2double(data3(:, 2));

    % Combine into one matrix for bar plotting
    Y = [y1, y2, y3];

    % Create bar chart
    figure('Position', [100, 100, 1200, 600]);
    bar(Y);
    xticks(1:length(instance_names));
    xticklabels(instance_names);
    xtickangle(45);
    ylabel('Objective Value');
    xlabel('Instance');
    title('GAP12: Objective Value Comparison (Greedy vs GA vs Optimal)');
    legend({'Greedy (Avg of 20)', 'Optimal', 'GA Output'}, 'Location', 'northwest');
    grid on;

    % Save the figure
    saveas(gcf, 'gap_comparison.png');
end

function data = read_gap_output(filename)
    fid = fopen(filename, 'r');
    data = {};
    while ~feof(fid)
        line = fgetl(fid);
        if startsWith(line, 'c')
            tokens = regexp(line, '(\S+)\s+([\d\.]+)', 'tokens');
            if ~isempty(tokens)
                data(end + 1, :) = tokens{1}; %#ok<AGROW>
            end
        end
    end
    fclose(fid);
end



% 
% function compare_gap_outputs_by_file()
%     % Read all three output files
%     greedy_data = read_gap_output('./gap_greedy_output.txt');      % Approximation (Greedy)
%     ga_max_data = read_gap_output('./gap_max_output.txt');         % Optimal (GA Max)
%     ga_data = read_gap_output('./gap_ga_output.txt');             % Binary Coded GA (BGA)
% 
%     % Check consistency
%     if length(greedy_data.values) ~= length(ga_max_data.values) || ...
%        length(ga_max_data.values) ~= length(ga_data.values)
%         error('Mismatch in number of entries between files.');
%     end
% 
%     % Group data by gap file (assuming 5 instances per gap file)
%     gap_map = containers.Map();
%     for i = 1:length(ga_data.names)
%         gap_id = sprintf('gap%d', ceil(i / 5));
%         if ~isKey(gap_map, gap_id)
%             gap_map(gap_id) = [];
%         end
%         gap_map(gap_id) = [gap_map(gap_id), i];
%     end
% 
%     % Plot bar graph for each GAP file
%     gap_keys = keys(gap_map);
%     for k = 1:length(gap_keys)
%         gap_id = gap_keys{k};
%         indices = gap_map(gap_id);
% 
%         % Correcting the order for the values
%         approximation_vals = greedy_data.values(indices);      % Greedy (Approximation)
%         optimal_vals = ga_max_data.values(indices);            % GA Max (Optimal)
%         bga_vals = ga_data.values(indices);                    % GA (Binary Coded GA)
%         labels = greedy_data.names(indices);
% 
%         figure('Name', gap_id, 'NumberTitle', 'off');
%         bar([approximation_vals; optimal_vals; bga_vals]', 'grouped');   % Correct order of values
%         title(sprintf('GAP File: %s - Approximation (Greedy), Optimal (GA Max), Binary Coded GA (BGA)', gap_id), 'Interpreter', 'none');
%         xlabel('Problem Instance');
%         ylabel('Objective Value');
%         legend('Approximation (Greedy)', 'Optimal (GA Max)', 'Binary Coded GA (BGA)', 'Location', 'best');
%         xticks(1:length(labels));
%         xticklabels(labels);
%         xtickangle(45);
%         grid on;
%     end
% end
% 
% function data = read_gap_output(filename)
%     fid = fopen(filename, 'r');
%     if fid == -1
%         error('Cannot open file %s', filename);
%     end
% 
%     names = {};
%     values = [];
% 
%     while ~feof(fid)
%         line = strtrim(fgetl(fid));
%         if isempty(line) || contains(line, 'gap')
%             continue;
%         end
% 
%         tokens = regexp(line, '(c\d+-\d+)\s+(\d+)', 'tokens');
%         if ~isempty(tokens)
%             names{end+1} = tokens{1}{1};
%             values(end+1) = str2double(tokens{1}{2});
%         end
%     end
% 
%     fclose(fid);
% 
%     data.names = names;
%     data.values = values;
% end
