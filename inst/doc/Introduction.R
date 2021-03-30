## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.width = 7,
  fig.height = 5
)

## ---- eval=FALSE--------------------------------------------------------------
#  install.packages("incidence2")

## ---- eval=FALSE--------------------------------------------------------------
#  if (!require(remotes)) {
#    install.packages("remotes")
#  }
#  remotes::install_github("reconverse/incidence2", build_vignettes = TRUE)

## ----data---------------------------------------------------------------------
library(outbreaks)
library(incidence2)

dat <- ebola_sim_clean$linelist
class(dat)
str(dat)

## ----incid1, fig.height = 5, dpi = 90-----------------------------------------
i <- incidence(dat, date_index = date_of_onset)
i
summary(i)
plot(i)

## ----i_7----------------------------------------------------------------------

# 7 day incidence
i_7 <- incidence(dat, date_index = date_of_onset, interval = 7)
i_7
plot(i_7, color = "white")

## ----iweekly------------------------------------------------------------------

# year-weekly, starting on Monday (ISO week, default)
i_weekly <- incidence(dat, date_index = date_of_onset, interval = "week")
plot(i_weekly, color = "white")


## ----ilarger------------------------------------------------------------------
# bi-weekly, based on first day in data
i_biweekly <- incidence(dat, date_index = date_of_onset, interval = "2 weeks")
plot(i_biweekly, color = "white")
# year-monthly
i_monthly <- incidence(dat, date_index = date_of_onset, interval = "month")
plot(i_monthly, color = "white")
# year-quarterly
i_quarterly <- incidence(dat, date_index = date_of_onset, interval = "quarter")
plot(i_quarterly, color = "white")
# year-quarterly
i_year <- incidence(dat, date_index = date_of_onset, interval = "year")
plot(i_year, color = "white")

## ----gender-------------------------------------------------------------------
i_weekly_sex <- incidence(dat, date_index = date_of_onset,
                     interval = "week", groups = gender)
i_weekly_sex
summary(i_weekly_sex)

# A singular plot
plot(i_weekly_sex, fill = gender, color = "white")

# a multi-facet plot
facet_plot(i_weekly_sex, fill = gender, n_breaks = 5, angle = 45, color = "white")

## ----outcome_hospital---------------------------------------------------------
inci <- incidence(dat, date_index = date_of_onset,
                     interval = "week", groups = c(outcome, hospital, gender))
facet_plot(inci, facets = hospital, fill = outcome, nrow = 3, n_breaks = 5, angle = 45)

