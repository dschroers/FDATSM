#' @title Functional Data Object
#' @description This function transforms yield data into a functional data object and smoothes between the maturity points.
#' The data sheet needs to be structured as follows: The first column contains the dates, each subsequent column marks one maturity date.
#' The cells contain the yields in percentage points.
#' @param file_path The local file path to the data in xlsx-format
#' @param basis_type Specifies the type of basis used for smoothing. Options are 'fourier' or 'bspline'
#' @param n_basis Specifies the number of basis functions used for smoothing
#' @param max_maturity Specifies the maximum maturity
#' @param step_size Specifies the maturity interval size
#' @param fdnames Names for the dimensions of the functional data object
#' @param plot plot = TRUE produces a sample plot of the smoothed yield curve data
#' @import fda
#' @import readxl
#' @return Smoothed yield curve data as an 'fd'-object
#' @export
import_yield_curve <- function(file_path = "C:/Users/Jonas/Desktop/RA/LW_daily.xlsx",
                               basis_type = "fourier",
                               n_basis = 15,
                               max_maturity = 84,
                               step_size = 1,
                               fdnames = list("Maturity", "Date", "Yield"),
                               plot = TRUE)
                               {


  #Read the data
  yield_data <- readxl::read_excel(file_path,
                           sheet = "Test",
                           range = "A1:CG94")


  #Extract the dates and maturities
  dates <- as.Date(as.character(yield_data[[1]]), format = "%Y%m%d")
  maturities <- seq(1, max_maturity, by = step_size)
  yields <- as.matrix(yield_data[, -1])

  #Choose basis
  if (basis_type == "fourier") {
    basis <- fda::create.fourier.basis(rangeval = c(1, max_maturity), nbasis = n_basis)
  } else if (basis_type == "bspline") {
    basis <- fda::create.bspline.basis(rangeval = c(1, max_maturity), nbasis = n_basis)
  } else {
    stop("Invalid basis type. Choose either 'fourier' or 'bspline'.")
  }

  #Smooth the data to obtain the functional data object
  yield_fd <- fda::smooth.basis(argvals = maturities,
                                y = t(yields),
                                fdParobj = basis)$fd

  #Set names for the functional data object
  yield_fd$fdnames <- fdnames


  if(plot == TRUE){
  plot_sample <- sample(1:nrow(yields), size = 5, replace = FALSE)

  plot(yield_fd, col = 1:5, lty = 1, main = "Sample of Yield Curves", xlab = "Maturities (Months)", ylab = "Yields (%)")
  legend("topright", legend = dates[plot_sample], col = 1:5, lty = 1, title = "Dates")
  }

  #Return the functional data object
  return(yield_fd)
  }

