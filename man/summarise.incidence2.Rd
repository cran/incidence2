% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarise.R
\name{summarise.incidence2}
\alias{summarise.incidence2}
\title{Summarise each grouping down to one row}
\usage{
\method{summarise}{incidence2}(.data, ..., .by, .groups)
}
\arguments{
\item{.data}{An \link[=incidence]{incidence2} object.}

\item{...}{<\code{\link[rlang:args_data_masking]{data-masking}}> Name-value pairs.
The name gives the name of the column in the output.

The value can be:
\itemize{
\item A vector of length 1, which will be recycled to the correct length.
\item A vector the same length as the current group (or the whole data frame
if ungrouped).
\item \code{NULL}, to remove the column.
\item A data frame or tibble, to create multiple columns in the output.
}}

\item{.by}{Not used as grouping structure implicit.}

\item{.groups}{Not used.}
}
\value{
A \link[tibble:tibble]{tibble}.
}
\description{
Method for \link[dplyr:summarise]{dplyr::summarise} that implicitly accounts for the inherent
grouping structure of \link[=incidence]{incidence2} objects.
}
\examples{
\dontshow{.old <- data.table::setDTthreads(2)}
if (requireNamespace("outbreaks", quietly = TRUE)) {
    data(ebola_sim_clean, package = "outbreaks")
    ebola_sim_clean$linelist |>
        subset(!is.na(hospital)) |>
        incidence_(date_of_onset, hospital, interval = "isoweek") |>
        summarise(model = list(glm(count ~ date_index, family = "poisson")))
}
\dontshow{data.table::setDTthreads(.old)}

}
\seealso{
\link[dplyr:summarise]{dplyr::summarise} for the underlying grouping.
}
