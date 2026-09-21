# Model Specification

## Random Component:

```math
Y_{i} \sim Bernoulli(\pi_{i})
```
## Systematic Component:

```math
\log\left(\frac{\pi_{i}}{1-\pi_{i}}\right) = \beta_{0} + \beta_{1}Spring_i + \beta_{2}Summer_i + \beta_{3}Fall_i + \beta_{4}MaxDewPoint_i + \beta_{4}AvgWindSpeed_i + \beta_{6}MaxRH_i
```

## Incorrect Model:

```math
\pi_{i} = \beta_{0} + \beta_{1}Spring_i + \beta_{2}Summer_i + \beta_{3}Fall_i + \beta_{4}MaxDewPoint_i + \beta_{4}AvgWindSpeed_i + \beta_{6}MaxRH_i
```
Issue: This model could have a value of $\pi_{i}$ that is less than 0 or greater than 1, which is not valid for a probability. The correct model uses the logit link function to ensure that the predicted probabilities are constrained between 0 and 1.