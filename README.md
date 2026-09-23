# STAT 172 Project 1
This is the codebase for my STAT 172 Project.

## Dataset
This dataset uses Meterorlogical Data collected from ASOS by Iowa State University from January 1st, 2021 to December 31st, 2025. The dataset has the following structure:
```csv
station,day,max_dewpoint_f,precip_in,avg_wind_speed_kts,max_rh
DSM,2021-01-01,19.4,0.0,6.6807046,92.62583
DSM,2021-01-02,16.0,0.0,2.3802588,91.52417
DSM,2021-01-03,27.0,0.0,6.35036,100.0
DSM,2021-01-04,30.0,0.0,8.531228,100.0
DSM,2021-01-05,27.0,0.0,4.4893775,100.0
```

The dataset uses the following dataset variables and descriptions of the dataset:
| Variable | Type | Description |
| -------- | ---- | ----------- |
| station | categorical | Notes the station for which the data was collected |
| day | date | The Date for which the data was collected in `YYYY-MM-DD` format |
| max_dewpoint_f | numerical | The Maximum Dew Point in Fareheight |
| precip_in | numerical | The daily total of preciptation recorded in inches |
| avg_wind_speed_kts | numerical | The Average Wind Speed recorded in Knots for the day |
| max_rh | numerical | The Maximum Relative Humidity recorded for the day |

### Binary Variable
The binary variable is going to be used for the prediction of `precip_in` and is defined as follows:

```math
y = \begin{cases} 1 & \text{if } precip\_in \geq 0.01 \\ 0 & \text{otherwise} \end{cases}
```

### Categorical Variable
The categorical variable being used is the month of the year, `month_name`, which is derived from the `day` variable.

## AI Usage & Disclosure
AI Usage is documented in the [AI Use Documentation](AI_use_documentation.md) file.\
Also, AI Disclosure is documented in `git commit` messages found in the `git log`s.