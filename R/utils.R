.stopf_argument <- function(fmt, ..., .call = sys.call(-1L)) {
    msg <- sprintf(fmt, ...)
    stop(errorCondition(msg, class = error_types$argument, call = .call[1L]))
}

.stop_argument <- function(msg, .call = sys.call(-1L)) {
    stop(errorCondition(msg, class = error_types$argument, call = .call[1L]))
}

.stop_suggested <- function(msg, .call = sys.call(-1L)) {
    stop(errorCondition(msg, class = error_types$suggested, call = .call[1L]))
}

warnf <- function(fmt, ..., .use_call = TRUE, .call = sys.call(-1L)) {
    .call <- if (isTRUE(.use_call)) .call[1L] else NULL
    msg <- sprintf(fmt, ...)
    err <- simpleWarning(msg, .call)
    warning(err)
}

.is_scalar_whole <- function(x, tol = .Machine$double.eps^0.5) {
    if (is.integer(x) && length(x) == 1L)
        return(TRUE)
    if (is.double(x) && length(x) == 1L && (abs(x - round(x)) < tol))
        return(TRUE)
    FALSE
}

.as_date <- function(x, ...) {
    if (inherits(x, "POSIXct")) {
        tz <- attr(x, "tzone")
        if (is.null(tz))
            tz <- "" # current time zone (used for POSIXt transformations)
        out <- as.Date(x, tz = tz)
    } else {
        out <- as.Date(x, ...)
    }

    # floor values for integerish dates
    out <- floor(as.numeric(out))
    .Date(out)
}

.grates_scale <- function(x) {
    if (inherits(x, "grates_yearweek_monday"))
        return(grates::scale_x_grates_yearweek_monday)
    if (inherits(x, "grates_yearweek_tuesday"))
        return(grates::scale_x_grates_yearweek_tuesday)
    if (inherits(x, "grates_yearweek_wednesday"))
        return(grates::scale_x_grates_yearweek_wednesday)
    if (inherits(x, "grates_yearweek_thursday"))
        return(grates::scale_x_grates_yearweek_thursday)
    if (inherits(x, "grates_yearweek_friday"))
        return(grates::scale_x_grates_yearweek_friday)
    if (inherits(x, "grates_yearweek_saturday"))
        return(grates::scale_x_grates_yearweek_saturday)
    if (inherits(x, "grates_yearweek_sunday"))
        return(grates::scale_x_grates_yearweek_sunday)
    if (inherits(x, "grates_epiweek"))
        return(grates::scale_x_grates_epiweek)
    if (inherits(x, "grates_isoweek"))
        return(grates::scale_x_grates_yearweek_isoweek)
    if (inherits(x, "grates_yearmonth"))
        return(grates::scale_x_grates_yearmonth)
    if (inherits(x, "grates_yearquarter"))
        return(grates::scale_x_grates_yearquarter)
    if (inherits(x, "grates_year"))
        return(grates::scale_x_grates_year)
    if (inherits(x, "grates_period"))
        return(grates::scale_x_grates_period)
}
