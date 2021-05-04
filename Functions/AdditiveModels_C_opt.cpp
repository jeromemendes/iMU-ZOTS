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
//  MATLAB function x = AdditiveModels_C(data_ytrain, data_xtrain, x, limit_it, limit_error, omega_all)
    /***** Description   ****/
    // This function performs the GAM-ZOTS method (Algorithm 2)     
    
    /***** Inputs Declaration *****/
    const mxArray *data_ytrain, *data_xtrain, *x, *ep;
    double limit_it, limit_theta;
    
    data_ytrain = prhs[0];  // get input 1 (output data)
    data_xtrain = prhs[1];  // get input 2 (inputs data)
    x = prhs[2];            // get input 3 (struct with all parameters of the fuzzy system)
    limit_it = mxGetScalar(prhs[3]);    // get input 4 - variable lim_{it}
    limit_theta = mxGetScalar(prhs[4]);  // get input 5 - termination condition - variable \epsilon
    ep = prhs[5];           // get input 6 - variable \omega
    
    /****** Definition of the Output of this mex function*****/
    plhs[0] = mxDuplicateArray(x); // Duplicate the third function input (prhs[2]) (i.e. the actual struct with all parameters of the neo-fuzzy)
    
    /**** Local Variables Declaration *****/
    int n_data = mxGetM(data_xtrain);   //number (rows) of the data samples - variable K
    int n_var = mxGetN(data_xtrain);    //number (column) of the inputs variables - variable n
    int n_rules, j, i, k, it, count;// n_rules - number of rules, variable N_j;
    // j is the input variable index, variable j;
    // i is the rule index, variable i;
    // k is data index, variable k;
    // it is variable it;
    // count is an auxiliary variable
    mxArray *mx; // auxiliary variable
    mxArray *mx_ep; // auxiliary variable
    double *Rules_ep;
    double *Rules, *bias_j, *bias, *residual;   //Rules has dimensions (n_rules)x4: each row represents a rule; the first 3 columns are the
    // antecedent membership function parameters (a_{j,i_j}, b_{j,i_j}, and c_{j,i_j} see Fig 2);
    // last column is the consequent parameter(\theta)
    // bias_j is the bias of the model of variable j
    // bias is the bias of the general model, variable y_0
    
    /****** Get matrix data *****/
    double *data_ytrain_Values = mxGetPr(data_ytrain); // get output data
    double *data_xtrain_Values = mxGetPr(data_xtrain); // get input data
    
    /****** Residual initialization *****/
    residual = (double *) mxCalloc(n_data, sizeof(double ));// variable y^l - Obtained on Algoritm 2 Step 3.c.A
    *residual = *data_ytrain_Values; // Initialized with the output data
    
    
    //////////////////////////////////////////////////////////////
    /////////////        Algoritm 2 Step 2.a       /////////////
    //////////////////////////////////////////////////////////////
    
    /**** Obtain bias of the general model ****/
    double mean = 0.0, mean_y = 0.0; //auxiliaries variables
    
    for (k=0;k<n_data;k++){ // for all output data
        
        mean_y = mean_y + data_ytrain_Values[k];
        
    }// end for (k=0;k<n_data;k++)
    
    mean_y = mean_y/n_data; // Obtain y_0 (Algoritm 2 Step 3.a.i)
    
    mx = mxGetField(plhs[0], 0, "bias");
    bias = mxGetPr(mx);
    bias[0] = mean_y; // save bias (variable y_0) on the struct (output)
    
    //////////////////////////////////////////////////////////////
    /////////////        Algoritm 2 Step 2.a      /////////////
    //////////////////////////////////////////////////////////////
    
    /**** Initialization of thetas and bias_j by zero  ****/
    std::vector<double> theta_aux;  // auxiliary variable to obtain \theta (consequent parameters)
    count = 0;
    
    for (j=0;j<n_var;j++){// for all input variables
        
        mx = mxGetField(plhs[0], j, "Rules"); // Get the rules matrix of variable j
        Rules = mxGetPr(mx);
        
        n_rules = mxGetM(mx); // Obtain the number of rows (rules)
        
        // Set all thetas parameters to 0
        for (i=0;i<n_rules;i++){// for all rules of variable j
            
            theta_aux.push_back (0.0);
            count++;
        }
        // Set bias_j = 0.0
        mx = mxGetField(plhs[0], j, "bias_j"); // Get bias_j
        bias_j = mxGetPr(mx);
        bias_j[0] = 0.0;
        
    }// end for (j=0;j<n_var;j++)
    
    int l, jj; // auxiliaries variables
    double Varvalue_j, aux, sum_mu, EstimationExcept_J[n_data], parameters[3], y_est_aux, y_est[n_data*(n_var-1)] ,epsilon;// auxiliaries variables
    
    
    //////////////////////////////////////////////////////////////
    /////////////         Algoritm 2 Step 2.b        /////////////
    //////////////////////////////////////////////////////////////
    
    for (it=0;it<limit_it;it++){ // iterative learning (Algoritm 2 Step 2.b)
        
        for (j=0;j<n_var;j++){// for all input variables (Algoritm 2 Step 2.b.i)
            
            
            //////////////////////////////////////////////////////////////
            /////////////         Algoritm 2 Step 2.b.i.A    /////////////
            //////////////////////////////////////////////////////////////
            count = 0;
            
            for (jj=0;jj<n_var;jj++){// for all input variables
                
                if (j!=jj){ // Second term of equation presented on Algoritm 2 Step 2.b.i.A
                    
                    mx = mxGetField(plhs[0], jj, "Rules");  // Get the rules matrix of variable j
                    
                    Rules = mxGetPr(mx);
                    
                    n_rules = mxGetM(mx); // Obtain the number of rows (rules)
                    
                    mx_ep = mxGetField(ep, jj, "Rules");
                    Rules_ep = mxGetPr(mx_ep);
                    
                    double mu[n_rules];
                    
                    
                    for (l=0;l<n_data;l++){// for all dataset
                        
                        y_est_aux = 0.0;
                        
                        for (i=0;i<n_rules;i++){// for all rules of variable j
                                                        
                            y_est_aux = y_est_aux + Rules_ep[n_rules*l +i] * Rules[n_rules*3 +i];
                              
                        }
                        
                        mx = mxGetField(plhs[0], jj, "bias_j");
                        bias_j = mxGetPr(mx);
                        
                        y_est[count] = y_est_aux - *bias_j; // obtain the estimated output of variable j
                        
                        count = count + 1;
                        
                    }// end for (l=0;l<n_data;l++)
                    
                    
                }// end if (j!=jj)
                
            }// end for (jj=0;jj<n_var;jj++)
            
            for (l=0;l<n_data;l++){ // for all data
                
                aux = 0.0;
                
                for (count=0;count<n_var-1;count++){
                    
                    aux = aux + y_est[ l+count*n_data ];
                    
                }
                
                EstimationExcept_J[l] = aux; // second term of equation Algorithm 2 Step 2.b.i.A
                
                residual[l] = data_ytrain_Values[l] - mean_y - EstimationExcept_J[l]; // equation Algorithm 2 Step 2.b.i.A
                
            } //  end for (l=0;l<n_data;l++)
            
            //////////////////////////////////////////////////////////////
            /////////////         Algoritm 2 Step 2.b.i.B    /////////////
            //////////////////////////////////////////////////////////////
            
            
            mx = mxGetField(plhs[0], j, "Rules");// Get the rules matrix of variable j
            mx_ep = mxGetField(ep, j, "Rules");// Get the rules matrix of variable j
            n_rules = mxGetM(mx);
            Rules = mxGetPr(mx);
            Rules_ep = mxGetPr(mx_ep);
            
            double mu[n_rules], epsilons_rule[n_data*n_rules];
            int ii;
            
            /**** To call regress function of the matlab  ****/
            mxArray  *thetareg;
            
            mxArray *lhs[2], *lhs_one, *lhs_zero;
            
            lhs_zero=mxCreateDoubleMatrix(n_data,1,mxREAL);
            lhs_one=mxCreateDoubleMatrix(n_data,n_rules,mxREAL);
            
            double *lhs_one_values = mxGetPr(lhs_one);
            double *lhs_zero_values = mxGetPr(lhs_zero);
            
            for (l=0;l<n_data;l++){
                lhs_zero_values[l] = residual[l];
                
            }
            
            count = 0;
            for (ii=0;ii<n_rules;ii++){
                
                for (l=0;l<n_data;l++){

                    lhs_one_values[count] = Rules_ep[n_rules*l +ii];
                    
                    count++;
                }
            }
           
            lhs[0] = lhs_zero;
            lhs[1] = lhs_one;
            
            mexCallMATLAB(1, &thetareg, 2, lhs, "regress");// regress Matlab function to obtain the consequent parameters (\theta), Algoritm 2 Step 3.c.i.B
            
            double *thetareg_values=mxGetPr(thetareg);
            
            for (i=0;i<n_rules;i++){
                
                Rules[n_rules*3 +i] = thetareg_values[i];// save the new consequent parameters
            }
            
            //////////////////////////////////////////////////////////////
            /////////////         Algoritm 2 Step 2.b.i.C    /////////////
            //////////////////////////////////////////////////////////////
            
            double aux = 0.0;
            
            for (l=0;l<n_data;l++){// for all data
                
                y_est_aux = 0.0;
                
                for (i=0;i<n_rules;i++){
                    
                    y_est_aux = y_est_aux + Rules_ep[n_rules*l +i] * Rules[n_rules*3 +i];
                }
                
                aux = aux + y_est_aux;
                
            }
            
            mean = aux/n_data; // bias of model of variable j
            
            // Set bias_j = mean
            mx = mxGetField(plhs[0], j, "bias_j");
            bias_j = mxGetPr(mx);
            bias_j[0] = mean;
            
        }
        
        aux = 0.0;
        
        count=0;
        //////////////////////////////////////////////////////////////
        /////////////         Algoritm 2 Step 2.b.ii     /////////////
        //////////////////////////////////////////////////////////////
        
        for (j=0;j<n_var;j++){// for all input variables
            
            mx = mxGetField(plhs[0], j, "Rules");
            n_rules = mxGetM(mx);
            Rules = mxGetPr(mx);
            
            for (i=0;i<n_rules;i++){
                
                aux = aux + (  Rules[n_rules*3 +i] -theta_aux[count] ) * (  Rules[n_rules*3 +i] -theta_aux[count] ) ; // Calc the morm of gammas
                
                theta_aux[count] =  Rules[n_rules*3 +i] ;// Save the actual gamma
                
                count++;
            }
            
        }
        aux = sqrt(aux);
        
        if(aux < limit_theta){
            
            it = limit_it; // Termination condition
        }
    }
    
    return;
}