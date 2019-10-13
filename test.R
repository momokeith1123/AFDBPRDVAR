## Load dependencies
if (!require('openxlsx')) install.packages('openxlsx')
library('openxlsx')

## Split data apart by a grouping variable;
##   makes a named list of tables
dat <- split(mtcars, mtcars$cyl)
dat

dat <- HVAR_RGRP

## Create a blank workbook
wb <- createWorkbook()

## Loop through the list of split tables as well as their names
##   and add each one as a sheet to the workbook
Map(function(data, name){
  
  addWorksheet(wb, name)
  writeData(wb, name, data)
  
}, dat, names(dat))


## Save workbook to working directory
saveWorkbook(wb, file = "example2.xlsx", overwrite = TRUE)