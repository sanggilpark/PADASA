# MATLAB FS14 – Research Plan
> * Group Name: PADASA
> * Group participants names: Kalinowski Pawel,Park Sanggil,Walser Dario
> * Project Title: Systemic risk in network model of financial shock speading.

## General Introduction
In the multiple bank system, systemic risk is the main concern for financial stability. Systemic risk could leverage failure of a single bank to a breakdown of banking system that affects the whole economy. Thus, it is crucial to examine the systemic risk nature. We will investigate the resilience of the banking systems upon the effect of systemic risk by observing the effect of financial shock directed to one bank on number of failing bank under varying values of key model parameters.
 
## The Model
To construct simplified model of the banking system we will employ the network theory where each node corresponds to a bank and each linkage between the nodes represents a directional lending relationship. Our model initiates a financial shock at one bank and transmits overflow that cannot be paid via links to the lending banks, potentially causing them to fail and spreading the shock recursively through the network. This model is called "knock-on defaults". Parameters of the model are: capitalization level, degree of connectivity, size of interbank susceptibility, and degree of the concentration. We will vary these four parameters and relate them with the number of defects, describing resilience of banking systems.

## Fundamental Questions
*	How much effect of changing one parameter dependent on values of other ones (fixed)?
*	How expected count of defaults can be expressed can be expressed or at least described as a function of model parameters?
*	How repeatable are the results for fixed parameters? (variation between realizations?)
*	Which model parameters can be influenced by regulators and what should they aim for?


## References 
Erlend Niera, Jing Yanga, Tanju Yorulmazera, Amadeo Alentorn, Network models and financial stability, Journal of Economic Dynamics & Control 31 (2007) 2033-2060

## Research Methods
Random-graph-based model (graph of debt structure is instantiated and spread of default is analyzed, multiple instances for same).
Our model type is fully described as "parameter constellation" - tuple of 5 numbers.
Authors fix their values to some example values and modify one at time. Some extension would be to try different starting points (that's candidate for methodology after implementation).
Most interesting parameter is Erdos probability p as it describes central point of interest – relationship (linkage) of banks, it's effect is non-monotonic and plot shape changes (Fundamental question could be related to "nature" of p and its effect on probability of default. Another question is how regulators can affect values of our parameters and if/how they should try to do it).


