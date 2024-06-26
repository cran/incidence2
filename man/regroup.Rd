% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/regroup.R
\name{regroup}
\alias{regroup}
\title{Regroup 'incidence' objects}
\usage{
regroup(x, groups = NULL)
}
\arguments{
\item{x}{\verb{<incidence2>} object.}

\item{groups}{\code{character}.

The groups to sum over.

If \code{NULL} (default) then the function returns the corresponding object with
no groupings.}
}
\description{
This function regroups an \link[=incidence]{incidence2} object across
the specified groups. The resulting \link[=incidence]{incidence2}
object will contains counts aggregated over the specified groups.
}
\examples{
\dontshow{.old <- data.table::setDTthreads(2)}
if (requireNamespace("outbreaks", quietly = TRUE)) {
    data(ebola_sim_clean, package = "outbreaks")
    dat <- ebola_sim_clean$linelist
    i <- incidence(
        dat,
        date_index = "date_of_onset",
        groups = c("gender", "hospital")
    )
    regroup(i)
    regroup(i, "hospital")
}
\dontshow{data.table::setDTthreads(.old)}

}
\seealso{
\code{regroup_()} for a version supporting
}
