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
    month = month(day);
    if month = 1 then month = "January";
    else if month = 2 then month = "February";
    else if month = 3 then month = "March";
    else if month = 4 then month = "April";
    else if month = 5 then month = "May";
    else if month = 6 then month = "June";
    else if month = 7 then month = "July";
    else if month = 8 then month = "August";
    else if month = 9 then month = "September";
    else if month = 10 then month = "October";
    else if month = 11 then month = "November";
    else if month = 12 then month = "December";
run;

proc print data = asos_data (obs=10);
run;