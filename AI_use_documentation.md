# AI Use Documentation for STAT 172 Project 1
This file details how Artificial Intelligence (AI) was used in this project.

## Finding A Dataset
ChatGPT Work (Chat) was used to help find a dataset for this project. The following prompt was used:
```text
I want you to help me choose a meteorological dataset for my class project. I want you to use publicly available datasets that can be accessed by users like me. I have attached the project description and rubric to help you with this.
```
And the following response was given:

```markdown
### Meteorological datasets that would work well for this project

Since the project requires a **binary response variable** and logistic regression, I would look for weather datasets where I can define a meaningful yes/no outcome while retaining several numerical and categorical explanatory variables. The project specifically encourages choosing a few numerical and categorical explanatory variables and allows creating the binary response variable during data cleaning.  This is important because the rubric also expects meaningful interpretations of both numerical and categorical variables, including custom odds ratios and confidence intervals. 

Here are several publicly available meteorological datasets I would consider:


1. IEM ASOS: Daily precipitation occurrence at Des Moines

My first choice would be the **Iowa Environmental Mesonet's ASOS archive**, using observations from **Des Moines International Airport (DSM)**. The IEM provides a public download interface for historical airport weather observations, including precipitation, temperature, dew point, wind, visibility, pressure, sky conditions, and present-weather information. 

[IEM ASOS historical weather download](https://mesonet.agron.iastate.edu/request/download.phtml?network=IA_ASOS&utm_source=chatgpt.com)

I would aggregate the observations to the **daily level** and create a binary response:

**Y = 1:** measurable precipitation occurred that day  
**Y = 0:** no measurable precipitation occurred that day

Possible explanatory variables could include daily temperature, dew point, relative humidity, wind speed, wind direction, visibility, cloud coverage, pressure, and season/month. The ASOS archive has data for some stations extending back to 2000, so a 5- or 10-year period would provide thousands of daily observations without requiring the entire archive. 

This dataset seems particularly well suited to the assignment because it requires genuine data cleaning: converting sub-daily observations into daily observations, handling missing values, constructing the binary precipitation variable, and potentially converting variables such as wind direction, cloud cover, or month into useful categorical predictors. That fits the project's expectation that the group perform meaningful data cleaning rather than simply downloading an analysis-ready dataset. 

It would also support interesting probability statements for the presentation, such as estimating the probability of precipitation under different humidity, temperature, pressure, or cloud-cover conditions. That fits especially well with the rubric's emphasis on using predicted probabilities to communicate additional insights from the logistic model. 

2. NOAA GHCN-Daily: Precipitation occurrence

Another option would be NOAA's **Global Historical Climatology Network Daily (GHCN-Daily)** dataset. NOAA allows users to search historical daily observations by station or location through Climate Data Online, and the underlying dataset is also publicly downloadable. 

[NOAA Climate Data Online — GHCN Daily](https://www.ncei.noaa.gov/cdo-web/search?datasetid=GHCND&utm_source=chatgpt.com)

The response could again be whether precipitation occurred on a particular day. Variables such as maximum temperature, minimum temperature, snowfall, snow depth, month, and season could then be considered as predictors.

This would probably require **less cleaning than ASOS**, because the observations are already daily. That makes it easier to work with, but it also provides fewer interesting atmospheric explanatory variables.

3. NOAA Storm Events: Property damage from severe weather

The **NOAA Storm Events Database** would allow a substantially different project. NOAA makes the underlying Storm Events tables available publicly as downloadable CSV files. 

[NOAA Storm Events bulk data](https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/?utm_source=chatgpt.com)

For example, I could restrict the dataset to Iowa severe-weather events and define:

**Y = 1:** event caused reported property damage  
**Y = 0:** event caused no reported property damage

Potential explanatory variables include event type, magnitude, month, location, event duration, and reporting source. NOAA's individual event records also contain fields for injuries, deaths, property damage, crop damage, location, magnitude, and narratives. 

This would produce a more impact-oriented project: rather than predicting whether weather occurs, the model would examine what characteristics are associated with damaging weather.

4. IEM/NWS COOP: Temperature extremes

The IEM also provides public access to daily **National Weather Service Cooperative Observer Program (COOP)** observations. These include daily high and low temperature, precipitation, snowfall, and snow depth. 

[IEM NWS COOP data](https://mesonet.agron.iastate.edu/COOP/?utm_source=chatgpt.com)

One possible binary response would be whether the daily high exceeded a meaningful threshold, such as 90°F. The model could then examine relationships with low temperature, precipitation, snowfall, month/season, and other available variables.

The advantage is simplicity and a very long historical record. The disadvantage is that the statistical question is somewhat less interesting than precipitation occurrence unless there is a compelling client or application for the temperature threshold.

### Best Candidate

I would choose the **IEM ASOS Des Moines precipitation dataset**. It gives the project a straightforward question:

> **What meteorological conditions are associated with the probability of measurable precipitation occurring at Des Moines International Airport on a given day?**

It provides a natural binary response, both numerical and categorical explanatory variables, plenty of observations, and enough raw data manipulation to satisfy the project's data-cleaning component. It also creates opportunities for odds ratios and predicted probabilities, which are major parts of the grading rubric.  

A plausible client could be an **event planner, airport operations manager, agricultural organization, or local outdoor recreation organization** interested in understanding the conditions associated with precipitation in central Iowa.
```


## SAS Code Usage

### Creating a Month Variable
