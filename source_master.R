
# ---------------------------------------------------------------------------- #
# ---------------------------- code execution -------------------------------- #
# ---------------------------------------------------------------------------- #

current_dir <- getwd() # store current working dir
setwd(paste0(getwd(), '/data')) # set working directory to data
source('../functions.R') # load functions

# specify file name to be written
filename <- paste0('covid_', Sys.Date(), '.csv') 

# list all the files available in the current dir
file_avail <- list.files()

# if the file to be written doesn't exist in the data dir, then
# download and save updated data from the specified url, then remove older
if(!(filename %in% file_avail)){ # if file doesnt exist
  cat('\n\ndata download')
  download.file(url, filename) # download and write data
} else {
  cat('\n\ndata available')
}

# remove older files
to_rem <- file_avail[grep('covid_2021', file_avail)] # select only "covid_2021" files
file.remove(to_rem[which(!(to_rem %in% filename))]) # remove older files

dat0 <- read.csv(filename)  # read in new data
dat0$iso_code <- as.factor(dat0$iso_code) # cast iso_code into factor


# here we relate the number of cases to the number of deaths, everything per million
# and compute the ratio for a standardized measure

# compute death / cases out of 1000 ratio
dat0$new_cases_death_per_M_ratio <- dat0$new_deaths_per_million / dat0$new_cases_per_million 

# progress_bar
i <- 0  # counter
times <- length(vars) * length(isos)
pb <- txtProgressBar(min = 0, max = times, style = 3, width = 50, char = "=") 
cat('\n\ndata processing \n\n')

setwd(paste0(current_dir, '/figures'))

# loop over variables and countries
for(var_to_look_at in vars){
  for(iso_code in isos){
  
    # subset data
    dat <- dat0[dat0$iso_code == iso_code,]
    
    # extract two years
    dat_20 <- dat[substr(dat$date, 1, 4) == '2020',]
    dat_21 <- dat[substr(dat$date, 1, 4) == '2021',]
    
    # extract daily MM-DD sequence
    dat_20$daily <- substr(dat_20$date, 6, 10)
    dat_21$daily <- substr(dat_21$date, 6, 10)
    
    # produce 365 days MM-DD sequence
    daily <- substr(seq.Date(as.Date('2020-01-01'), as.Date('2020-12-31'), by = 1), 6,10)
    
    # reduce data to the variables of interest
    dat_20_red <- dat_20[,c('daily', var_to_look_at)]
    dat_21_red <- dat_21[,c('daily', var_to_look_at)]
    
    # join data by daily key
    dat_20_21 <- merge(dat_20_red, dat_21_red, by = 'daily', all = TRUE)
    
    # convert data into time series
    y20 <- ts(dat_20_21[,paste0(var_to_look_at,'.x')]) 
    y21 <- ts(dat_20_21[,paste0(var_to_look_at,'.y')]) 
    
    # jan - mar 2020 period for which there was registration is a zero
    y20[1:rev(which(is.na(y20)))[1]] <- 0
    
    # some values have shown to be negative
    # this is not possible but an error, therefore we set them to zero
    y20[y20 < 0] <- 0
    y21[y21 < 0] <- 0
    
    # set graphics parameters
    par(las = 2)
    dim_pic <- 800
    ylim <- range(y20, y21, na.rm = TRUE) # dynamic y plot scale
    
    # if we are considering the ratio, this cannot be grater than 1, hence 
    # we set it to the minimum between the observed maximum value and 1 
    if (length(grep('ratio', var_to_look_at)) > 0) ylim <- c(0,min(ylim[2], 1))
    
    # produce filename as: <ISO>_<VAR>_<DATE>.jpeg
    filename <- paste0(iso_code,'_', var_to_look_at,'_',as.character(Sys.Date()),'.jpeg')
    
    # start file rendering
    jpeg(file=filename, width = dim_pic*1.1, height = dim_pic)
    
    # plot data
    plot(y20, lwd = .25, lty = 2, xaxt = 'n', xlab = 'n', ylab = 'n', ylim = ylim) # 2020
    lines(y21, lwd = .25, col = 'red', lty = 2) # add 2021
    lines(smooth_line(y20, span = s), col = 'black') # add non parametric 2020
    lines(smooth_line(y21, span = s), col = 'red') # add non parametric 2021
    axis(side = 1, at = 1:nrow(dat_20_21), labels = dat_20_21$daily) # add axis labels
    
    # if the countries of interest is ITA we add a line on the 4 July which
    # is approximately the date in which the 2020 lockdown finished
    if(iso_code == 'ITA') abline(v = which(dat_20_21$daily == '06-04'), col = 'blue', lwd = 1/4)
    
    # add a vertical line in two weeks time so that we can track 14 days evolution
    abline(v = which(dat_20_21$daily == substr(Sys.Date()-14, 6,10)), col = 'red', lwd = 1/4, lty = 2)
    
    # add legend
    legend('topright', col = c('black','red'), legend = c('2020','2021'), lty = 1, bty = 'n')
    
    # add title to the pic
    title(paste(gsub('_', ' ', var_to_look_at), '2020 vs 2021 in', iso_code))
    
    # stop rendering
    dev.off()

    # update counter and progress bar 
    i <- i + 1
    setTxtProgressBar(pb, i)
    
  }
}

# the procedure saves a Rplots file, remove it
files <- list.files()
if('Rplots.pdf' %in% files) file.remove('Rplots.pdf')

# some iso code may not be tracked anymore, remove their old figures
files_to_check <- files[substr(files, 1, 4) == paste0(toupper(substr(files, 1, 3)),'_')]
files_to_remove <- files_to_check[!(substr(files_to_check, 1, 3) %in% isos)]
if(length(files_to_remove) > 0) file.remove(files_to_remove)

# remove old files
files_to_check <- files[grep('.jpeg', files)]
files_to_remove <- files_to_check[ - grep(Sys.Date(), files_to_check)]
file.remove(files_to_remove)

# return to main directory
setwd(current_dir)

cat('\n\ncode executed succesfully \n\n')
