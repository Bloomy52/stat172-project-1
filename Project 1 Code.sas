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

proc print data = asos_data (obs=10);
run;

proc contents data=asos_data;
run;

data asos_data;
    set asos_data;
    length month_name $9;
    month_name = strip(put(day, monname.));
run;

proc print data = asos_data (obs=10);
run;

proc freq data = asos_data;
tables precip_bin*month_name; /* gives you proportions between the two variables */
run;

/* No compete separation of the data between the month and whether
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
    class month_name / param=reference;
    model precip_bin(event='1') = month_name max_dewpoint_f avg_wind_speed_kts max_rh / clparm=both;
    output out=diags predicted=pred xbeta=linpred;
run;