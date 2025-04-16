function plot_gap_results()
    % File containing the results
    filename = 'gap_max_output.txt';

    % Open file
    fid = fopen(filename, 'r');
    if fid == -1
        error('Could not open file: %s', filename);
    end

    % Initialize storage
    datasets = {};
    values = {};
    currentDataset = '';
    currentValues = [];

    % Read file line by line
    while ~feof(fid)
        line = fgetl(fid);

        if startsWith(line, './gap')  % New dataset header
            if ~isempty(currentDataset)
                % Store previous dataset
                datasets{end+1} = currentDataset;
                values{end+1} = currentValues;
            end
            currentDataset = strrep(line, './gap dataset files/', '');
            currentValues = [];
        elseif startsWith(line, 'c')  % Data line
            parts = split(strtrim(line));
            val = str2double(parts{2});
            currentValues(end+1) = val;
        end
    end

    % Store last dataset
    if ~isempty(currentDataset)
        datasets{end+1} = currentDataset;
        values{end+1} = currentValues;
    end

    fclose(fid);

    % Plotting
    figure;
    hold on;
    colors = lines(numel(datasets));

    for k = 1:numel(datasets)
        plot(values{k}, 'LineWidth', 2, 'Color', colors(k, :));
    end

    legend(datasets, 'Interpreter', 'none', 'Location', 'best');
    xlabel('Problem Number');
    ylabel('Objective Value');
    title('Objective Values for GAP Datasets');
    grid on;
    hold off;

    % Save plot
    if ~exist('results', 'dir')
        mkdir('results');
    end
    saveas(gcf, fullfile('results', 'gap_results_plot.png'));
end
