// For use with Matlab
// Copyright (C) 2019 -- Jerome Mendes <jermendes@gmail.com> or <jermendes@isr.uc.pt>, Rui Araujo <rui@isr.uc.pt>
// Jerome Mendes, Francisco A. A. Souza, Ricardo Maia, and Rui Araujo. "Iterative learning of multiple univariate zero-order t-s fuzzy systems". IEEE 45th Annual Conference of the Industrial Electronics Society (IECON 2019), 2019.
// The "iMU-ZOTS toolbox" comes with ABSOLUTELY NO WARRANTY;
// In case of publication of any application of this method, please, cite the work:
// Jerome Mendes, Francisco A. A. Souza, Ricardo Maia, and Rui Araujo.
// Iterative learning of multiple univariate zero-order t-s fuzzy systems.
// In Proc. of the The IEEE 45th Annual Conference of the Industrial Electronics Society (IECON 2019), pages 3657–3662, Lisbon, Portugal, October 14-17 2019. IEEE.
// DOI: http://doi.org/10.1109/IECON.2019.8927224
// http://www.isr.uc.pt/~jermendes/    ;     http://www.isr.uc.pt/~rui/

#include "math.h"
#include "mex.h"
#include <stdlib.h>
#include <iostream>
#include <vector>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
//  MATLAB function omega_all = Epsilons_all_C_opt(data_xtrain, x, omega_all);
    /***** Description   ****/
    // This function obtains the value od the variable \omega for all dataset
    
    /***** Inputs Declaration *****/
    const mxArray *data_ytrain, *data_xtrain, *x, *ep;
    double limit_it, limit_theta;
    
    data_xtrain = prhs[0];  // get input 1 (inputs data)
    x = prhs[1];            // get input 2 (struct with all parameters of the fuzzy system)
    ep = prhs[2];           // get input 3 (variable \omega)
    
    /****** Definition of the Output of this mex function*****/
    plhs[0] = mxDuplicateArray(ep); // Duplicate the third function input (prhs[2]) (i.e.variable \omega)
    
    /**** Local Variables Declaration *****/
    int n_data = mxGetM(data_xtrain);   //number (rows) of the data samples - variable K
    int n_var = mxGetN(data_xtrain);    //number (column) of the inputs variables - variable n
    int n_rules, j, i, k, it, count;// n_rules - number of rules, variable N_j;
    // j is the input variable index, variable j;
    // i is the rule index, variable i;
    // k is data index, variable k;
    // it is variable it;
    // count is an auxiliary variable
    mxArray *mx,*mx_ep; //  variable
    double *Rules,*Rules_ep, *bias_j, *bias, *residual;   //Rules has dimensions (n_rules)x4: each row represents a rule; the first 3 columns are the
    // antecedent membership function parameters (a_{j,i}, b_{j,i}, and c_{j,i} see Fig 2);
    // last column is the consequent parameter(\theta)
    // bias_j is the bias of the model of variable j
    // bias is the bias of the general model, variable y_0
    
    /****** Get matrix data *****/
    
    double *data_xtrain_Values = mxGetPr(data_xtrain); // get input dat
    
    int l, jj; // auxiliaries variables
    double Varvalue_j, aux, sum_mu, EstimationExcept_J[n_data], parameters[3], y_est_aux, y_est[n_data*(n_var-1)] ,epsilon;// auxiliaries variables
    
    ///////////////////////////////////////////////
    ///////// EPSILON  /////////////////
    /////////////////////////////////////
    
    for (j=0;j<n_var;j++){// for all input variables
        
        mx = mxGetField(x, j, "Rules");  // Get the rules matrix of variable j
        Rules = mxGetPr(mx);
        
        mx_ep = mxGetField(plhs[0], j, "Rules");  // Get the rules matrix of variable j
        Rules_ep = mxGetPr(mx_ep);
        
        n_rules = mxGetM(mx); // Obtain the number of rows (rules)
        
        double mu_opt[n_rules];
        
        for (l=0;l<n_data;l++){// for all dataset
            
            Varvalue_j = data_xtrain_Values[n_data*j + l]; // Obtain value of the input variable j on instant l of the dataset
            
            sum_mu = 0.0;
            
            for (i=0;i<n_rules;i++){// for all rules of variable j
                
                parameters[0] = Rules[i];  // parameter a_{j,i_j};
                parameters[1] = Rules[n_rules*1 +i];  // parameter b_{j,i_j};
                parameters[2] = Rules[n_rules*2 +i];  // parameter c_{j,i_j};
                
                /**** Obtain the fuzzy triangular membership functions degree *****/
                if (Varvalue_j > parameters[0] && Varvalue_j < parameters[1])
                    
                    mu_opt[i] = (Varvalue_j-parameters[0])/(parameters[1]-parameters[0]);
                
                else if (Varvalue_j >= parameters[1] && Varvalue_j < parameters[2] )
                    
                    mu_opt[i] = (parameters[2]-Varvalue_j)/ (parameters[2] - parameters[1] );
                
                else if (Varvalue_j <= parameters[0] || Varvalue_j >= parameters[2] )
                    
                    mu_opt[i] = 0;
                
                /**** end ****/
                
                sum_mu = sum_mu +  mu_opt[i];
            }// end for (i=0;i<n_rules;i++)
            
            for (i=0;i<n_rules;i++){// for all rules of variable j
                
                Rules_ep[n_rules*l +i] = mu_opt[i] / (sum_mu + 0.0000000000000000001); // variable \omega of the rule i of the variable j; last term is for protection of divide by zero
                
            }
        }
    }
    
    
    return;
}