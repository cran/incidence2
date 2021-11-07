## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.width = 7,
  fig.height = 5
)

## ----data---------------------------------------------------------------------
library(outbreaks)
library(incidence2)
dat <- ebola_sim_clean$linelist
class(dat)
str(dat)

## ----daily, fig.height = 5, dpi = 90------------------------------------------
daily <- incidence(dat, date_index = date_of_onset)
daily
summary(daily)
plot(daily)

## ----sevenday-----------------------------------------------------------------
# 7 day incidence
seven <- incidence(dat, date_index = date_of_onset, interval = 7)
seven
plot(seven, color = "white")

## ----weekly-------------------------------------------------------------------
# year-weekly, starting on Monday (ISO week, default)
weekly <- incidence(dat, date_index = date_of_onset, interval = "week")
plot(weekly, color = "white")

## ----otherinterval------------------------------------------------------------
# bi-weekly, based on first day in data
biweekly <- incidence(dat, date_index = date_of_onset, interval = "2 weeks")
plot(biweekly, color = "white")
# monthly
monthly <- incidence(dat, date_index = date_of_onset, interval = "month")
plot(monthly, color = "white")
# quarterly
quarterly <- incidence(dat, date_index = date_of_onset, interval = "quarter")
plot(quarterly, color = "white")
# year
yearly <- incidence(dat, date_index = date_of_onset, interval = "year")
plot(yearly, color = "white", n_breaks = 2)

## ----gender-------------------------------------------------------------------
weekly_grouped <- incidence(dat, date_of_onset, interval = "week", groups = gender)
weekly_grouped
summary(weekly_grouped)
# A singular plot
plot(weekly_grouped, fill = gender, color = "white")
# a multi-facet plot
facet_plot(weekly_grouped, fill = gender, n_breaks = 5, angle = 45, color = "white")

## ----outcome_hospital---------------------------------------------------------
inci <- incidence(dat, date_of_onset, interval = "week", groups = c(outcome, hospital))
facet_plot(inci, facets = hospital, fill = outcome, nrow = 3, n_breaks = 5, angle = 45)

