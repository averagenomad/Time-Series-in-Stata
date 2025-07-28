# **ARMA Modeling of Civil Violence: Case Study of the Horn of Africa**  

![Language](https://img.shields.io/badge/language-Stata-blue.svg)
![Status](https://img.shields.io/badge/status-complete-blue.svg)
![License](https://img.shields.io/badge/license-academic-green.svg)

## **Overview**  
This repository contains the data, analysis scripts, and outputs for the project:  

**ARMA Modeling of Civil Violence: Case Study of the Horn of Africa**  
*Claremont Graduate University – Time Series Econometrics (ECON 384)*  

This project uses **ARMA time series modeling** to analyze violent events in **Somalia and Ethiopia**. The aim was to evaluate the extent to which parsimonious ARMA models can capture the path dependence and dynamics of civil violence in the Horn of Africa.  

### **Key Insights**  
- ARMA models can provide meaningful explanatory power even with limited data.  
- Somalia’s conflict data required an ARMA(2,0) model for best fit, while Ethiopia’s time series was best captured by ARMA(1,1).  
- The analysis highlights the challenges of modeling civil violence data, particularly when volatility and structural breaks exist.  

---

## **Repository Structure**  

```
├── data/
│ └── masterNl.csv
│
├── images/
│ └── <plots and diagnostic images>
│
├── notebooks/
│ └── FinalProject.do
│
└── output/
├── ECON384_Final_Paper-Zhamilia Klycheva.pdf
└── ECON_384_Final_Presentation_...
```

- **data/** – Monthly time series dataset of violent events from the Armed Conflict Location Event Data Project (ACLED).  
- **images/** – Visual outputs: time series plots, augmented Dickey-Fuller tests, decomposition, ACF/PACF plots, and residual diagnostics.  
- **notebooks/** – Stata `.do` file used for analysis and ARMA modeling.  
- **output/** – Final paper (PDF) and presentation slides.  

---

## **Data & Methodology**  
- Data covers violent events in Somalia and Ethiopia between 1997–2021.  
- Unit root tests (ADF), Hodrick-Prescott filtering, and ACF/PACF inspection were conducted prior to modeling.  
- Models were estimated in **Stata** using Maximum Likelihood Estimation.  

---

## **Notes**  
- This was a **school project** for a time series econometrics class and is provided for **academic reference only**.  
- The repository is marked as **complete** and will not be updated.  

---

## **License**  
This project is available for academic and educational purposes only.  



