import pandas as pd
import numpy as np

def get_betas(X, Y):
    """Get betas (according to OLS formula)"""
    betas = (transpose(X) * X)^(-1) * (transpose(X) * Y)

    print("Working!")
    return betas

def get_residuals(betas, X, Y):
    """Get residuals (according to OLS formula)"""
    y_hat = betas * X
    residuals = Y - y_hat

    print("Working!")
    return residuals

def get_n(X, Y):
    n_X = length(X)
    n_Y = length(Y)

    if n_X == n_Y:
        n = n_X
    else:
        print("Error!")

    print("Working!")
    return n

def get_ses():
    residuals2 = residuals^2
    XX = (transpose(X) * X)^(-1)
    ses = (residuals2 / (N-1)) * XX

    print("Working!")
    return ses

def main():
    print("Working!")
