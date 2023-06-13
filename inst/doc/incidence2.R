## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.width = 7,
  fig.height = 5
)

## -----------------------------------------------------------------------------
library(outbreaks)  # for the underlying data
library(ggplot2)    # For custom plotting later
library(incidence2) 

ebola <- ebola_sim_clean$linelist
str(ebola)
covid <- covidregionaldataUK
str(covid)

## ----fig.height = 5, dpi = 90-------------------------------------------------
daily <- incidence(ebola, date_index = "date_of_onset")
daily
plot(daily)

## -----------------------------------------------------------------------------
# isoweek incidence
weekly_ebola <- transform(ebola, date_of_onset = as_isoweek(date_of_onset))
inci <- incidence(weekly_ebola, date_index = "date_of_onset")
inci
plot(inci, border_colour = "white")

## -----------------------------------------------------------------------------
# isoweek incidence using the interval parameter
inci2 <- incidence(ebola, date_index = "date_of_onset", interval = "isoweek")
inci2

# check equivalent
identical(inci, inci2)

## -----------------------------------------------------------------------------
inci_by_gender <- incidence(
    ebola,
    date_index = "date_of_onset",
    groups = "gender",
    interval = "isoweek"
)
inci_by_gender

## -----------------------------------------------------------------------------
plot(inci_by_gender, border_colour = "white", angle = 45)
plot(inci_by_gender, border_colour = "white", angle = 45, fill = "gender")

## -----------------------------------------------------------------------------
grouped_inci <- incidence(
    ebola,
    date_index = c(
        onset = "date_of_onset",
        infection = "date_of_infection"
    ), 
    interval = "isoweek",
    groups = "gender"
)
grouped_inci

## -----------------------------------------------------------------------------
plot(grouped_inci, angle = 45, border_colour = "white")
plot(grouped_inci, angle = 45, border_colour = "white", fill = "count_variable")

## -----------------------------------------------------------------------------
monthly_covid <- 
    covid |> 
    subset(!region %in% c("England", "Scotland", "Northern Ireland", "Wales")) |> 
    incidence(
        date_index = "date",
        groups = "region",
        counts = c("cases_new"),
        interval = "yearmonth"
    )
monthly_covid
plot(monthly_covid, nrow = 3, angle = 45, border_colour = "white")

## ---- fig.height=3------------------------------------------------------------
dat <- ebola[160:180, ]
i_epiet <- incidence(dat, date_index = "date_of_onset", date_names_to = "date")
plot(i_epiet, color = "white", show_cases = TRUE, angle = 45, n_breaks = 10)
i_epiet2 <- incidence(
    dat, date_index = "date_of_onset",
    groups = "gender", date_names_to = "date"
)
plot(
    i_epiet2, show_cases = TRUE,
    color = "white", angle = 45, n_breaks = 10, fill = "gender"
)

## -----------------------------------------------------------------------------
# generate an incidence object with 3 groups
x <- incidence(
    ebola,
    date_index = "date_of_onset",
    interval = "isoweek",
    groups = c("gender", "hospital", "outcome")
)

# regroup to just one group
xx <- regroup(x, c("gender", "outcome"))
xx

# drop all groups
regroup(x)

## -----------------------------------------------------------------------------
y <- regroup(x, "hospital")
y <- cumulate(y)
y
plot(y, angle = 45, nrow = 3)

## -----------------------------------------------------------------------------
inci <- incidence(
    ebola,
    date_index = "date_of_onset",
    interval = "isoweek",
    groups = c("hospital", "gender")
)

keep_first(inci, 3)
keep_last(inci, 3)

## -----------------------------------------------------------------------------
keep_peaks(inci)

## -----------------------------------------------------------------------------
dat <- data.frame(
    dates = as.Date(c("2020-01-01", "2020-01-04")),
    gender = c("male", "female")
)
i <- incidence(dat, date_index = "dates", groups = "gender")
i
complete_dates(i)

## ----subsetting---------------------------------------------------------------

# filtering preserves class
subset(inci, gender == "f" & hospital == "Rokupa Hospital")
inci[c(1L, 3L, 5L), ]

# Adding columns preserve class
inci$future <- inci$date_index + 999L
inci

# rename preserve class
names(inci)[names(inci) == "date_index"] <- "isoweek"
inci

# select returns a data frame unless all date, count and group variables are
# preserved in the output
str(inci[,-1L])
inci[, -6L]

## -----------------------------------------------------------------------------
# the name of the date_index variable of x
get_date_index_name(inci)

# alias for `get_date_index_name()`
get_dates_name(inci)

# the name of the count variable of x
get_count_variable_name(inci)

# the name of the count value of x
get_count_value_name(inci)

# the name(s) of the group variable(s) of x
get_group_names(inci)

# list containing date_index variable of x
str(get_date_index(inci))

# alias for get_date_index
str(get_dates(inci))

# list containing the count variable of x
str(get_count_variable(inci))

# list containing count value of x
str(get_count_value(inci))

# list of the group variable(s) of x
str(get_groups(inci)) 

