# GAP Optimization and Approximation Comparison

This project provides both exact and heuristic solutions to the Generalized Assignment Problem (GAP) using MATLAB. It includes tools to solve, evaluate, and visualize performance across 12 standard datasets.

---

## 📁 Folder Structure

```
.
├── gap dataset files/             # Folder containing 12 input files: gap1.txt to gap12.txt
├── gap_max_output.txt             # Output file with objective values using integer linear programming
├── gap_greedy_output.txt          # Output file with objective values using greedy approximation
├── spp_using_intlinprog.m         # Solves GAP instances using MATLAB's intlinprog (optimal)
├── GAP_approximation.m            # Solves GAP instances using a greedy approximation algorithm
├── plot_optimal_results.m         # Plots only optimal results from gap_max_output.txt
├── optimal_approximation_comp.m   # Compares GAP12 results from both methods in a bar chart
└── results/                       # Directory where all plots are saved
```

---

## 🧮 MATLAB Scripts

### `spp_using_intlinprog.m`
- Iterates over GAP datasets (gap1.txt to gap12.txt).
- Solves each problem using integer linear programming via `intlinprog`.
- Results are written to `gap_max_output.txt`.

### `GAP_approximation.m`
- Implements a greedy approximation algorithm for solving the same GAP datasets.
- Results are written to `gap_greedy_output.txt`.

### `plot_optimal_results.m`
- Parses `gap_max_output.txt` and creates a multi-line plot of objective values for each GAP dataset.
- Saves the figure to `results/gap_results_plot.png`.

### `optimal_approximation_comp.m`
- Reads both `gap_max_output.txt` and `gap_greedy_output.txt`.
- Filters entries for `gap12` only.
- Creates and saves a **bar graph** comparing optimal and greedy objective values for GAP12.
- Output: `results/gap12_bar_comparison.png`

---

## 📂 GAP Dataset Format

Each GAP file (`gapX.txt`) contains:
- Number of problem instances
- For each instance:
  - Number of servers (m)
  - Number of users (n)
  - Cost matrix `c (n × m)`
  - Resource matrix `r (n × m)`
  - Server capacity vector `b (m × 1)`

---

## ▶️ How to Run

1. Open MATLAB and navigate to this folder.
2. Make sure all `.m` files and `gap dataset files/` are in the same working directory.
3. Run the following in order:
   ```matlab
   solve_large_gap();             % Executes optimal solution (intlinprog)
   run GAP_approximation;         % Executes greedy approximation
   plot_gap_results();            % Visualizes optimal-only results
   draw_gap12_bar_graph();        % Compares GAP12 (optimal vs greedy) in a bar chart
   ```

---

## 🛠 Requirements

- MATLAB (R2016b or later recommended)
- Optimization Toolbox (for `intlinprog`)

---

## 📊 Sample Output

Bar chart generated for `gap12` dataset:
```
results/gap12_bar_comparison.png
```

Multi-line plot of optimal solutions:
```
results/gap_results_plot.png
```

---

## 📌 Notes

- You can modify the `draw_gap12_bar_graph()` logic to compare other datasets (e.g., `gap1`, `gap5`, etc.).
- All output is saved to the `results/` directory automatically.


Author Name: Abhishek patel

GITHUB Link: https://github.com/Abhisheh-patel/Ec-Assignment/tree/main/Assignment-2
