#----------------------------------------------------------------------------------#
# Performs simulations from Sunday morning
# Authors: Harriet, Casey, Nadav, Joel

# Notes:
#   
#----------------------------------------------------------------------------------#


########################################################
######################## Set-up ########################
########################################################

# load libraries
packages <- c("dplyr", "data.table", "ggplot2", "tidyr")
new.packages <- packages[!(packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(packages, library, character.only = TRUE)


########################################################
####################### Functions ######################
########################################################

Markets <- 50

demand <- function(alpha, delta, price, demand_shock) {
  if(delta > 0) {
    stop("Demand curves slope downward, sorry AOC")
  }
  alpha + delta * price + demand_shock
}

supply <- function(gamma, psi, price, supply_shock) {
  if(psi < 0) {
    stop("Supply curves slope downward, sorry el presidente")
  }
  gamma + psi * price + supply_shock
}

alpha <- rnorm(1, 15, 2)
delta <- -exp(rnorm(1, 0, 1))
gamma <- rnorm(1, -2, 1)
psi <- exp(rnorm(1, 0, 1))
xi_d <- rnorm(Markets)
xi_s <- rnorm(Markets)
supply_instrument <- xi_s + rnorm(Markets)
prices <- rep(0, Markets)

while(sum(abs(demand(alpha, delta, prices, xi_d) - 
              supply(gamma, psi, prices, xi_s))) > 0.01) {
  prices <- prices + 0.1*(demand(alpha, delta, prices, xi_d) - 
                            supply(gamma, psi, prices, xi_s))
}


######################
############ OLS SBC
######################

N <- 200
sims <- 500
P <- 15

X <- cbind(1, matrix(rnorm(N*(P-1)), N, P-1))

out <- matrix(NA, sims, P)

for (s in 1:sims) {
  betahat <- rnorm(P, 0, 2)
  sigmahat <- exp(rnorm(1))
  yhat <- rnorm(N, X %*% betahat, sigmahat)
  fit <- lm(yhat ~ -1 + ., data = as.data.frame(X))
  beta_est <- coef(fit)
  vcov_est <- vcov(fit)
  d <- MASS::mvrnorm(2000, beta_est, .22*vcov_est)
  
  for(p in 1:ncol(d)) {
    out[s, p] <- mean(d[,p] <= betahat[p])
  }
}

hist(as.vector(out))

plot.function(ecdf(out))
plot.function(punif, col = 2, add = T, type = "l")

ks.test(out, punif)

