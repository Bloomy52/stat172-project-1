/* Project 1 Code */
/* STAT 172 */
/* This project uses the `dsm-asos-data.csv` dataset. */
/* Dataset Description can be found in README.md file. */

proc import out = asos_data
datafile = "/export/viya/homes/louie.bloomberg@drake.edu/Uploaded Files/dsm-asos-data.csv"
dbms = csv replace;
guessingrows = max;
run;

/*Turn precip_in into a binary variable*/
data asos_data;
set asos_data;
precip_bin = precip_in;
if precip_in >= 0.01 then precip_bin = 1;
	else precip_bin = 0;
run;

/* Testing Code
proc print data = asos_data (obs=10);
run;

proc contents data=asos_data;
run;
*/

data asos_data;
    set asos_data;
    length month_name $9;
    month_name = strip(put(day, monname.));
run;

/* create a season variable
Winter: Dec, Jan, Feb
Spring: Mar, Apr, May
Summer: Jun, Jul, Aug
Autumn: Sep, Oct, Nov*/
data asos_data;
    set asos_data;
    length season $6;
    if month_name in ('December', 'January', 'February') then season = 'Winter';
    else if month_name in ('March', 'April', 'May') then season = 'Spring';
    else if month_name in ('June', 'July', 'August') then season = 'Summer';
    else if month_name in ('September', 'October', 'November') then season = 'Autumn';
run;

/* Testing Code
proc print data = asos_data (obs=10);
run;
*/

/* Descriptive statistics for each season */
proc means data=asos_data
    n mean std min q1 median q3 max maxdec=4;
    class season;
    where precip_bin = 1;
    var max_dewpoint_f precip_in avg_wind_speed_kts max_rh;
run;


/* PREDICTOR VARIABLE COMPLETE SEPARATION CHECKER */

proc freq data = asos_data order=data;
    tables precip_bin*season; 
run;

/* No compete separation of the data between the season and whether
   there was at least 0.01 inches of precipitation measured.
*/

proc sgplot data = asos_data;
    scatter x=max_dewpoint_f y=precip_bin;
    xaxis label="Max Dewpoint (F)";
    yaxis label="Precipitation Binary (0 = No, 1 = Yes)";
run;

/* No complete separation of the data between the max dewpoint and whether
   there was at least 0.01 inches of precipitation measured.
*/

proc sgplot data = asos_data;
    scatter x=avg_wind_speed_kts y=precip_bin;
    xaxis label="Average Wind Speed (kts)";
    yaxis label="Precipitation Binary (0 = No, 1 = Yes)";
run;

/* No complete separation of the data between the average wind speed and whether
   there was at least 0.01 inches of precipitation measured.
*/

proc sgplot data= asos_data;
    scatter x=max_rh y=precip_bin;
    xaxis label="Maximum Relative Humidity (%)";
    yaxis label="Precipitation Binary (0 = No, 1 = Yes)";
run;

/* No complete separation of the data between the maximum relative humidity and whether
   there was at least 0.01 inches of precipitation measured.
*/

/* LOGISTIC REGRESSION MODELS */

proc logistic data = asos_data;
    class season(ref='Winter') / param=reference order=data;
    model precip_bin(event='1') = season max_dewpoint_f avg_wind_speed_kts max_rh / clparm=both;
    output out=diags predicted=pred xbeta=linpred;
run;


/* Analysis of Maximum Likelihood Estimates
Parameter	 	    DF	Estimate	StandardError	WaldChi-Square	Pr > ChiSq
Intercept	 	    1	-17.0120	0.93263         32.7376	        <.0001
season	Spring	    1	0.7284	    0.2184	        11.1230	        0.0009
season	Summer	    1	0.0291	    0.2999	        0.0094	        0.9227
season	Autumn	    1	-0.1815	    0.2340	        0.6014	        0.4381
max_dewpoint_f	 	1	0.0129	    0.00617	        4.3361	        0.0373
avg_wind_speed_kts	1	0.1840	    0.0217	        71.5933	        <.0001
max_rh	 	        1	0.1568	    0.00972	        260.2939	    <.0001
*/

/* All Standard Errors are below 5 which means no complete separation */
/* Interpretations: USE HUMAN LANGUAGE! */
/*
 * Intercept has a point estimate of -17.0120
 * `Spring` has a point estimate of 0.7284
 * `Summer` has a point estimate of 0.0291
 * `Autumn` has a point estimate of -0.1815
 * `max_dewpoint_f` has a point estimate of 0.0129
 * `avg_wind_speed_kts` has a point estimate of 0.1840
 * `max_rh` has a point estimate of 0.1568
*/

/* Odds Ratios & Wald Confidence Intervals */
/*  
    season Spring vs Winter	2.072	1.350	3.179
    season Summer vs Winter	1.030	0.572	1.853
    season Autumn vs Winter	0.834	0.527	1.319
    max_dewpoint_f	        1.013	1.001	1.025
    avg_wind_speed_kts	    1.202	1.152	1.254
    max_rh	                1.170	1.148	1.192
*/ 

/* Parameter Estimates and Profile-Likelihood Confidence Intervals
Parameter	 	    Estimate	95% Confidence Limits
Intercept	 	    -17.0120	-18.8900	-15.2324
season	Spring	     0.7284	     0.3015	     1.1582
season	Summer	     0.0291	    -0.5593	     0.6171
season	Autumn	    -0.1815	    -0.6423	     0.2757
max_dewpoint_f	     0.0129	     0.000817	 0.0250
avg_wind_speed_kts	 0.1840	     0.1418	     0.2271
max_rh	 	         0.1568	     0.1382	     0.1763
*/
