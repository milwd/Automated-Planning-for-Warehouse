# Hybrid Planning with ENHSP and PDDL+

This project explores hybrid planning using **PDDL+** and the **ENHSP** planner. The objective is to model and solve a series of logistics-like problems where both discrete actions and continuous numeric effects (like weight, time, and position) must be managed to reach a goal efficiently.

## What is Hybrid Planning?

Hybrid planning combines classical planning with continuous dynamics. It allows the planner to handle realistic systems where actions not only change symbolic states but also affect numeric variables over time. Examples include robotic manipulation, motion planning, energy consumption, and task scheduling with temporal constraints.

## About PDDL+

PDDL+ is an extension of the Planning Domain Definition Language. It allows modeling:
- **Durative actions** (actions that take time)
- **Processes** (ongoing effects depending on conditions)
- **Events** (instantaneous reactions to conditions)
- **Numeric fluents** (such as battery level, position, velocity)

This makes PDDL+ ideal for modeling hybrid domains where both discrete decisions and continuous changes matter.

## About ENHSP

[ENHSP](https://github.com/aig-upf/enhsp) (Extended Numeric Heuristic Search Planner) is a heuristic-based planner that supports PDDL+ domains. It simulates continuous effects using time discretization and allows tuning of simulation parameters for precision and performance.

The planner interprets both symbolic and numeric transitions and provides support for hybrid models, making it well-suited for continuous planning problems.

## Project Structure

Generated plans are available in the `plans/` directory. The project structure is as follows:

```
├── Assignment.pdf             # Project description
├── drafts/                   # Previous PDDL drafts and partial versions
│   └── ... .pddl
├── enhsp-19.jar              # ENHSP planner
├── lib/                      # Required JAR dependencies for ENHSP
│   └── ... .jar
├── maindomain.pddl           # Main PDDL+ domain file
├── problem0.pddl             # Problem instance 0
├── problem1.pddl             # Problem instance 1
├── problem2.pddl             # Problem instance 2
├── problem3.pddl             # Problem instance 3
├── problem4.pddl             # Problem instance 4
├── plans/                    # Output plan files generated for each problem
│   └── ... .txt
```

## How to Run

Use the following command to run the planner:

```bash
java -jar enhsp-19.jar -o maindomain.pddl -f problemX.pddl
```

Replace `problemX.pddl` with the desired problem file (e.g., `problem0.pddl`).

To control the simulation time granularity, add the `-delta` flag:

```bash
java -jar enhsp-19.jar -o maindomain.pddl -f problem0.pddl -delta 0.1
```

The `-delta` parameter sets the simulation step size. Smaller values increase precision but also computation time.

## Notes

- All generated plans are saved in the `plans/` directory.
- The domain includes hybrid actions involving time-dependent loading, motion affected by crate weight, and task grouping.
- Each problem represents a scenario with different crate positions, weights, and group assignments, to test the robustness of the model and planner.
