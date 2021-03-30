## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.width = 7,
  fig.height = 5
)

## ---- data--------------------------------------------------------------------
library(outbreaks)
library(incidence2)
library(magrittr)

dat <- ebola_sim_clean$linelist
str(dat)

i <- incidence(dat, date_index = date_of_onset, interval = 7,
               groups = c(gender, hospital))
i

## ---- plot1-------------------------------------------------------------------
i %>% plot()

## ---- plot2-------------------------------------------------------------------
i %>% plot(color = "white")

## ---- fill--------------------------------------------------------------------
i %>% plot(fill = gender)
i %>% plot(fill = hospital, legend = "bottom")
i %>% regroup() %>% plot(fill = "red", color = "white")

## ---- rotateandformat---------------------------------------------------------
i %>% plot(angle = 45)

## ---- epiet-------------------------------------------------------------------
i_epiet <- incidence(dat[160:180, ], date_index = date_of_onset)
i_epiet %>% plot(color = "white", show_cases = TRUE, angle = 45, size = 10, n_breaks = 20)

## ---- facets------------------------------------------------------------------
i %>% facet_plot(facets = gender, n_breaks = 3)
i %>% facet_plot(facets = hospital, fill = gender, n_breaks = 3, nrow = 4)
i %>% regroup(gender) %>% facet_plot(facets = gender, fill = "grey", color = "white")

## ---- vibrant,   fig.height = 8-----------------------------------------------
par(mfrow = c(2, 1), mar = c(4,2,1,1))
barplot(1:6, col = vibrant(6))
barplot(1:20, col = vibrant(20))

## ---- muted, fig.height = 8---------------------------------------------------
par(mfrow = c(2,1), mar = c(4,2,1,1))
barplot(1:9, col = muted(9))
barplot(1:20, col = muted(20))

## ---- palettes----------------------------------------------------------------
i %>% regroup(hospital) %>% plot(fill = hospital, col_pal = rainbow, n_breaks = 3) # see ?rainbow
i %>% regroup(gender) %>% plot(fill = gender, col_pal = cm.colors)   # see ?cm.colors

