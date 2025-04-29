plot_summary <- function(x.mat, adj.inc, cov_matrix, expl.var, dates, locs, gn) {
  n <- nrow(x.mat)
  norms <- apply(x.mat, 1, L2_norm)
  adj.norms <- apply(adj.inc, 1, L2_norm)

  par(mfrow = c(2, 2))
  small_grid <- round(seq(1, ncol(cov_matrix), length.out = 100))

  persp(cov_matrix[small_grid, small_grid], xlab = "Maturity", ylab = "Maturity", zlab = "Trunc. Cov.", main = "estimated kernel")
  plot(expl.var[1:10], type = "b", ylab = "Explained Var", xlab = "Eigenvalues", main = "Explained Variation of Princ.Comp.")
  abline(h = .99, col = "gray60")
  plot(norms, type = "l", ylab = expression("L"[2]~"Norms (Prices)"), xlab = "Time", xaxt = "n", main = "price norms & jump loc. (green)")
  axis(1, at = seq(1, n, length.out = 10), labels = as.Date(dates[seq(1, n, length.out = 10)]))
  points(x = locs, y = norms[locs], col = "darkgreen")
  plot(adj.norms, type = "l", ylab =  expression("L"[2]~"Norms (Diff. Ret.)"), xlab = "Time", xaxt = "n", main = "diff.ret. norms & jump loc. (green)")
  axis(1, at = seq(1, n - 1, length.out = 10), labels = as.Date(dates[-1][seq(1, n - 1, length.out = 10)]))
  points(x = locs, y = adj.norms[locs], col = "darkgreen")
}
