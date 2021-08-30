## Quick Covid-19 visualisation project

This project has been built for personal usage to provide robustness against the click-bait news we read every single day.

Within this project we automate the covid-19 data download by a script. Moreover, we produce a quick visualisation of the annual trend by superimposing a non parametric fit according to a span which regulates how local the estimation is. All the results are saved into the `figures` folder with the format `<COUNTRY_ISO_CODE>_<VARIABLE>_<DATE>.jpeg`

## Analysis settings
The file `settings.R` contains the parameters you may wish to change. In particular:
- the `url` to download the data from (recall that the  script has been built for this particular project, hence if you change the source, you may need to change the script as well)
- the `isos` code related to the countries you are interested in
- the `vars` related to the variables name you are interested in

## Execution

From the project folder, you can run the `main.R` which will load the settings specified in `settings.R` and run the source code `source_master.R`. The latter, makes usage of the `functions.R` script to define the functions useful within the analysis.

- open the terminal
- switch to the project folder `cd <project_folder_name>` 
- run the main script `Rscript main.R`
- inspect the results in the folder `cd ./figures`



## Data Source
The covid-19 data can be downloaded from <https://covid.ourworldindata.org/data/owid-covid-data.csv> and the code is automated for this particular data set.



## R installation instruction

#### R
The whole project is coded in `R`. R is an open source language for statistical analysis.

On a Linux Debian based machine, R can be easily installed from the terminal by running
`sudo apt-get install r-base`

#### RStudio
*The RStudio IDE is a set of integrated tools designed to help you be more productive with R and Python. It includes a console, syntax-highlighting editor that supports direct code execution, and a variety of robust tools for plotting, viewing history, debugging and managing your workspace.*
You can download `RStudio` from <https://www.rstudio.com/products/rstudio/download/#download> and install it by running the executable.

