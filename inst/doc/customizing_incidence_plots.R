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

dat <- ebola_sim_clean$linelist
str(dat)

i <- incidence(dat, date_index = date_of_onset, interval = 7,
               groups = c(gender, hospital))

## ---- plot1-------------------------------------------------------------------
i %>% plot()

## ---- plot2-------------------------------------------------------------------
i %>% plot(color = "white")

## ---- fill--------------------------------------------------------------------
i %>% plot(fill = gender)
i %>% plot(fill = hospital, legend = "bottom")
i %>% plot(fill = "red")

## ---- rotateandformat---------------------------------------------------------
i %>% plot(group_labels = FALSE, 
           format = "%a %d %B %Y",
           angle = 45)

## ---- epiet-------------------------------------------------------------------
i_epiet <- incidence(dat[160:180, ], date_index = date_of_onset)
i_epiet %>% plot(color = "white", show_cases = TRUE,
                 coord_equal = TRUE, angle = 45, size = 12)

## ---- facets------------------------------------------------------------------
i %>% facet_plot(facets = gender, n_breaks = 3)
i %>% facet_plot(facets = hospital, fill = gender, n_breaks = 3, nrow = 4)
i %>% facet_plot(facets = gender, fill = "grey")

## ---- centreing---------------------------------------------------------------
x <- incidence(dat, 
               date_index = date_of_onset,
               first_date = as.Date("2014-10-01") - 25,
               last_date = as.Date("2014-10-01") + 25,
               groups = hospital,
               interval = "week") 
  plot(x, fill = hospital, color = "black", n_breaks = nrow(x), 
       angle = 45, size = 12, centre_ticks = TRUE, legend = "top")

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

