# Model Specification

# Fully specify model
Random Component:

Y1(SUBSCRIPT THIS) ~ Bernoulli(Pi i)(SUBSCRIPT THIS)
```math
Y_{i} \sim Bernoulli(\pi_{i})
```
Systematic Component:

log(pii/1-pii) = B0 + B1February + B2March + B3April + B4May + B5June + B6July + B7August + B8September + B9October + B10November + B11December + B12Dew + B13WindSpeed + B14MaxRH
```math
\log\left(\frac{\pi_{i}}{1-\pi_{i}}\right) = \beta_{0} + \beta_{1}Feb_i + \beta_{2}Mar_i + \beta_{3}Apr_i + \beta_{4}May_i + \beta_{5}Jun_i + \beta_{6}Jul_i + \beta_{7}Aug_i + \beta_{8}Sep_i + \beta_{9}Oct_i + \beta_{10}Nov_i + \beta_{11}Dec_i + \beta_{12}MaxDewPoint_i + \beta_{13}AvgWindSpeed_i + \beta_{14}MaxRH_i
```
