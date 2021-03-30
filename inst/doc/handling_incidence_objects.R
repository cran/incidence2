## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.width = 7,
  fig.height = 5
)

## ----regroup------------------------------------------------------------------
library(outbreaks)
library(dplyr)
library(incidence2)

# load data
dat <- ebola_sim_clean$linelist

# generate the incidence object with 3 groups
inci <- incidence(dat, date_index = date_of_onset,
                  groups = c(gender, hospital, outcome),
                  interval = "week")
inci

# regroup to just two groups
inci %>% regroup(c(gender, outcome))

# drop all groups
inci %>% regroup()

## ----cumulate-----------------------------------------------------------------
inci %>% 
  regroup(hospital) %>% 
  cumulate() %>% 
  facet_plot(n_breaks = 4)

## ----keep---------------------------------------------------------------------
inci %>% keep_first(3)

inci %>% keep_last(3)

## ----tidyverse----------------------------------------------------------------
library(dplyr)

# create incidence object
inci <-
  dat %>%
  incidence(
    date_index = date_of_onset,
    interval = "week",
    groups = c(hospital, gender)
  )

# filtering preserves class
inci %>%  filter(gender == "f", hospital == "Rokupa Hospital")

# slice operations preserve class
inci %>% slice_sample(n = 10)

inci %>%  slice(1, 5, 10)

# mutate preserve class
inci %>%  mutate(future = date_index + 999)

# rename preserve class
inci %>%  rename(left_bin = date_index)


# select returns a tibble unless all date, count and group variables are preserved
inci %>% select(-1)

inci %>% select(everything())


