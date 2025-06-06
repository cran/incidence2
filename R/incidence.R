#' Compute the incidence of events
#'
#' `incidence()` calculates the *incidence* of different events across specified
#' time periods and groupings. `incidence_()` does the same but with support for
#' [tidy-select][dplyr::dplyr_tidy_select] semantics in some of its arguments.
#'
# -------------------------------------------------------------------------
#' `incidence2` objects are a sub class of data frame with some
#' additional invariants. That is, an `incidence2` object must:
#'
#' - have one column representing the date index (this does not need to be a
#'   `date` object but must have an inherent ordering over time);
#'
#' - have one column representing the count variable (i.e. what is being
#'   counted) and one variable representing the associated count;
#'
#' - have zero or more columns representing groups;
#'
#' - not have duplicated rows with regards to the date and group variables.
#'
# -------------------------------------------------------------------------
#' # Interval specification
#'
#' Where `interval` is specified, `incidence()`, predominantly uses the
#' [`grates`](https://cran.r-project.org/package=grates) package to generate
#' appropriate date groupings. The grouping used depends on the value of
#' `interval`. This can be specified as either an integer value or a string
#' corresponding to one of the classes:
#'
#' - integer values:                     [`<grates_period>`][grates::new_period] object, grouped by the specified number of days.
#' - day, daily:                         [`<Date>`][base::Dates] objects.
#' - week(s), weekly, isoweek:           [`<grates_isoweek>`][grates::isoweek] objects.
#' - epiweek(s):                         [`<grates_epiweek>`][grates::epiweek] objects.
#' - month(s), monthly, yearmonth:       [`<grates_yearmonth>`][grates::yearmonth] objects.
#' - quarter(s), quarterly, yearquarter: [`<grates_yearquarter>`][grates::yearquarter] objects.
#' - year(s) and yearly:                 [`<grates_year>`][grates::year] objects.
#'
#' For "day" or "daily" interval, we provide a thin wrapper around `as.Date()`
#' that ensures the underlying data are whole numbers and that time zones are
#' respected. Note that additional arguments are not forwarded to `as.Date()`
#' so for greater flexibility users are advised to modifying your input prior to
#' calling `incidence()`.
#'
# -------------------------------------------------------------------------
#' @param x
#'
#' A data frame object representing a linelist or pre-aggregated dataset.
#'
#' @param date_index
#'
#' `character` for `incidence()` or [tidy-select][dplyr::dplyr_tidy_select] for `incidence_()`.
#'
#' The time index(es) of the given data.
#'
#' This should be the name(s) corresponding to the desired date column(s) in x.
#'
#' A named vector can be used for convenient relabelling of the resultant output.
#'
#' Multiple indices only make sense when  `x` is a linelist.
#'
#' @param groups
#'
#' `character` for `incidence()` or [tidy-select][dplyr::dplyr_tidy_select] for `incidence_()`.
#'
#' An optional vector giving the names of the groups of observations for which
#' incidence should be grouped.
#'
#' A named vector can be used for convenient relabelling of the resultant output.
#'
#' @param counts
#'
#' `character` for `incidence()` or [tidy-select][dplyr::dplyr_tidy_select] for `incidence_()`.
#'
#' The count variables of the given data.  If NULL (default) the data is taken
#' to be a linelist of individual observations.
#'
#' A named vector can be used for convenient relabelling of the resultant output.
#'
#' @param count_names_to `character`.
#'
#' The column to create which will store the `counts` column names provided that
#' `counts` is not NULL.
#'
#' @param count_values_to `character`.
#'
#' The name of the column to store the resultant count values in.
#'
#' @param date_names_to `character`.
#'
#' The name of the column to store the date variables in.
#'
#' @param rm_na_dates `bool`.
#'
#' Should `NA` dates be removed prior to aggregation?
#'
#' @param interval
#'
#' An optional scalar integer or string indicating the (fixed) size of
#' the desired time interval you wish to use for for computing the incidence.
#'
#' Defaults to NULL in which case the date_index columns are left unchanged.
#'
#' Numeric values are coerced to integer and treated as a number of days to
#' group.
#'
#' Text strings can be one of:
#'
#'     * day or daily
#'     * week(s) or weekly
#'     * epiweek(s)
#'     * isoweek(s)
#'     * month(s) or monthly
#'     * yearmonth(s)
#'     * quarter(s) or quarterly
#'     * yearquarter(s)
#'     * year(s) or yearly
#'
#' More details can be found in the "Interval specification" section.
#'
#' @param offset
#'
#' Only applicable when `interval` is not NULL.
#'
#' An optional scalar integer or date indicating the value you wish to start
#' counting periods from relative to the Unix Epoch:
#'
#' - Default value of NULL corresponds to 0L.
#'
#' - For other integer values this is stored scaled by `n`
#'   (`offset <- as.integer(offset) %% n`).
#'
#' - For date values this is first converted to an integer offset
#'   (`offset <- floor(as.numeric(offset))`) and then scaled via `n` as above.
#'
#' @param complete_dates `bool`.
#'
#' Should the resulting object have the same range of dates for each grouping.
#'
#' Missing counts will be filled with `0L` unless the `fill` argument is
#' provided (and this value will take precedence).
#'
#' Will attempt to use `function(x) seq(min(x), max(x), by = 1)` on the
#' resultant date_index column to generate a complete sequence of dates.
#'
#' More flexible completion is possible by using the `complete_dates()`
#' function.
#'
#' @param fill `numeric`.
#'
#' Only applicable when `complete_dates = TRUE`.
#'
#' The value to replace missing counts caused by completing dates.
#'
#' If unset then will default to `0L`.
#'
#' @param ...
#'
#' Not currently used.
#'
# -------------------------------------------------------------------------
#' @seealso
#' `browseVignettes("grates")` for more details on the grate object classes.
#'
# -------------------------------------------------------------------------
#' @return
#' A [`tibble`][tibble::tibble] with subclass `incidence2`.
#'
# -------------------------------------------------------------------------
#' @examples
#' \dontshow{.old <- data.table::setDTthreads(2)}
#' if (requireNamespace("outbreaks", quietly = TRUE)) {
#'     data(ebola_sim_clean, package = "outbreaks")
#'     dat <- ebola_sim_clean$linelist
#'     incidence(dat, "date_of_onset")
#'     incidence_(dat, date_of_onset)
#'     incidence(dat, "date_of_onset", groups = c("gender", "hospital"))
#'     incidence_(dat, date_of_onset, groups = c(gender, hospital))
#' }
#' \dontshow{data.table::setDTthreads(.old)}
#'
# -------------------------------------------------------------------------
#' @export
incidence <- function(
    x,
    date_index,
    groups = NULL,
    counts = NULL,
    count_names_to = "count_variable",
    count_values_to = "count",
    date_names_to = "date_index",
    rm_na_dates = TRUE,
    interval = NULL,
    offset = NULL,
    complete_dates = FALSE,
    fill = 0L,
    ...
) {

    # handle defunct arguments
    if (...length()) {
        nms <- ...names()
        idx <- nms %in% c("na_as_group", "firstdate")
        if (any(idx)) {
            nms <- nms[idx]
            .stopf("As of incidence 2.0.0, `%s` is no longer a valid parameter name. See `help('incidence')` for supported parameters.", nms[1L])
        }
        if (is.null(nms))
            .stop("Too many arguments given.")

        nms <- nms[nms != ""]
        .stopf("`%s` is not a valid parameter", nms[1L])
    }

    # x must be a data frame
    if (!is.data.frame(x))
        .stop("`x` must be a data frame.")

    # count_names_to check
    assert_scalar_character(count_names_to, .subclass = "incidence2_error")

    # count_values_to check
    assert_scalar_character(count_values_to, .subclass = "incidence2_error")

    # date_names_to check
    assert_scalar_character(date_names_to, .subclass = "incidence2_error")

    # boolean checks
    assert_bool(rm_na_dates, .subclass = "incidence2_error")
    assert_bool(complete_dates, .subclass = "incidence2_error")

    # date_index checks
    length_date_index <- length(date_index)

    if (!(is.character(date_index) && length_date_index))
        .stop("`date_index` must be a character vector of length 1 or more.")

    if (anyDuplicated(date_index))
        .stop("`date_index` values must be unique.")

    if (!all(date_index %in% names(x)))
        .stop("Not all variables from `date_index` are present in `x`.")

    date_cols <- .subset(x, date_index)
    date_classes <- vapply(date_cols, function(x) class(x)[1L], "")
    if (length(unique(date_classes)) != 1L)
        .stop("`date_index` columns must be of the same class.")

    # error if date_index cols are vctrs_rcrd type
    is_vctrs_rcrd <- vapply(date_cols, inherits, TRUE, what = "vctrs_rcrd")
    if (any(is_vctrs_rcrd))
        .stop("vctrs_rcrd date_index columns are not currently supported.")

    # error if date_index cols are POSIXlt
    is_POSIXlt <- vapply(date_cols, inherits, TRUE, what = "POSIXlt")
    if (any(is_POSIXlt))
        .stop("POSIXlt date_index columns are not currently supported.")

    # counts checks
    if (!is.null(counts)) {
        if (!is.character(counts) || length(counts) < 1L)
            .stop("`counts` must be NULL or a character vector of length 1 or more.")

        if (anyDuplicated(counts))
            .stop("`counts` values must be unique.")

        if (length_date_index > 1L)
            .stop("If `counts` is specified `date_index` must be of length 1.")
    }

    if (!all(counts %in% names(x)))
        .stop("Not all variables from `counts` are present in `x`.")

    # group checks
    if (!(is.null(groups) || is.character(groups)))
        .stop("`groups` must be NULL or a character vector.")

    if (length(groups)) {
        # ensure groups are present
        if (!all(groups %in% names(x)))
            .stop("Not all variables from `groups` are present in `x`.")

        if (anyDuplicated(groups))
            .stop("`group` values must be unique.")

        # error if group cols are vctrs_rcrd type
        group_cols <- .subset(x, groups)
        is_vctrs_rcrd <- vapply(group_cols, inherits, TRUE, what = "vctrs_rcrd")
        if (any(is_vctrs_rcrd))
            .stop("vctrs_rcrd group columns are not currently supported.")

        # error if group cols are POSIXlt
        is_POSIXlt <- vapply(group_cols, inherits, TRUE, what = "POSIXlt")
        if (any(is_POSIXlt))
            .stop("POSIXlt group columns are not currently supported.")
    }

    # check interval and apply transformation across date index
    if (!is.null(interval)) {

        # check interval is valid length
        if (length(interval) != 1L)
            .stop("`interval` must be a character or integer vector of length 1.")

        # For numeric we coerce to integer and use as_period
        if (is.numeric(interval)) {
            n <- as.integer(interval)

            if (is.numeric(date_cols[[1L]])) {
                if (!is.null(offset))
                    .stop("`offset` can only be used with non-numeric date input.")
                x[date_index] <- lapply(x[date_index], as_int_period, n = n)
            } else {
                # coerce offset (do here rather than in grates for better easier error messaging)
                if (!is.null(offset)) {
                    if (inherits(offset, "Date"))
                        offset <- floor(as.numeric(offset))

                    if (!.is_scalar_whole(offset))
                        .stop("`offset` must be an integer or date of length 1.")
                } else {
                    offset <- 0L
                }
                x[date_index] <- lapply(x[date_index], as_period, n = n, offset = offset)
            }
        } else if (!is.null(offset)) {
            # offset only valid for numeric interval
            .stop("`offset` can only be used with a numeric (period) interval.")
        } else if (is.character(interval)) {
            # We are restrictive on intervals we allow to keep the code simple.
            # Users can always call grates functionality directly (reccomended)
            # and not use the `interval` argument which mainly a convenience
            # for new users and interactive work.
            interval <- tolower(interval)
            FUN <- switch(EXPR = interval,
                day         =,
                daily       = .as_date,
                week        =,
                weeks       =,
                weekly      =,
                isoweek     =,
                isoweeks    = as_isoweek,
                epiweek     =,
                epiweeks    = as_epiweek,
                month       =,
                months      =,
                monthly     =,
                yearmonth   = as_yearmonth,
                quarter     =,
                quarters    =,
                quarterly   =,
                yearquarter = as_yearquarter,
                year        =,
                years       =,
                yearly       = as_year,
                .stop(paste(
                    "`interval` must be one of:",
                    "    - an <integer> value;",
                    "    - 'day' or 'daily';",
                    "    - 'week(s)', 'weekly' or 'isoweek';",
                    "    - 'epiweek(s)';",
                    "    - 'month(s)', 'monthly', 'yearmonth';",
                    "    - 'quarter(s)', 'quarterly', 'yearquarter';",
                    "    - 'year(s)' or 'yearly'.",
                    sep = "\n"
                ))
            )
            x[date_index] <- lapply(x[date_index], FUN)
        } else {
            .stop("`interval` must be a character or integer vector of length 1.")
        }
    } else if (any(vapply(date_cols, inherits, TRUE, what = "POSIXct"))) {
        .warn(
            "<POSIXct> date_index columns detected. ",
            "Internally <POSIXct> objects are represented as seconds since the UNIX epoch and, in our experience, this level of granularity is not normally desired for aggregation. ",
            "For daily incidence consider converting the inputs to <Dates>. ",
            "This can be done prior to calling `incidence()` or, alternatively, by setting the argument `interval = 'day'` within the call itself."
        )

        if (complete_dates) {
            # TODO - Do we want/need a different error condition here?
            .stop(
                "`complete_dates = TRUE` is not compatible with <POSIXct> date_index columns due to the aforementioned warning. ",
                "If you wish to use <POSIXct> columns then set `complete_dates = FALSE` and call the `complete_dates()` function directly after the call to incidence."
            )
        }
    } else if (inherits(date_cols[[1L]], "Date")) {
        whole <- vapply(date_cols, \(x) .is_whole_or_NA(unclass(x)), TRUE)
        if (!all(whole)) {
            not_whole <- date_index[!whole]
            .warn(
                "Non-whole <Date> columns detected. ",
                "These can be confusing as they are displayed without the fractional element and can also cause oddities when plotting. ",
                "If you are interested in daily incidence, consider removing the fractional part. ",
                "This can be done prior to calling `incidence()` or, alternatively, by setting the argument `interval = 'day'` within the call itself."
            )
        }
    }

    # create data.table
    DT <- as.data.table(x)

    # generate name for date_index column (ensure coerced to DT before using setnames)
    nms <- names(date_index)
    if (!is.null(nms)) {
        if (length_date_index == 1L && nms != "") {
            setnames(DT, date_index, nms)
            date_index <- nms
        } else if (any(nms != "")) {
            new_names <- date_index
            new_names[nms != ""] <- nms
            setnames(DT, date_index, new_names)
            date_index <- new_names
        }
    }

    # generate names for group columns (ensure coerced to DT before using setnames)
    nms <- names(groups)
    if (!is.null(nms)) {
        if (length(groups) == 1L && nms != "") {
            setnames(DT, groups, nms)
            groups <- nms
        } else if (any(nms != "")) {
            new_names <- groups
            new_names[nms != ""] <- nms
            setnames(DT, groups, new_names)
            groups <- new_names
        }
    }

    # generate names for count columns (ensure coerced to DT before using setnames)
    nms <- names(counts)
    if (!is.null(nms)) {
        if (length(counts) == 1L && nms != "") {
            setnames(DT, counts, nms)
            counts <- nms
        } else if (any(nms != "")) {
            new_names <- counts
            new_names[nms != ""] <- nms
            setnames(DT, counts, new_names)
            counts <- new_names
        }
    }

    # switch behaviour depending on if counts are already present
    if (is.null(counts)) {

        # make from wide to long
        DT <- melt(
            DT,
            measure.vars = date_index,
            variable.name = count_names_to,
            value.name = date_names_to,
            variable.factor = FALSE
        )

        # filter out NA dates if desired
        if (rm_na_dates) {
            na_id <- is.na(.subset2(DT, date_names_to))
            DT <- DT[!na_id]
        }

        res <- DT[, .N, keyby = c(date_names_to, groups, count_names_to)]
        setnames(res, length(res), count_values_to)
    } else {
        nas_present <- vapply(.subset(DT,counts), anyNA, TRUE)
        if (any(nas_present)) {
            missing_names <- names(nas_present)[nas_present]
            .warnf(
                "`%s` contains NA values. Consider imputing these and calling `incidence()` again.",
                missing_names[1L]
            )
        }
        DT <- DT[, lapply(.SD, sum, na.rm = FALSE), keyby = c(date_index, groups), .SDcols = counts]
        res <- melt(DT, measure.vars = counts, variable.name = count_names_to, value.name = count_values_to)
        setnames(res, date_index, date_names_to)
    }

    # ensure we are nicely ordered
    setorderv(res, c(date_names_to, groups, count_names_to))

    # convert back to data frame
    setDF(res)

    # if no groups set to character(0L)
    if (is.null(groups))
        groups <- character(0L)

    # incidence object
    out <- tibble::new_tibble(
        x = res,
        date_index = date_names_to,
        count_variable = count_names_to,
        count_value = count_values_to,
        groups = groups,
        class = "incidence2"
    )

    # complete dates if flag set
    # TODO - this could be more efficient but this is safest for now
    if (complete_dates) {
        if (missing(fill))
            fill <- 0L
        assert_scalar_numeric(fill, .subclass = "incidence2_error")
        out <- complete_dates(out, fill = fill)
    } else if (!missing(fill)) {
        .stop("`fill` can only be given when `complete_dates = TRUE`.")
    }

    out
}


