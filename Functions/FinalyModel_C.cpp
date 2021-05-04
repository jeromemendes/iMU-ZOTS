/*
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
 **/
    
#include "math.h"
#include "mex.h"
#include <stdlib.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
//  MATLAB function y_est = FinalyModel_C(x, data);
    
    /***** Inputs Declaration *****/
    const mxArray *data_x;
    const mxArray *x_aux;
    
    x_aux = prhs[0];   // get input 1 (struct with all parameters of the neo-fuzzy)
    data_x = prhs[1];  // get input 2 (inputs data)
    
    /**** Local Variables Declaration *****/
    int n_data = mxGetM(data_x); //number (rows) of the data samples - variable K
    int n_var = mxGetN(data_x);  //number (column) of the inputs variables - variable n
    
    /****** Definition of the Output of this mex function*****/
    plhs[0] = mxCreateDoubleMatrix(1, n_data, mxREAL);// memory allocation for the function output
    
    double *Out;
    Out = mxGetPr(plhs[0]); //function output (estimated output)
    
    int n_rules, j, i, it;// n_rules - number of rules, variable N_j;
    // j is the input variable index, variable j;
    // i is the rule index, variable i;
    // it is variable it;
    mxArray *mx; // auxiliary variable
    double *Rules, *bias_j, *bias;//Rules has dimensions (n_rules)x4: each row represents a rule; the first 3 columns are the
    // antecedent membership function parameters (a_{j,i}, b_{j,i}, and c_{j,i} see Fig 2);
    // last column is the consequent parameter(\theta)
    // bias_j is the bias of the model of variable j
    // bias is the bias of the general model, variable y_0
    mxArray *x = const_cast<mxArray*>(x_aux);
    double Varvalue_j, aux, sum_mu, parameters[3], y_est_aux, y_est[n_data*n_var] ,epsilon; // auxiliary variables
    int l, k; // auxiliary variables
    
    /****** Get matrix *****/
    double *data_x_Values = mxGetPr(data_x); // get input data
    
    k = 0;
    
    for (j=0;j<n_var;j++){// for all input variables
        
        mx = mxGetField(x, j, "Rules");
        n_rules = mxGetM(mx);
        Rules = mxGetPr(mx);
        
        double mu[n_rules];
        
        for (l=0;l<n_data;l++){// for all dataset
            
            Varvalue_j = data_x_Values[n_data*j + l];// Obtain value of the input variable j on instant l of the dataset
            
            sum_mu = 0.0;
            
            for (i=0;i<n_rules;i++){// for all rules of variable j
                
                parameters[0] = Rules[i];// parameter a_{j,i};
                parameters[1] = Rules[n_rules*1 +i];// parameter b_{j,i};
                parameters[2] = Rules[n_rules*2 +i];// parameter c_{j,i};
                
                /**** Obtain the fuzzy triangular membership functions degree *****/
                if (Varvalue_j > parameters[0] && Varvalue_j < parameters[1])
                    
                    mu[i] = (Varvalue_j-parameters[0])/(parameters[1]-parameters[0]);
                
                else if (Varvalue_j >= parameters[1] && Varvalue_j < parameters[2] )
                    
                    mu[i] = (parameters[2]-Varvalue_j)/ (parameters[2] - parameters[1] );
                
                else if (Varvalue_j <= parameters[0] || Varvalue_j >= parameters[2] )
                    
                    mu[i] = 0;
                
                sum_mu = sum_mu +  mu[i];
                /**** end ****/
                
            }// end for (i=0;i<n_rules;i++)
            
            y_est_aux = 0.0;
            
            for (i=0;i<n_rules;i++){// for all rules of variable j
                
                epsilon = mu[i] / (sum_mu + 0.0000000000000000001);// variable \omega of the rule i of the variable j; last term is for protection of divide by zero
                y_est_aux = y_est_aux + epsilon * Rules[n_rules*3 +i];
                
            }
            // Get bias_j
            mx = mxGetField(x, j, "bias_j");
            bias_j = mxGetPr(mx);
            
            y_est[k] = y_est_aux - *bias_j;
            
            k=k+1;
        }// end for (l=0;l<n_data;l++)
    }// end for (j=0;j<n_var;j++)
    
    // Get bias
    mx = mxGetField(x, 0, "bias");
    bias = mxGetPr(mx);
    
    for (l=0;l<n_data;l++){// for all data
        
        aux = 0.0;
        
        for (j=0;j<n_var;j++){// for all rules of variable j
            
            aux = aux + y_est[ l+j*n_data ];
        }
        
        Out[l] = aux + bias[0]; // Estimated output at instant l
    } // end for (l=0;l<n_data;l++)
    
    return;
}
