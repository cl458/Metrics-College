dm 'log;clear;output;clear';
proc datasets lib=Work kill;quit;
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*"; 

libname mylib 'D:\Dropbox\Teaching\Metrics-College\Slides\ch15';

/* Pooled Regression */
data nls_panel;
	set mylib.nls_panel;
run;

/* Pooled regression with nonrobust OLS estimators */
proc reg data=nls_panel;
	model lwage = educ exper exper2 tenure tenure2 black south union;
quit;

/* cluster-robust standard errors */
proc surveyreg data=nls_panel;
	cluster id;
	model lwage = educ exper exper2 tenure tenure2 black south union;
quit;

/* 15.3.1 Least Square Dummy Variable Estimator for Small N */
data nls_panel10;
	set mylib.nls_panel10;
	_Y=0;
run;

proc glmselect data=nls_panel10 NOPRINT outdesign(addinputvars)=nls_panel10_new(drop=_Y);
   class id;   /* list the categorical variables here */
   model _Y = id /  noint selection=none;
run;

data nls_panel10_new;
	set nls_panel10_new;
	drop id;
run;

proc reg data=nls_panel10_new;
	model lwage = ID: exper exper2 tenure tenure2 union /noint;
quit;

proc reg data=nls_panel10;
	model lwage = exper exper2 tenure tenure2 union;
quit;

/* Fixed Effects Model */
proc panel data=nls_panel10;
	id id year;
	model lwage = exper exper2 tenure tenure2 union /FIXONE;
quit;


/* Random Effects Model */

proc panel data=nls_panel10;
	id id year;
	model lwage = exper exper2 tenure tenure2 union /RANONE;
quit;

/* Explanatory Variables that don't change over time */

proc panel data=nls_panel10;
	id id year;
	model lwage = exper exper2 tenure tenure2 black union /FIXONE;
	output out=RANONE R=Resid;
quit;

proc panel data=nls_panel10;
	id id year;
	model lwage = exper exper2 tenure tenure2 black union /RANONE;
	output out=RANONE R=Resid;
quit;
