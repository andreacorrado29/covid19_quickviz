# settings.R

# ---------------------------------------------------------------------------- #
# ------------------------------- settings ----------------------------------- #
# ---------------------------------------------------------------------------- #

# set url for data source
url <- 'https://covid.ourworldindata.org/data/owid-covid-data.csv' 

# select countries of interest according to the ISO code
isos <- c('ITA','GBR', 'AUS', 'IRL') 

# select variables to inspect
vars <- c(
  'new_deaths_per_million',
  'new_cases_per_million',
  'new_cases_death_per_M_ratio'
)

# define value of the span to be used in non parametric fit (0, 1]
s <- .25

