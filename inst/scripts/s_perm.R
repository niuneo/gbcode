####################################################
# s_perm.R
# Notes "approches non-param�triques" page 9.
# Test de permutation pour deux �chantillons de.
# tailles 3 et 4.
####################################################

# ===================
# effacer la m�moire
# ===================

rm(list=ls())

# =======================
# Fonction "factorielle"
# =======================

fact <- function(n){
  f <- 1
  for (i in 2:n){
    f <- f*i
  }
  f
}

# ======================
# Les deux �chantillons
# ======================

D1 <- c(74,86,98,102)
D2 <- c(10,25,80)
M <- length(D1)
N <- length(D2)
D <- c(D1, D2)

# ==================================================
# Calcule de la statistique de test sur les donn�es 
# de d�part.
# ==================================================

t <- mean(D[1:M])-mean(D[(M+1):(M+N)])



# ====================================================
# Calcule des statistiques de test sur les partitions
# ====================================================

F <- fact(M+N)
tp <- array(0,dim=c(F,1)) # vecteur des r�sultats.
for (p in 1:F){
   Dp <- sample(D)
   tp[p] <- mean(Dp[1:M])-mean(Dp[(M+1):(M+N)])
 }
tp <- sort(tp)

# ======================================================
# Calcul du pourcentage de valeurs � gauche et � droite
# de la statistique originale.
# ======================================================

q.inf <- sum(t < tp) / length(tp)
q.sup <- sum(t > tp) / length(tp)

# ===============================================
# Test proprement dit et affichage des r�sultats
# ===============================================

hist(tp,main="")
abline(v=t,col="red")

alpha <- 0.1
if ((q.inf < alpha/2) | (q.sup < alpha/2)){
  title(paste("Hypothesis D1=D2 rejected:
        p-value=",round(min(c(q.inf,q.sup)),2),
        " alpha=", alpha))
} else {   
  title(paste("Hypothesis D1=D2 not rejected: p-value=",
        round(min(c(q.inf,q.sup)),2)," alpha=", alpha)) 
}