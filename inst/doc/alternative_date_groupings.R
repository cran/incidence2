## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.width = 7,
  fig.height = 5
)

## -----------------------------------------------------------------------------
library(incidence2)
library(clock)
library(zoo)

# data included in incidence2 but obtained via the covidregionaldata package
data("covidregionaldataUK")
dat <- covidregionaldataUK

## -----------------------------------------------------------------------------
clock_month_inci <- 
  build_incidence(
    dat,
    date_index = date,
    groups = region,
    counts = ends_with("new"),
    FUN = function(x) calendar_narrow(as_year_month_day(x), precision = "month")
  )

clock_month_inci

## -----------------------------------------------------------------------------
zoo_month_inci <- 
  build_incidence(
    dat,
    date_index = date,
    groups = region,
    counts = ends_with("new"),
    FUN = as.yearmon
  )

zoo_month_inci


## -----------------------------------------------------------------------------
# we can compare this to the grates implementation
grates_month_inci <- 
  incidence(
    dat,
    date_index = date,
    groups = region,
    counts = ends_with("new"),
    interval = "month"
  )

grates_month_inci

# and check they are all "equal" ...
clock_month_inci$date_index <- as.Date(calendar_widen(clock_month_inci$date_index, "day"))
zoo_month_inci$date_index <- as.Date(zoo_month_inci$date_index)
grates_month_inci$date_index <- as.Date(grates_month_inci$date_index)

identical(
  as.data.frame(clock_month_inci),
  as.data.frame(zoo_month_inci)
)

identical(
  as.data.frame(grates_month_inci),
  as.data.frame(clock_month_inci)
)


