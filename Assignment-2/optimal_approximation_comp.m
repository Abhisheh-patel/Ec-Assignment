function draw_gap12_bar_graph()
    % Input files must be in the same directory
    max_file = 'gap_max_output.txt';
    greedy_file = 'gap_greedy_output.txt';

    % Read output data
    ga_data = read_gap_output(max_file);
    greedy_data = read_gap_output(greedy_file);

    % Extract gap12 entries (label starts with 'c1060')
    gap12_key = 'c1060';
    ga_idx = find(startsWith(ga_data.names, gap12_key));
    greedy_idx = find(startsWith(greedy_data.names, gap12_key));

    if length(ga_idx) ~= length(greedy_idx)
        error('Mismatch in number of entries for gap12.');
    end

    ga_vals = ga_data.values(ga_idx);
    greedy_vals = greedy_data.values(greedy_idx);
    labels = ga_data.names(ga_idx);

    % Create the bar graph
    fig = figure('Visible', 'off');
    bar([ga_vals(:), greedy_vals(:)]);
    title('Bar Chart: GAP12 Optimal vs. Greedy');
    ylabel('Objective Value');
    xticks(1:length(labels));
    xticklabels(labels);
    legend('Optimal Algorithm', 'Greedy Approximation', 'Location', 'best');
    xtickangle(45);
    grid on;

    % Create 'results' folder if it doesn't exist (in current directory)
    if ~exist('results', 'dir')
        mkdir('results');  % Ensures a folder named exactly 'results' is created
    end

    % Save the plot in results/
    saveas(fig, 'results/gap12_bar_comparison.png');
    close(fig);

    fprintf('✅ Bar graph saved to: results/gap12_bar_comparison.png\n');
end

function data = read_gap_output(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open file: %s', filename);
    end

    names = {};
    values = [];

    while ~feof(fid)
        line = strtrim(fgetl(fid));
        if isempty(line) || contains(line, 'gap')
            continue;
        end

        tokens = regexp(line, '(c\d+-\d+)\s+(\d+)', 'tokens');
        if ~isempty(tokens)
            names{end+1} = tokens{1}{1};
            values(end+1) = str2double(tokens{1}{2});
        end
    end

    fclose(fid);

    data.names = names;
    data.values = values;
end


