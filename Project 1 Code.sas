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