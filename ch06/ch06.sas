dm 'log;clear;output;clear';
proc datasets lib=Work kill;quit;
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*"; 

libname mylib 'D:\Dropbox\Teaching\Metrics-College\Slides\ch06';

data andy;
	set mylib.andy;
	advert2 = advert**2;
run;

proc reg data=andy;
	model sales = price advert advert2;
quit;

proc reg data=andy;
	model sales = price;
quit;

proc reg data=andy;
	model sales = advert advert2;
quit;

data edu_inc;
	set mylib.edu_inc;
run;

proc reg data=edu_inc;
	model faminc = hedu wedu;
quit;

proc reg data=edu_inc;
	model faminc = hedu;
quit;

proc reg data=edu_inc;
	model faminc = hedu wedu kl6;
quit;

proc reg data=edu_inc;
	model faminc = hedu wedu kl6 x5 x6;
quit;

proc corr data=edu_inc;
	var faminc hedu wedu kl6 x5 x6;
run;

proc reg data=mylib.cars;
	model mpg=cyl;
	model mpg=cyl eng wgt;
quit;

proc reg data=mylib.cars;
	model mpg=cyl eng wgt /vif;
quit;

proc reg data=mylib.cars;
	model cyl= eng wgt;
	model eng= cyl wgt;
	model wgt= cyl eng;
quit;
