**** Final Paper ****
cd "/Users/jamilion/Documents/CGU/Spring 2021/ECON 384 Time Series/Metrics Final Project/"
// cd "/Volumes/|/Metrics Final Project"
import delimited "masterNI.csv"
tsmktim time, start(1997m1)
order time
drop event_date
drop v2
tsset time

***********************************************
**************** Somalia **********************
***********************************************
*Take a log of the original series
qui gen lnsomalia = log(somalia_event)
tsline lnsomalia
dfuller lnsomalia
corrgram lnsomalia

* Replace NA's by lag values to perform further transformations
replace lnsomalia = lnsomalia[_n-1] if missing(lnsomalia) 

*** Detrend TS using HP Filter
tsfilter hp hp_lnsomalia = lnsomalia
tsline hp_lnsomalia

qui gen trend = lnsomalia - hp_lnsomalia
twoway tsline hp_lnsomalia trend
corrgram hp_lnsomalia
ac hp_lnsomalia
pac hp_lnsomalia

*** Beveridge-Nelson Decomposition ***
// arima lnsomalia, arima(1,0,1)
// predict resid, residuals
// qui gen lresid = l.resid
// *detrending below
// *alpha from AR(1) = -.9619638, beta from MA(1) .9493442 
// qui gen detrend = (.9888153 -.4699974 )*resid + .4699974 *lresid
// tsline detrend
// *Log likelihood = -84.83252, AIC 177.665   192.1899
// arima detrend, arima(1,0,1)
// estat ic
// predict resdetrend, residuals
// corrgram resdetrend
// *not bad
// ac resdetrend
// *not so great for PAC
// pac resdetrend

**** Trend Removal via a Polynomial ****
qui gen t= _n
qui gen t2 = t^2
qui gen t3 = t^3
qui gen t4 = t^4
qui gen t5 = t^5
qui gen t6 = t^6
reg lnsomalia t t2
predict yhat, xb
qui gen remove = lnsomalia - yhat
// qui gen lnsomalia2 = lnsomalia^2
// qui gen lnsomalia3 = lnsomalia^3
// qui gen lnsomalia4 = lnsomalia^4
// qui gen lnsomalia5 = lnsomalia^5
// qui gen lnsomalia6 = lnsomalia^6
// qui gen lnsomalia7 = lnsomalia^7
// qui gen lnsomalia8 = lnsomalia^8
// qui gen lnsomalia9 = lnsomalia^9
// qui gen lnsomalia10 = lnsomalia^10

// reg lnsomalia 
// predict yhat0, xb
// twoway tsline lnsomalia 
// reg lnsomalia lnsomalia2 
// predict yhat2, xb
// reg lnsomalia lnsomalia2 lnsomalia3 lnsomalia4 lnsomalia5 lnsomalia6 lnsomalia7 lnsomalia8
// predict yhat, xb
// qui gen staSom = lnsomalia - yhat2


//////////////////////////////////////////////////////////
///////////////** ARMA Modeling ***//////////////////////
//////////////////////////////////////////////////////////

*Log likelihood = -243.7234 , AIC 495.4467  BIC   510.14
arima hp_lnsomalia, arima (1,0,1)
estat ic
predict hpARMA101, residuals
corrgram hpARMA101 
outreg2 using arma.tex, replace ctitle(1,1)
* still some structure remaining, they are not white
corrgram hpARMA101
*Q test for residuals
wntestq hpARMA101, lags(1)

// qui gen standARMA101res = hpARMA101/.5588579 
// qui gen standARMA101res2 = standARMA101res^2
// tsline  standARMA101res
// tsline  standARMA101res2
*Log likelihood = -245.2913, AIC 496.5827  BIC 507.6026
arima hp_lnsomalia, arima (1,0,0)
reg hp_lnsomalia l.hp_lnsomalia
predict hpARMA100, residuals
estat ic 
corrgram hpARMA100
outreg2 using arma.tex, append ctitle(1,0)

