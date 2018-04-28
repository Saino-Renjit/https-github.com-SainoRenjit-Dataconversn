#' @title Excel file to JSON format
#'
#' @description Conversion of excel data to JSON format.
#'
#' @param input_file the path of a excel file to read the file from; Only one  file must be supplied
#' 
#' @import rjson
#' 
#' @import tools
#' 
#' @import gdata
#' 
#' @import readODS
#' 
#' @import xlsx
#' 
#' @return NULL
#'
#' @export excel2JSON
#' 
#' 
excel2JSON<-function(input_file)
{
  # input_file<-("/home/uvionics/Desktop/documents/data_conversion/featuers_data.ods")
  
  # library(rjson) # install.packages("rjson")
  # library(tools)
  
  # finds the  length of character in the source code path.
  #   # eg: > nchar(input_file) 
  #   #     [1] 51
  l<-nchar(input_file)
  
  # find out the file extension
  extension<-file_ext(input_file)
  
  # finds the  length of extension in the source code path.
  l_ext<-nchar(extension)
  
  
  # getting the source code path without the extension.
  # eg: > substr(csv_file,1, (l-l_ext))
  #    [1]  "/home/uvionics/Desktop/data_conversion/data.
  output<- substr(input_file,1, (l-l_ext))
  
  # check the extension is a excel file or not ,if it is not a excel file 
  # print("Invalid file format")
  if (extension=="ods"){
    ods_format<-read.ods(file = input_file, sheet = 1, formulaAsFormula = FALSE)
    JSON_format<-toJSON(ods_format) 
    write(JSON_format,paste(output,"json",sep = ''))
  }else if (extension=="xls") {
    csv_format<-read.xls (input_file, sheet = 1, header = TRUE)
    JSON_format<-toJSON(csv_format) 
    K<-write(JSON_format,paste(output,"json",sep = ''))
  }else if (extension=="xlsx") {
    csv_format<-read.xlsx(input_file, sheetName = "Sheet1")
    JSON_format<-toJSON(csv_format) 
    K<-write(JSON_format,paste(output,"json",sep = ''))
  } else {
    print("Invalid file format")
  }
  
}



#' @title csv file to JSON format
#'
#' @description Conversion of csv data to JSON format.
#'
#' @param input_file the path of a csv file to read the file from; Only one  file must be supplied
#'
#' @examples test1 <- as.character(sample(1:100,10))
#' @examples input_file <- tempfile(fileext = ".csv")
#' @examples writeLines(test1, input_file)
#' @examples csv2JSON(input_file = input_file)
#' 
#' @import rjson
#' 
#' @return NULL
#' 
#' @import utils
#' 
#' @import tools
#'
#' @export csv2JSON
#' 
csv2JSON<-function(input_file)
{
  # eg: input_file<-("/home/uvionics/Desktop/data_conversion/input_file.csv")
  
  # library(rjson) # install.packages("rjson")
  # library(tools)
  
  # finds the  length of character in the source code path.
  #   # eg: > nchar(input_file) 
  #   #     [1] 51
  l<-nchar(input_file)
  
  # find out the file extension
  extension<-file_ext(input_file)
  
  # finds the  length of extension in the source code path.
  l_ext<-nchar(extension)
  
  
  # getting the source code path without the extension.
  # eg: > substr(csv_file,1, (l-l_ext))
  #    [1]  "/home/uvionics/Desktop/data_conversion/data.
  output<- substr(input_file,1, (l-l_ext))
  
  # check the extension is a csv file or not ,if it is not a csv file 
  # print("This is not a csv file")
  
  if (extension!="csv"){
    print("Invalid file format")
  } else {
    #--Reads a csv file
    csv_format<-read.csv(file=input_file,header=T,stringsAsFactors = F) 
    
    #--Converts to JSON format
    JSON_format<-toJSON(csv_format) 
    
    #--write the Converted JSON file in the original source code directory itself.
    #  eg  : [1]  "/home/uvionics/Desktop/data_conversion/data.json
    write(JSON_format,paste(output,"json",sep = ''))
  }
}





#' @title JSON file to csv format
#'
#' @description Conversion of JSON data to csv format.
#'
#' @param input_file the path of a JSON file to read the file from; Only one  file must be supplied
#' 
#' @examples test1 <- '{"a":true, "b":false, "c":null}'
#' @examples input_file <- tempfile(fileext = ".json")
#' @examples writeLines(test1, input_file)
#' @examples JSON2csv(input_file = input_file)
#' 
#' @import rjson
#' 
#' @return NULL
#' 
#' @import utils
#' 
#' @import tools
#'
#' @export JSON2csv
#' 
#' 
JSON2csv<-function(input_file)
{
  # eg: input_file<-("/home/uvionics/Desktop/data_conversion/input_file.json")
  # library(rjson) # install.packages("rjson")
  # library(tools)
  
  # finds the  length of character in the source code path.
  #   # eg: > nchar(input_file) 
  #   #     [1] 54
  l<-nchar(input_file)
  
  # find out the file extension
  extension<-file_ext(input_file)
  
  # finds the  length of extension in the source code path.
  l_ext<-nchar(extension)
  
  
  # getting the source code path without the extension.
  # eg: > substr(csv_file,1, (l-l_ext))
  #    [1]  "/home/uvionics/Desktop/data_conversion/data.
  output<- substr(input_file,1, (l-l_ext))
  
  # check the extension is a JSON file or not ,if it is not a JSON file 
  # print("This is not a JSON file")
  
  if (extension!="json"){
    print("Invalid file format")
  } else {
    #--Reads a JSON file
    JSON_format<-fromJSON(file=input_file)
    
    #Find out the column number of JSON file
    n <- length(JSON_format)
    
    # Find out "NA"s and replace with  blank space(""). 
    for(i in 1:n){
      a<-which(JSON_format[[i]] == "NA")
      if(length(a) > 0){
        JSON_format[[i]][a]<-""
      }
    }
    
    #--Converts to csv format
    csv_format <- do.call("cbind", JSON_format)
    
    #--write the Converted csv file in the original source code directory itself.
    #  eg  : [1]  "/home/uvionics/Desktop/data_conversion/data.csv
    write.csv(csv_format,file=paste(output,"csv",sep = ''), row.names = FALSE)
  }
}

