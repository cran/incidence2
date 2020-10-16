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
#  remotes::install_github("reconhub/incidence2", build_vignettes = TRUE)

## ----data---------------------------------------------------------------------
library(outbreaks)
library(incidence2)

dat <- ebola_sim_clean$linelist
class(dat)
str(dat)

## ----incid1-------------------------------------------------------------------
i <- incidence(dat, date_index = date_of_onset)
i
summary(i)
plot(i)

## ----interv-------------------------------------------------------------------

# weekly, starting on Monday (ISO week, default)
i_weekly <- incidence(dat, date_index = date_of_onset, interval = "1 week")
plot(i_weekly)

# bi-weekly, starting on Saturday
i_biweekly <- incidence(dat, date_index = date_of_onset, interval = "2 saturday weeks")
plot(i_biweekly, color = "white")

## monthly
i_monthly <- incidence(dat, date_index = date_of_onset, interval = "1 month")
plot(i_monthly, color = "white")

## ----gender-------------------------------------------------------------------
i_weekly_sex <- incidence(dat, date_index = date_of_onset,
                     interval = "1 week", groups = gender)
i_weekly_sex
summary(i_weekly_sex)

# A singular plot
plot(i_weekly_sex, fill = gender)

# a multi-facet plot
facet_plot(i_weekly_sex, fill = gender, color = "white", )

## ----outcome_hospital---------------------------------------------------------
inci <- incidence(dat, date_index = date_of_onset,
                     interval = "1 week", groups = c(outcome, hospital, gender))
inci %>% 
  facet_plot(facets = hospital, fill = outcome, n_breaks = 4, nrow = 3)

