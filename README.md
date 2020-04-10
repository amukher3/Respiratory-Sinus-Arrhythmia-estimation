# Respiratory-Sinus-Arythmia-estimation(RSA)

The above repo. has the detailed scripts of the methodology adopted and the different evaluation metrics taken into account while estimating the arythmic component from R-R time series.  

Link to the used data-set: https://www.eecs.qmul.ac.uk/mmv/datasets/deap/

We started off with the goal to estimate the arythmic component from the raw BVP/PPG time series datat-sets.The first step was to extract a clean Interbeat interval(IBI)/R-R/Heart Rate(HR) time series from the data-set. It was proceeded by a MA removal algorithm previously adopted described literature. 

Previous research seemed to have taken a "baseline" approach while estimating the arythmic component from HR time series. The most general approach found was to directly filter the frequency component and thereby remove it from the time series. 

We decided to take a systemic approach of removing the RSA(Respiratory Sinus Arythmia) from the HR time series. RSA component being heavily affected by our repiration pattern tends to have an increasing effect(increase in tidal volume) during our inspiration and a slow reduction during our expiration. This nature of variation enabled us to form a knowledge-based dictionary which could capture the latent structure in the time series thereby estimating the component. 

The process and the experimental results with previously used metrics has been detailed in the technical report:
Link to the repo: https://github.com/amukher3/Respiratory-Sinus-Arythmia-estimation 

#For MA removal: https://www.researchgate.net/publication/317290211_Motion_Artifact_Reduction_from_PPG_Signals_During_Intense_Exercise_Using_Filtered_X-LMS