# -------------------------------------------------------------------------
#' @rdname incidence
#' @export
incidence_ <- function(
    x,
    date_index,
    groups = NULL,
    counts = NULL,
    count_names_to = "count_variable",
    count_values_to = "count",
    date_names_to = "date_index",
    rm_na_dates = TRUE,
    interval = NULL,
    offset = NULL,
    complete_dates = FALSE,
    ...
) {

    # date_index
    date_expr <- rlang::enquo(date_index)
    date_position <- tidyselect::eval_select(date_expr, data = x)
    length_date_index <- length(date_position)
    if (!length_date_index)
        .stop("`date_index` must be of length 1 or more.")
    date_index <- names(date_position)
    names(x)[date_position] <- date_index

    # counts
    counts_expr <- rlang::enquo(counts)
    counts_position <- tidyselect::eval_select(counts_expr, data = x)
    if (length(counts_position)) {
        if (length_date_index > 1L)
            .stop("If `counts` is specified `date_index` must be of length 1.")
        counts <- names(counts_position)
        names(x)[counts_position] <- counts
    } else if (!is.null(counts)) {
        .stop("`counts` must be NULL or a column in `x`.")
    }

    # group checks
    groups_expr <- rlang::enquo(groups)
    groups_position <- tidyselect::eval_select(groups_expr, data = x)
    if (length(groups_position)) {
        groups <- names(groups_position)
        names(x)[groups_position] <- groups
    }

    # ensure selected columns are distinct
    if (length(intersect(date_index, groups)))
        .stop("`date_index` columns must be distinct from `groups`.")

    if (length(intersect(date_index, counts)))
        .stop("`date_index` columns must be distinct from `counts`.")

    if (length(intersect(groups, counts)))
        .stop("`group` columns must be distinct from `counts`.")

    incidence(
        x = x,
        date_index = date_index,
        groups = groups,
        counts = counts,
        count_names_to = count_names_to,
        count_values_to = count_values_to,
        date_names_to = date_names_to,
        rm_na_dates = rm_na_dates,
        interval = interval,
        offset = offset,
        complete_dates = complete_dates,
        ...
    )

}
