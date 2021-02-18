dm 'log;clear;output;clear';
proc datasets lib=Work kill;quit;
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*"; 

libname mylib 'D:\Dropbox\Teaching\Metrics-College\Slides\ch02';

data food;
	set mylib.food;
	income1 = income*100;
run;

proc reg data=food;
	model food_exp = income1;
quit;
