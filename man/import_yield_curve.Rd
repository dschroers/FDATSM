% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Functional_Data_Object.R
\name{import_yield_curve}
\alias{import_yield_curve}
\title{Functional Data Object}
\usage{
import_yield_curve(
  file_path = "C:/Users/Jonas/Desktop/RA/LW_daily.xlsx",
  basis_type = "fourier",
  n_basis = 15,
  max_maturity = 84,
  step_size = 1,
  fdnames = list("Maturity", "Date", "Yield"),
  plot = TRUE
)
}
\arguments{
\item{file_path}{The local file path to the data in xlsx-format}

\item{basis_type}{Specifies the type of basis used for smoothing. Options are 'fourier' or 'bspline'}

\item{n_basis}{Specifies the number of basis functions used for smoothing}

\item{max_maturity}{Specifies the maximum maturity}

\item{step_size}{Specifies the maturity interval size}

\item{fdnames}{Names for the dimensions of the functional data object}

\item{plot}{plot = TRUE produces a sample plot of the smoothed yield curve data}
}
\value{
Smoothed yield curve data as an 'fd'-object
}
\description{
This function transforms yield data into a functional data object and smoothes between the maturity points.
The data sheet needs to be structured as follows: The first column contains the dates, each subsequent column marks one maturity date.
The cells contain the yields in percentage points.
}
