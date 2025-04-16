# GAP Solver and Visualization

This project processes and solves a series of Generalized Assignment Problem (GAP) instances using integer linear programming, and visualizes the optimal objective values across datasets.

---

## 📁 Folder Structure

```
.
├── gap dataset files/         # Folder containing 12 input files: gap1.txt to gap12.txt
├── spp_using_intlinprog.m     # MATLAB script to solve GAP instances
├── plot_optimal_results.m     # MATLAB script to visualize results
├── gap_max_output.txt         # Output file with objective values for each dataset
└── results/                   # Auto-created folder for the final plot image
```

---

## 🧮 Files Description

### `spp_using_intlinprog.m`
- Solves GAP instances from `gap dataset files/gap1.txt` to `gap12.txt`.
- For each file, it:
  - Reads multiple problem instances.
  - Solves each using `intlinprog` (integer linear programming).
  - Saves objective values into `gap_max_output.txt`.

### `gap_max_output.txt`
- Contains output results from `spp_using_intlinprog.m`.
- Each section starts with a dataset name (e.g., `gap1`) and lists objective values for all its problem instances.

### `plot_optimal_results.m`
- Reads and parses `gap_max_output.txt`.
- Plots objective values across problem instances for each dataset.
- Saves the plot as `gap_results_plot.png` inside a `results` directory.

---

## 📂 Dataset Format

Each `gapX.txt` file in `gap dataset files/` includes:
- Number of problems.
- For each problem:
  - Number of servers `m`
  - Number of users `n`
  - Cost matrix (n × m)
  - Resource matrix (n × m)
  - Server capacities (length m)

---

## ✅ How to Run

1. Ensure all `.txt` files and scripts are in the same directory structure.
2. Open MATLAB.
3. Run:
   ```matlab
   solve_large_gap();         % From spp_using_intlinprog.m
   plot_gap_results();        % From plot_optimal_results.m
   ```
4. Check:
   - `gap_max_output.txt` for numerical results
   - `results/gap_results_plot.png` for the visualization

---

## 📊 Output Example

Example entry from `gap_max_output.txt`:
```
./gap dataset files/gap1
c515-1  336
c515-2  327
...
```

---

## 🔧 Requirements

- MATLAB with Optimization Toolbox (for `intlinprog`)

Author Name: Abhishek patel

GITHUB Link: https://github.com/Abhisheh-patel/Ec-Assignment
