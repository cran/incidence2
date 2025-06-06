% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coerce.R
\name{as}
\alias{as}
\alias{as_incidence}
\alias{as_incidence.default}
\alias{as_incidence.incidence2}
\alias{as.data.frame.incidence2}
\alias{as.data.table.incidence2}
\alias{as_tibble.incidence2}
\title{Coerce to and from an incidence object}
\usage{
as_incidence(x, ...)

\method{as_incidence}{default}(x, ...)

\method{as_incidence}{incidence2}(x, ...)

\method{as.data.frame}{incidence2}(x, row.names, optional, ...)

\method{as.data.table}{incidence2}(x, keep.rownames, ...)

\method{as_tibble}{incidence2}(x, ..., .rows, .name_repair, rownames)
}
\arguments{
\item{x}{An \R object.}

\item{...}{Additional arguments to be passed to or from other methods.}

\item{row.names}{Not used.}

\item{optional}{Not used.}

\item{keep.rownames}{Not used.}

\item{.rows}{The number of rows, useful to create a 0-column tibble or
just as an additional check.}

\item{.name_repair}{Treatment of problematic column names:
\itemize{
\item \code{"minimal"}: No name repair or checks, beyond basic existence,
\item \code{"unique"}: Make sure names are unique and not empty,
\item \code{"check_unique"}: (default value), no name repair, but check they are
\code{unique},
\item \code{"universal"}: Make the names \code{unique} and syntactic
\item a function: apply custom name repair (e.g., \code{.name_repair = make.names}
for names in the style of base R).
\item A purrr-style anonymous function, see \code{\link[rlang:as_function]{rlang::as_function()}}
}

This argument is passed on as \code{repair} to \code{\link[vctrs:vec_as_names]{vctrs::vec_as_names()}}.
See there for more details on these terms and the strategies used
to enforce them.}

\item{rownames}{How to treat existing row names of a data frame or matrix:
\itemize{
\item \code{NULL}: remove row names. This is the default.
\item \code{NA}: keep row names.
\item A string: the name of a new column. Existing rownames are transferred
into this column and the \code{row.names} attribute is deleted.
No name repair is applied to the new column name, even if \code{x} already contains
a column of that name.
Use \code{as_tibble(rownames_to_column(...))} to safeguard against this case.
}

Read more in \link[tibble]{rownames}.}
}
\value{
An object of the desired type with additional attributes dropped.
}
\description{
Generic for coercion to an \verb{<incidence2>} object.
}
\examples{
\dontshow{.old <- data.table::setDTthreads(2)}
if (requireNamespace("outbreaks", quietly = TRUE)) {
    data(ebola_sim_clean, package = "outbreaks")
    dat <- ebola_sim_clean$linelist
    x <- incidence(dat, "date_of_onset")
    as.data.frame(dat)
    as.data.table(x)
    as_tibble(x)
}
\dontshow{data.table::setDTthreads(.old)}

}
