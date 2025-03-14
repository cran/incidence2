% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dplyr.R
\name{dplyr-verbs}
\alias{dplyr-verbs}
\alias{mutate.incidence2}
\alias{nest.incidence2}
\alias{summarise.incidence2}
\title{dplyr and tidyr verbs}
\usage{
\method{mutate}{incidence2}(
  .data,
  ...,
  .by,
  .keep = c("all", "used", "unused", "none"),
  .before = NULL,
  .after = NULL
)

\method{nest}{incidence2}(.data, ..., .by, .key, .names_sep)

\method{summarise}{incidence2}(.data, ..., .by, .groups)
}
\arguments{
\item{.data}{An \link[=incidence]{incidence2} object.}

\item{...}{Only used by \code{mutate()} and \code{summarise()} and, in which case,
passed to underlying dplyr function.}

\item{.by}{Not used as grouping structure implicit.}

\item{.keep}{Control which columns from \code{.data} are retained in the output. Grouping
columns and columns created by \code{...} are always kept.
\itemize{
\item \code{"all"} retains all columns from \code{.data}. This is the default.
\item \code{"used"} retains only the columns used in \code{...} to create new
columns. This is useful for checking your work, as it displays inputs
and outputs side-by-side.
\item \code{"unused"} retains only the columns \emph{not} used in \code{...} to create new
columns. This is useful if you generate new columns, but no longer need
the columns used to generate them.
\item \code{"none"} doesn't retain any extra columns from \code{.data}. Only the grouping
variables and columns created by \code{...} are kept.
}}

\item{.before, .after}{<\code{\link[dplyr:dplyr_tidy_select]{tidy-select}}> Optionally, control where new columns
should appear (the default is to add to the right hand side). See
\code{\link[dplyr:relocate]{relocate()}} for more details.}

\item{.key}{The name of the resulting nested column. Only applicable when
\code{...} isn't specified, i.e. in the case of \code{df \%>\% nest(.by = x)}.

If \code{NULL}, then \code{"data"} will be used by default.}

\item{.names_sep}{Not used.}

\item{.groups}{Not used.}
}
\value{
\itemize{
\item For \code{mutate()} a modified \link[=incidence]{incidence2} object if the
necessary invariants are preserved, otherwise a \link[tibble:tibble]{tibble}.
\item For \code{nest()} a nested \link[tibble:tibble]{tibble} with rows corresponding to
the count variable and (optionally) group columns of the input object.
\item For summarise a \link[tibble:tibble]{tibble} with rows corresponding to the
underlying groupings. The columns are a combination of the grouping keys
and the summary expressions provided.
}
}
\description{
\link[dplyr:dplyr-package]{dplyr} and \link[tidyr:tidyr-package]{tidyr} methods that implicitly
account for the inherent grouping structure of incidence2 objects.
}
\examples{
\dontshow{.old <- data.table::setDTthreads(2)}
if (requireNamespace("outbreaks", quietly = TRUE) && requireNamespace("ggplot2", quietly = TRUE)) {
    data(ebola_sim_clean, package = "outbreaks")
    x <- subset(ebola_sim_clean$linelist, !is.na(hospital))
    dat <- incidence_(x, date_of_onset, hospital, interval = "isoweek")

    mutate(dat, ave = data.table::frollmean(count, n = 3L, align = "right")) |>
        plot(border_colour = "white", angle = 45) +
        ggplot2::geom_line(ggplot2::aes(x = date_index, y = ave))

    nest(dat)

    summarise(dat, model = list(glm(count ~ date_index, family = "poisson")))
}
\dontshow{data.table::setDTthreads(.old)}

}
\seealso{
\link[dplyr:mutate]{dplyr::mutate}, \link[tidyr:nest]{tidyr::nest} and \link[dplyr:summarise]{dplyr::summarise} for the underlying
generics.
}
