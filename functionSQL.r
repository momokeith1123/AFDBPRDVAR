# require(readr)
#  This function read and sql query from the file
getSQL <- function(filepath){
  con = file(filepath, "r")
  sql.string <- ""
  
  while (TRUE){
    line <- readLines(con, n = 1)
    
    if ( length(line) == 0 ){
      break
    }
    
    line <- gsub("\\t", " ", line)
    
    if(grepl("--",line) == TRUE){
      line <- paste(sub("--","/*",line),"*/")
    }
    
    sql.string <- paste(sql.string, line)
  }
  
  close(con)
  return(sql.string)
}

#  
getShiftCurve <- function (sDate, sCur, sIndex, sqlchar)  {
  sql <- sqlchar
  sql <- gsub("pDate", sDate, sql)
  sql <- gsub("pCur", sCur, sql)
  sql <- gsub("pIndex", sIndex, sql)
  
  return(sql)
}