#! /usr/bin/env python


import math
import numpy
import scipy.optimize



def beta_binomial_loglikelihood(params, Ns, Ks):

    """Calculating log-likelihood of beta-binomial distribution

    Args:
        params (List[float]): the parameter of beta distribution ([alpha, beta])
    
        As (numpy.array([int])): the counts for success
        
        Bs (numpy.array([int])): the counts of trials

    """

    alpha = params[0]    
    beta = params[1]


    ML = 0
    ML = ML + reduce(lambda a, b: a + math.lgamma(b), numpy.r_[0, Ns + 1])
    ML = ML - reduce(lambda a, b: a + math.lgamma(b), numpy.r_[0, Ks + 1])
    ML = ML - reduce(lambda a, b: a + math.lgamma(b), numpy.r_[0, Ns - Ks + 1])
    
    ML = ML - reduce(lambda a, b: a + math.lgamma(b), numpy.r_[0, Ns + alpha + beta])
    ML = ML + reduce(lambda a, b: a + math.lgamma(b), numpy.r_[0, Ks + alpha])
    ML = ML + reduce(lambda a, b: a + math.lgamma(b), numpy.r_[0, Ns - Ks + beta])

    ML = ML + len(Ns) * (math.lgamma(alpha + beta) - math.lgamma(alpha) - math.lgamma(beta))


    # Here, we set the penalty term of alpha and beta (0.5 is slightly arbitray...)
    ML = ML - 0.5 * math.log(alpha + beta)
    return -ML



def fit_beta_binomial(As, Bs):

    """Obtaining maximum likelihood estimator of beta-binomial distribution

    Args:
        As (numpy.array([int])): the counts for success
        
        Bs (numpy.array([int])): the counts of trials

    """

    result = scipy.optimize.fmin_l_bfgs_b(beta_binomial_loglikelihood,
                                          [20, 20],
                                          args = (As, Bs),
                                          approx_grad = True,
                                          bounds = [(0.1, 10000000), (1, 10000000)])

    #print result[0]

    #return alpha, beta
    return result[0]



#import sys

#A = [100, 200, 300]
#B = [10, 20, 30]

#if __name__ == "__main__":
#    As = numpy.array(A)
#    Bs = numpy.array(B)
#    fit_beta_binomial(As, Bs)





