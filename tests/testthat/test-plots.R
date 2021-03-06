# setup -------------------------------------------------------------------
save_png <- function(code, width = 400, height = 400) {
  path <- tempfile(fileext = ".png")
  png(path, width = width, height = height)
  on.exit(dev.off())
  print(code)
  path
}

expect_snapshot_plot <- function(name, code) {
  skip_if_not_installed("ggplot2", "2.0.0")
  skip_on_os(c("windows", "mac"))
  skip_on_ci()
  path <- save_png(code)
  expect_snapshot_file(path, paste0(name, ".png"))
}

load_dat <- function() {
  skip_if_not_installed("outbreaks")
  outbreaks::ebola_sim_clean$linelist
}


# tests -------------------------------------------------------------------

test_that("day plotting works", {
  dat <- load_dat()
  x <- incidence(dat, date_index = date_of_infection)
  expect_snapshot_plot("day", plot(x, color = NA))
})


test_that("multi-day plotting works", {
  dat <- load_dat()
  x <- incidence(dat, date_index = date_of_infection, interval = 17)
  expect_snapshot_plot("multiday", plot(x))
})


test_that("grouped week plotting works", {
  dat <- load_dat()
  x <- incidence(dat, date_index = date_of_infection, interval = "week", groups = "gender")
  expect_snapshot_plot("week_grouped", plot(x, fill = gender, n.breaks = 5))
})


test_that("grouped month plot works", {
  dat <- load_dat()
  x <- incidence(dat, date_index = date_of_infection, interval = "2 months", groups = "gender")
  expect_snapshot_plot("month_grouped", facet_plot(x, centre_dates=FALSE, n.breaks = 7, angle = 45))
})


test_that("grouped quarter plot works", {
  dat <- load_dat()
  x <- incidence(dat, date_index = date_of_infection, interval = "quarter", groups = c(gender, hospital), na_as_group = FALSE)
  expect_snapshot_plot("quarterly_grouped", facet_plot(x, n.breaks = 6, angle = 45, facets = gender, fill = hospital))
})


test_that("integer plotting works", {
  dat <- data.frame(dates = rep(1:10, times = 1:10))
  x <- incidence(dat, date_index = dates)
  expect_snapshot_plot("integer", plot(x, color = NA, n.breaks = 10))
})


test_that("double plotting works", {
  dat <- data.frame(dates = as.double(rep(1:10, times = 1:10)))
  x <- incidence(dat, date_index = dates)
  expect_snapshot_plot("double", plot(x, color = NA, n.breaks = 10))
})
