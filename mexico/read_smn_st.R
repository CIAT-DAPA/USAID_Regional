
# Created by: Lizeth L ----------------------------------------------------
# Script to read weather stations from M�xico
# Date: July 2018

catalog <- read.csv("S:/observed/weather_station/mex-smn/new_2018/daily-raw/catalog_daily.csv", header=T)
files <- paste0("http://smn.cna.gob.mx/tools/RESOURCES/Diarios/",catalog[,1],".txt")
var <- c("evap", "tmax", "tmin")
dir_out <- "S:/observed/weather_station/mex-smn/new_2018/daily-raw"

read_st_mex <- function(files, var, dir_out, cod_st){
  tryCatch({
 
  raw_dat <- readLines(url(files))
   
  if(length(raw_dat)>20){ 
    
  info_st <- raw_dat[1:20]
  info_st <- info_st[info_st!=" "]
  d_ini = matrix(NA,length(raw_dat)-20,5)

     for (i in 21:length(raw_dat)){
    
    if(length(strsplit(raw_dat[i],split="\\s+")[[1]])==5){
      
      d_ini[i-20,] = strsplit(raw_dat[i],split="\\s+")[[1]]
    }
    
  }  
  
  cat(info_st[4],"\n")
  dates <- format(as.Date(d_ini[,1], format = "%d/%m/%Y"),"%Y%m%d")
  d_ini[d_ini=="Nulo"] <- NA
  
   for (v in 1:length(var)) {
     d_write = as.data.frame(cbind("Date"= dates,"Value" = d_ini[,v+2]))
     d_write = d_write[!is.na(d_write[,1]),]

    dir.create(paste0(dir_out,"/",var[v],"-per-station"),showWarnings = F)
    write.table(d_write,paste0(dir_out,"/",var[v],"-per-station/",cod_st,"_raw_",var[v],".txt"),quote = F,row.names = F, sep = "\t")
    
  }
  }
 
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) 
}

lapply(1:length(files), function (k) read_st_mex(files[k], var, dir_out , cod_st = catalog[k,1]))
