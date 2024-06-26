% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/regroup.R
\name{regroup_}
\alias{regroup_}
\title{Regroup 'incidence' objects (tidyselect compatible)}
\usage{
regroup_(x, groups = NULL)
}
\arguments{
\item{x}{\verb{<incidence2>} object.}

\item{groups}{\code{\link[dplyr:dplyr_tidy_select]{<tidyselect>}}

The groups to sum over.

If \code{NULL} (default) then the function returns the corresponding object with
no groupings.}
}
\description{
This function regroups an \verb{<incidence2>} object across the specified groups.
The resulting \verb{<incidence2>} object will contains counts summed over the
groups present in the input.  It differs from \code{regroup()} only in
support for \code{\link[dplyr:dplyr_tidy_select]{<tidy-select>}}
semantics in the \code{groups} argument.
}
\examples{
\dontshow{.old <- data.table::setDTthreads(2)}
if (requireNamespace("outbreaks", quietly = TRUE)) {
    data(ebola_sim_clean, package = "outbreaks")
    dat <- ebola_sim_clean$linelist
    i <- incidence_(
        dat,
        date_index = date_of_onset,
        groups = c(gender, hospital)
    )
    regroup_(i)
    regroup_(i, hospital)
}
\dontshow{data.table::setDTthreads(.old)}

}
\seealso{
\code{regroup()} for a version without tidyselect semantics. This may be
preferable for programatic usage.
}
