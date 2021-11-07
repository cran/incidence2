## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.width = 7,
  fig.height = 5
)

## ----data, message = FALSE----------------------------------------------------
library(outbreaks)
library(incidence2)

dat <- ebola_sim_clean$linelist
str(dat)

i <- incidence(dat, date_of_onset, interval = 7, groups = c(gender, hospital))
i

## ---- plot1-------------------------------------------------------------------
plot(i)

## ---- plot2-------------------------------------------------------------------
plot(i, color = "white")

## ---- fill--------------------------------------------------------------------
plot(i, fill = gender)
plot(i, fill = hospital, legend = "bottom")
ii <- regroup(i)
plot(ii, fill = "red", color = "white")

## ---- rotateandformat---------------------------------------------------------
plot(i, angle = 45)

## ---- epiet-------------------------------------------------------------------
i_epiet <- incidence(dat[160:180, ], date_index = date_of_onset)
plot(i_epiet, color = "white", show_cases = TRUE, angle = 45, size = 10, n_breaks = 20)

## ---- facets------------------------------------------------------------------
facet_plot(i, facets = gender, n_breaks = 3)
facet_plot(i, facets = hospital, fill = gender, n_breaks = 3, nrow = 4)
ii <- regroup(i, gender)
facet_plot(ii, facets = gender, fill = "grey", color = "white")

## ---- vibrant,   fig.height = 8-----------------------------------------------
par(mfrow = c(2, 1), mar = c(4,2,1,1))
barplot(1:6, col = vibrant(6))
barplot(1:20, col = vibrant(20))

## ---- muted, fig.height = 8---------------------------------------------------
par(mfrow = c(2,1), mar = c(4,2,1,1))
barplot(1:9, col = muted(9))
barplot(1:20, col = muted(20))

## ---- palettes----------------------------------------------------------------
ih <- regroup(i, hospital)
plot(ih, fill = hospital, col_pal = rainbow, n_breaks = 3) # see ?rainbow
ig <- regroup(i, gender)
plot(ig, fill = gender, col_pal = cm.colors)   # see ?cm.colors