*Log likelihood = -243.3482, AIC 494.6965  BIC 509.3898
arima hp_lnsomalia, arima (2,0,0)
estat ic 
outreg2 using arma.tex, append ctitle(2,0)
predict hpARMA200, residuals
tsline hpARMA200
ac hpARMA200
pac hpARMA200
wntestq hpARMA200, lags(1)
* still some structure remaining, they are not white
corrgram hpARMA200
ac hpARMA200
pac hpARMA200
jb hpARMA200
return list

***********************************************
**************** Ethiopia *********************
***********************************************
dfuller ethiopia_event, lags(15)
qui gen lnethiopia = log(ethiopia_event)
qui gen dlnethiopia = d.lnethiopia
replace lnethiopia = lnethiopia[_n-1] if missing(lnethiopia) 

// ** ARIMA (3,1,3)
// corrgram dlnethiopia
// *about 3 periods are significantly different from 0
// ac dlnethiopia
// *about 3 periods are significantly different from 0 (1,2,4)
// pac dlnethiopia
// *Log likelihood = -354.3056, AIC  724.6112  BIC 753.9703
// arima lnethiopia, arima (3,1,3)
// estat ic


*** TREND REMOVING HP FILTER ***
tsfilter hp hp_lnethiopia = lnethiopia
tsline hp_lnethiopia 
ac hp_lnethiopia 
pac hp_lnethiopia 
qui gen trendE = lnethiopia - hp_lnethiopia
twoway tsline hp_lnethiopia trendE
** ARIMA (2,0,2)
*Log likelihood = -347.8155, AIC 707.6311    729.671
arima hp_lnethiopia, arima (2,0,2)
estat ic
outreg2 using ethiopia.tex, replace

** ARIMA (2,0,1)
*Log likelihood = -349.8129, AIC 709.6258   727.9924
arima hp_lnethiopia, arima (2,0,1)
estat ic

** ARIMA (1,0,2)
*Log likelihood = -349.4605, AIC 708.9211   727.2877
arima hp_lnethiopia, arima (1,0,2)
// estat ic

** ARIMA (1,0,0)
*Log likelihood = -351.5295 , AIC  709.0589   720.0789
arima hp_lnethiopia, arima (1,0,0)
estat ic
outreg2 using ethiopia.tex, append 

** ARIMA (2,0,0)
*Log likelihood = -350.8598, AIC   709.7196   724.4129
arima hp_lnethiopia, arima (2,0,0)
estat ic

** ARIMA (3,0,0) - L.2 is not significant
*Log likelihood = -349.6303  , AIC   709.2606   727.6272
arima hp_lnethiopia, arima (3,0,0)
estat ic

*ARIMA (0,0,3) 709.52   727.8866
arima hp_lnethiopia, arima (0,0,3) 
estat ic

///////// ARIMA (1,0,1) THE BEST SO FAR //////////////
*Log likelihood = -350.5332 ,aic 709.0664 bic  723.7597
arima hp_lnethiopia, arima (1,0,1)
// estat ic
predict hpethiopia111, residuals
outreg2 using ethiopia.tex, append 

* residuals are white
corrgram hpethiopia111
ac hpethiopia111
pac hpethiopia111
*fail to reject null, residuals are white
wntestq hpethiopia111, lags(1)

* r(skewness) =  -.2558058814691437, r(kurtosis) =  3.050032771823834
jb hpethiopia111
return list






*Log likelihood = -245.2913, AIC 496.5827  BIC 507.6026
arima hp_lnsomalia, arima (1,0,0)
estat ic 

*Log likelihood = -243.3482, AIC 494.6965  BIC 509.3898
arima hp_lnsomalia, arima (2,0,0)
estat ic 
predict hpARMA200, residuals










