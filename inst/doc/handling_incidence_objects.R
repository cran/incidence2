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
library(incidence2)

# load data
dat <- ebola_sim_clean$linelist

# generate the incidence object with 3 groups
inci <- incidence(dat, date_index = date_of_onset,
                  groups = c(gender, hospital, outcome),
                  interval = "1 week")
inci

# regroup to just two groups
inci %>% regroup(c(gender, outcome))

# drop all groups
inci %>% regroup()

## ----cumulate-----------------------------------------------------------------
inci %>% 
  cumulate() %>% 
  facet_plot(facet = hospital, n_breaks = 2)

## ----tidyverse----------------------------------------------------------------
library(dplyr)

# create incidence object
inci <-
  dat %>%
  incidence(
    date_index = date_of_onset,
    interval = "2 weeks",
    first_date = "2014-05-20",
    last_date = "2014-06-10",
    groups = c(hospital, gender)
  )

# filtering preserves class
x <-
    inci %>%
    filter(gender == "f", hospital == "Rokupa Hospital")
x
identical(class(x), class(inci))

# slice operations preserve class
x <-
    inci %>%
    slice_sample(n = 10)
x
identical(class(x), class(inci))

inci %>%
  slice(1, 5, 10) %>%
  class() %>% 
  identical(class(inci))

# mutate preserve class
x <-
    inci %>%
    mutate(future = bin_date + 999)
x
identical(class(x), class(inci))

# rename preserve class
x <-
  inci %>%
  rename(left_bin = bin_date)
identical(class(x), class(inci))

# select returns a tibble unless all date, count and group variables are preserved
inci %>% select(-1)

x <-
    inci %>%
    select(everything())
x

# Adding rows that are multiples of 2 weeks will maintain class
x <-
    inci %>%
    slice_head(n = 2) %>%
    mutate(bin_date = bin_date + 112) %>%
    bind_rows(inci)
x
identical(class(x), class(inci))


# Adding rows with dates that are not multiples of 2 weeks drops class
inci %>%
  slice_head(n = 2) %>%
  mutate(bin_date = bin_date + 30) %>%
  bind_rows(inci)

