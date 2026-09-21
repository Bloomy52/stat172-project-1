# Model Specification

# Fully specify model
Random Component:

```math
Y_{i} \sim Bernoulli(\pi_{i})
```
Systematic Component:

```math
\log\left(\frac{\pi_{i}}{1-\pi_{i}}\right) = \beta_{0} + \beta_{1}Feb_i + \beta_{2}Mar_i + \beta_{3}Apr_i + \beta_{4}May_i + \beta_{5}Jun_i + \beta_{6}Jul_i + \beta_{7}Aug_i + \beta_{8}Sep_i + \beta_{9}Oct_i + \beta_{10}Nov_i + \beta_{11}Dec_i + \beta_{12}MaxDewPoint_i + \beta_{13}AvgWindSpeed_i + \beta_{14}MaxRH_i
```