************************ SOMALIA ************************
**** Remove Trend by taking a first difference ****
qui gen dlnsomalia = d.lnsomalia
dfuller dlnsomalia, lags(20)
tsline dlnsomalia
corrgram dlnsomalia
*Log likelihood = -254.954, *AIC 517.908  BIC 532.5875,
arima lnsomalia, arima (1,1,1)
estat ic
predict hpARMA111, residuals
qui gen resid2 = hpARMA111^2
corrgram hpARMA111
tsline hpARMA111
wntestq hpARMA111, lags(1)
* r(skewness) =  -.7184296204165199, r(kurtosis) =  8.185535444461747
jb hpARMA111
return list
hist hpARMA111
*Log likelihood = -270.0064, 546.0128   557.0225
arima lnsomalia, arima (1,1,0)
estat ic
*Log likelihood = -267.3662, 542.7324   557.4119
arima lnsomalia, arima (2,1,0)
estat ic
*Log likelihood = -264.7924, 539.5847   557.9341
arima lnsomalia, arima (3,1,0)
estat ic


*** Test for Structural Break
reg lnsomalia l.lnsomalia l.l.lnsomalia
estat sbsingle


*** ARCH ***
*** Testing if ARCH/GARCH effects are present ***
*Log likelihood = -254.954, *AIC 517.908  BIC 532.5875,
arima lnsomalia, arima (1,1,1)
estat ic
predict hpARMA111, residuals
qui gen resid2 = hpARMA111^2
corrgram resid2
tsline resid2
*reject NUll, resid are not whtie
wntestq resid2, lags(1)

*Lagrange Multiplier test for GARCH/ARCH
reg resid2 l.resid2 l.l.resid2 l.l.l.resid2





***** ARCH/GARCH process modeling *****
arch lnsomalia, arch(2) garch(2)
estat ic
predict htarch2, variance
tsline htarch2

arch lnsomalia, arch(2) 
estat ic
predict htarch0, variance
tsline htarch0

** test for ARCH/GARCH
reg dlnsomalia l.dlnsomalia
predict Sresid, residuals
qui gen Sresid2 = Sresid^2
tsline Sresid2
corrgram Sresid2
ac Sresid2
pac Sresid2
jb Sresid2
return list
** reject the Null meaning we need to use ARCH/GARCH to model the mean and the variance
* if the coefficients were equal to zero, then the conditional variance is simply equal to constants
reg Sresid2 l.Sresid2 l.l.Sresid2 
arch dlnsomalia, arch(1) 
arch dlnsomalia, arch(1) dist(t)
predict Arch1resid, residuals
predict Arch1var, variance
*can clearly see multiple clusters
tsline Arch1var
jb Arch1resid
return list
hist Arch1resid


arch dlnsomalia, arch(3)
*Log likelihood = -286.6009 AIC 579.2019 BIC 590.2115
estat ic
*Log likelihood = -4129.161 - based on the log likelihood, parsimonious GARCH performs better
arch ldj, arch(1) garch(1)
*AIC 8266.322  BIC 8293.151
estat ic
predict somarch3, variance
tsline somarch3

predict Rsomarch3, residuals
tsline Rsomarch3





***********************************************
**************** Nigeria *********************
***********************************************
dfuller nigeria_event, lags(15)
qui gen lnigeria = log(nigeria_event)
qui gen dlnigeria = d.lnigeria
// replace lnigeria = lnigeria[_n-1] if missing(lnigeria) 
tsline dlnigeria
corrgram dlnigeria
*about 3 periods are significantly different from 0
ac dlnigeria
*about 3 periods are significantly different from 0 (1,2,4)
pac dlnigeria
*not white noise??
wntestq hp_lnigeria, lags(1)

*Log likelihood = -354.3056, AIC  724.6112  BIC 753.9703
arima lnigeria, arima (3,1,3)
estat ic


