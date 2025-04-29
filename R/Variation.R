# Internal helper function
# Calculates the sum of tensor (outer) products of the rows in a matrix of increments.
# This can be used to compute the realized coavriation.
#
# Parameters:
#   Incr - A numeric matrix of increments (each row = an increment vector).
#
# Returns:
#   A symmetric matrix representing the sum of outer products across all increments.

variation <- function(Incr){
  return(t(Incr) %*% Incr)
}


