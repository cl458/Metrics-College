dm 'log;clear;output;clear';
proc datasets lib=Work kill;quit;
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*"; 

libname mylib 'D:\Dropbox\Teaching\Metrics-College\Slides\ch16';

data transport;
	set mylib.transport;
run;

proc logistic data=transport descending;
	model auto=dtime /link=probit;
quit;

proc logistic data=transport descending;
	model auto=dtime /link=logit;
quit;

