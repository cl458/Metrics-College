dm 'log;clear;output;clear';
proc datasets lib=Work kill;quit;
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*"; 

libname mylib 'D:\Dropbox\Teaching\Metrics-College\Slides\ch05';

data andy;
	set mylib.andy;
run;

proc reg data=andy;
	model sales = price advert;
quit;
