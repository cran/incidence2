% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/keep.R
\name{keep}
\alias{keep}
\alias{keep_first}
\alias{keep_last}
\alias{keep_peaks}
\alias{first_peak}
\title{Keep first, last and peak occurences}
\usage{
keep_first(x, n, complete_dates = TRUE, ...)

keep_last(x, n, complete_dates = TRUE, ...)

keep_peaks(x, complete_dates = TRUE, first_only = FALSE, ...)

first_peak(x, complete_dates = TRUE, ...)
}
\arguments{
\item{x}{\link[=incidence]{incidence2} object.}

\item{n}{\code{integer}.

Number of entries to keep.

\code{double} vectors will be converted via \code{as.integer(n)}.}

\item{complete_dates}{\code{bool}.

Should \code{complete_dates()} be called on the data prior to keeping the first
entries.

Defaults to TRUE.}

\item{...}{Other arguments passed to \code{complete_dates()}.}

\item{first_only}{\code{bool}.

Should only the first peak (by date) be kept.

Defaults to \code{TRUE}.}
}
\value{
\link[=incidence]{incidence2} object with the chosen entries.
}
\description{
\code{keep_first()} and \code{keep_last()} keep the first and last \code{n} rows to occur
for each grouping when in ascending date order. \code{keep_peaks()} keeps the rows
with the maximum count value for each group. \code{first_peak()} is a convenience
wrapper around \code{keep_peaks()} with the \code{first_only} argument set to \code{TRUE}.
}
\examples{
\dontshow{.old <- data.table::setDTthreads(2)}
if (requireNamespace("outbreaks", quietly = TRUE)) {
    data(ebola_sim_clean, package = "outbreaks")
    dat <- ebola_sim_clean$linelist
    inci <- incidence(dat, "date_of_onset")
    keep_first(inci, 3)
    keep_last(inci, 3)
}
\dontshow{data.table::setDTthreads(.old)}

}