*** TREND REMOVING HP FILTER ***
tsfilter hp hp_lnigeria = lnigeria
tsline hp_lnigeria 
ac hp_lnigeria
pac hp_lnigeria 
qui gen trendN = lnigeria - hp_lnigeria
twoway tsline hp_lnigeria trendN
** ARIMA (2,1,2)
*Log likelihood = -357.8117, AIC 727.6234 BIC  749.6427
arima lnethiopia, arima (2,1,2)
estat ic
















*2 MA lags
ac dsomalia   
*2 AR
pac dsomalia
arima dsomalia, arima(2,0,2)
*2743.348   2765.388
estat ic
arima dsomalia, arima(2,0,1)
*2741.534   2759.9
estat ic
** both significant
arima dsomalia, arima(1,0,1)
*2746.666   2761.359
estat ic
predict resid11, residuals
tsline resid11
* there is still remaining structure in the residuals, they are not white
corrgram resid11
arima dsomalia, arima(1,0,0)
*2787.508   2798.528
estat ic
arima dsomalia, arima(2,0,0)
*2754.471   2769.164
estat ic

*** ARCH ***
** test for ARCH/GARCH
reg dsomalia
predict Sresid, residuals
qui gen Sresid2 = Sresid^2
tsline Sresid2
corrgram Sresid2
ac Sresid2
pac Sresid2
jb Sresid2
return list

** reject the Null meaning we need to use ARCH/GARCH to model the mean and the variance
* if the coefficients were equal to zero, then the conditional variance is simply equal to constants
reg Sresid2 l.l.Sresid2  

arch dsomalia, arch(1) 


arch dsomalia, arch(1) garch(1)
predict var1, variance
dfuller var1
predict v, residuals
corrgram v
* clear presence of serial correlation
corrgram var1









































/////////////////////////////// OLD STUFF
******************Ethiopia ********************

** Box-Jenkins Approach ** 
corrgram ethiopia_event
hist resid
ac ethiopia_event
pac ethiopia_event

arima ethiopia_event, arima (2,0,0)
predict resid, residuals
tsline resid

** test for ARCH/GARCH
reg ethiopia_event
predict Eresid, residuals
qui gen Eresid2 = Eresid^2
tsline Eresid2
corrgram Eresid2
** reject the Null meaning we need to use ARCH/GARCH to model the mean and the variance
reg Eresid2 l.Eresid2 l.l.Eresid2 l.l.l.Eresid2

** 
arch ethiopia_event, arch(2)
predict htarch, variance

arch ethiopia_event, arch(1) garch(1)
* 2372.585   2387.292
estat ic

arch ethiopia_event, arch(1) garch(1) dist(t)
*AIC 7237.978   BIC 7271.513
estat ic


** Question 10 **
arch ethiopia_event, arch(1) 
*  2376.486   2387.516
estat ic
arch ethiopia_event, arch(2)
*  2500.417   2511.447 
estat ic
arch ethiopia_event, arch(3)
*  2539.467   2550.497
estat ic
arch ethiopia_event, arch(4)
*  2565.491   2576.522
estat ic

*GARCH
arch ethiopia_event, arch(1) garch (1)
* 2372.585   2387.292
estat ic
*** BEST PERFORMING MODEL, Log L= -1169.059 ***
***********************************************
arch ethiopia_event, arch(1) garch (2)
*2346.118   2360.825
estat ic
predict G2resid, residuals
tsline G2resid
predict G2var, variance
tsline G2var
.

+710*** Log L = -1194.032 
arch ethiopia_event, arch(1) garch (3)
*2396.065   2410.772
estat ic
* Log L =  -1242.964 
arch ethiopia_event, arch(2) garch (2)
*2493.929   2508.636
estat ic












**OUTREG format
forvalues j=0/6 {
       reg sales l(0/`j')adv if t>6
       estat ic
       matrix ics=r(S)
       local aic = ics[1,5]
       local bic = ics[1,6]
       predict ehat , resid
       corrgram ehat
       outreg2 using dp_24_ar0_out , word addstat( AIC, `aic' , BIC, `bic' , ///
}




