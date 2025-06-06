.stop <- function(..., .call = sys.call(-1L)) {
    msg <- if (...length() == 1L) ..1 else paste0(...)
    condition <- errorCondition(msg, class = "incidence2_error", call = .call[1L])
    stop(condition)
}

.stopf <- function(fmt, ..., .call = sys.call(-1L)) {
    msg <- sprintf(fmt, ...)
    condition <- errorCondition(msg, class = "incidence2_error", call = .call[1L])
    stop(condition)
}

.warnf <- function(fmt, ..., .call = sys.call(-1L)) {
    msg <- sprintf(fmt, ...)
    condition <- warningCondition(msg, class = "incidence2_warning", call = .call[1L])
    warning(condition)
}

.warn <- function(..., .call = sys.call(-1L)) {
    msg <- if (...length() == 1L) ..1 else paste0(...)
    condition <- warningCondition(msg, class = "incidence2_warning", call = .call[1L])
    warning(condition)
}

.is_scalar_whole <- function(x, tol = .Machine$double.eps^0.5) {
    if (is.integer(x) && length(x) == 1L)
        return(TRUE)
    if (is.double(x) && length(x) == 1L && (abs(x - round(x)) < tol))
        return(TRUE)
    FALSE
}

.is_whole_or_NA <- function (x, tol = .Machine$double.eps^0.5) {
    if (is.integer(x))
        return(TRUE)
    if (is.double(x) && all(abs(x - round(x)) < tol | is.na(x)))
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
    if (inherits(x, "grates_int_period"))
        return(grates::scale_x_grates_int_period)
}
