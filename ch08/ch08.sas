dm 'log;clear;output;clear';
proc datasets lib=Work kill;quit;
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*"; 

libname mylib 'D:\Dropbox\Teaching\Metrics-College\Slides\ch08';

data food;
	set mylib.food;
run;

proc reg data=food;
	model food_exp = income;
	output out=Regout R=Resid;
quit;

data Regout;
	set Regout;
	e2 = Resid**2;
	income2 = income**2;
run;

/* LaGrange Multiplier Test */
proc reg data=Regout;
	model e2 = income;
quit;

/* White Test */
proc reg data=Regout;
	model e2 = income income2;
quit;

/* 8.2.3 The Goldfeld-Quandt Test */
data cps2;
	set mylib.cps2;
run;

proc reg data=cps2;
	model wage = educ exper metro;
quit;

proc reg data=cps2;
	where metro=1;
	model wage = educ exper;
quit;

proc reg data=cps2;
	where metro=0;
	model wage = educ exper;
quit;

/* 8.2.3 The Goldfeld-Quandt Text with Food expenditure regression */
proc sort data=food;
	by income;
run;

proc rank data=food out=food_rank group=2;
	var income;
	ranks Inc_Group;
run;

proc reg data=food_rank;
	by Inc_Group;
	model food_exp = income;
quit;

/* SAS's version of heteroskedasticity-consistent standard errors */
proc reg data=food;
	model food_exp = income /acov;
quit;

/* White Standard Errors */
proc surveyreg data=food;
	model food_exp = income;
quit;

/* 8.4.1c GLS for Food Expenditure Estimates - Variance is known */

data food2;
	set food;
	ystar = food_exp/sqrt(income);
	x1star = 1/sqrt(income);
	x2star = sqrt(income);
run;

proc reg data=food2;
	model ystar = x1star x2star /noint;
quit;

/* 8.5 GLS for Food Expenditure Estimates - Unknown Form of Variance */

proc reg data=food;
	model food_exp = income;
	output out=Regout2 R=Resid;
quit;

data Regout2;
	set Regout2;
	logResid2 =log(Resid**2);
	z = log(income);
run;

proc reg data=Regout2;
	model logResid2 = z;
	output out=GLS_est P=yhat;
quit;

data GLS_est;
	set GLS_est;
	sig = sqrt(exp(yhat));
	ystar = food_exp/sig;
	x1star = 1/sig;
	x2star = income/sig;
run;

proc reg data=GLS_est;
	model ystar = x1star x2star /noint;
quit;
