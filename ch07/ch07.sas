dm 'log;clear;output;clear';
proc datasets lib=Work kill;quit;
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*"; 

libname mylib 'D:\Dropbox\Teaching\Metrics-College\Slides\ch07';

/* Housing Price Problem */
data utown;
	set mylib.utown;
	sqft_utown = sqft*utown;
run;

proc reg data=utown;
	model price = sqft;
	model price = utown sqft;
quit;

proc reg data=utown;
	model price = sqft sqft_utown;
quit;

proc reg data=utown;
	model price = utown sqft sqft_utown;
quit;

proc reg data=utown;
	model price = utown sqft sqft_utown age pool fplace;
quit;

/* Wage Problem concerning Gender, Race, Location */

data cps4_small;
	set mylib.cps4_small;
	black_female = black*female;
	educ_south = educ*south;
	black_south = black*south;
	female_south = female*south;
	black_female_south = black*female*south;
run;

proc reg data=cps4_small;
	model wage = educ black female black_female;
quit;

proc reg data=cps4_small;
	model wage = educ south midwest west;
quit;

proc reg data=cps4_small;
	model wage = educ black female black_female south midwest west;
quit;

proc reg data=cps4_small;
	model wage = educ black female black_female south educ_south black_south female_south black_female_south;
quit;

proc reg data=cps4_small;
	where south=0;
	model wage = educ black female black_female;
quit;

proc reg data=cps4_small;
	where south=1;
	model wage = educ black female black_female;
quit;

proc reg data=cps4_small;
	model wage = educ black female black_female;
quit;
