dm 'log;clear;output;clear';
proc datasets lib=Work kill;quit;
OPTIONS FORMCHAR="|----|+|---+=|-/\<>*"; 

libname mylib 'D:\Dropbox\Teaching\Metrics-College\Slides\ch09';

/* Check for autocorrelations */

data okun;
	set mylib.okun;
run;

proc arima data=okun;
	identify var=g nlags=12 stationarity=(adf);
quit;

/* Phillips Curve */

data phillips_aus;
	set mylib.phillips_aus;
	DU = u-lag(u);
run;

proc reg data=phillips_aus;
	model inf = DU;
	output out=Phillips R=e;
quit;

proc arima data=phillips;
	identify var=e nlags=12 stationarity=(adf);
quit;

data phillips1;
	set phillips;
	le = lag(e);
run;

/* Lagrange Multiplier Test (LM Test) 1 */

proc reg data=phillips1;
	model inf = DU le;
quit;

/* Lagrange Multiplier Test (LM Test) 2 */

proc reg data=phillips1;
	model e = DU le;
quit;

/* HAC se */

proc autoreg data=phillips;
	model inf = du /covest=hac(kernel=bartlett, bandwidth=5);
quit;
