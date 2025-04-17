# Service Placement Problem (SPP) - Optimization & Heuristic Comparison

This project provides both exact and heuristic solutions to the **Service Placement Problem (SPP)** using MATLAB. It includes scripts to solve SPP using Genetic Algorithm (GA) and Integer Linear Programming (`intlinprog`), along with convergence and performance comparison plots.

---

## 📁 Folder Structure

```
.
├── sphere_bcga_min_convergence.png       # GA convergence graph for the last run
├── spp_using_bga.m                       # Solves SPP using Binary-coded Genetic Algorithm (BGA)
├── spp_using_intlinprog.m               # Solves SPP using MATLAB's intlinprog (exact)
├── sphere_function_for_bcga.m           # Benchmark Sphere function (example for GA)
├── bga_optimal_approximation_comparison.m # Compares GA vs Optimal/Approximation on SPP
└── results/                              # (Recommended) Directory to store all output plots and logs
```

---

## 🧮 MATLAB Scripts

### `spp_using_bga.m`
- Solves the SPP using a Binary-coded Genetic Algorithm.
- Includes convergence tracking.
- Output graph saved as `sphere_bcga_min_convergence.png`.

### `spp_using_intlinprog.m`
- Solves the SPP using MATLAB's integer linear programming (`intlinprog`) function.
- Useful for small or mid-sized instances to find the exact solution.

### `sphere_function_for_bcga.m`
- Contains a benchmark optimization function (Sphere function).
- Can be used to test and validate the GA logic.

### `bga_optimal_approximation_comparison.m`
- Loads outputs from BGA and optimal/approximation approaches.
- Compares and visualizes their performance using bar or line charts.
- Helps evaluate the effectiveness of BGA vs traditional methods.

---

## 📂 Input Format

The SPP formulation is generally defined as:
- A set of services to be placed on servers or nodes.
- Each placement has a cost and resource requirement.
- Servers have capacity limits.

**NOTE**: This implementation assumes the data is defined directly in the `.m` files or hardcoded. Modify input matrices as needed for custom scenarios.

---

## ▶️ How to Run

1. Open MATLAB and set the working directory to this folder.
2. Run one of the solution scripts:
   ```matlab
   spp_using_bga          % For heuristic GA solution
   spp_using_intlinprog   % For exact ILP-based solution
   bga_optimal_approximation_comparison  % To visualize performance comparison
   ```
3. The GA script will produce a convergence graph automatically.

---

## 🛠 Requirements

- MATLAB (R2016b or later recommended)
- Optimization Toolbox (for `intlinprog`)

---

## 📊 Sample Output

- GA Convergence Graph:
  ```
  sphere_bcga_min_convergence.png
  ```

- GA vs Optimal Comparison:
  ```
  results/spp_comparison_plot.png (or custom path)
  ```

---

## 📌 Notes

- The BGA method is suitable for larger or complex SPPs where exact solutions are computationally expensive.
- You can use the benchmark sphere function as a testbed for GA tuning.

Author Name: Abhishek Patel
GitHub:https://github.com/Abhisheh-patel/Ec-Assignment/tree/main/Assignment-3
