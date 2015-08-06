# Install function for packages (automatic)
packages <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}


# Required packages
packages(plyr)
packages(RCurl)
packages(RJSONIO)
packages(bitops)
packages(httr)
library(RCurl)
library(RJSONIO)
library(httr)
location <- modelerData$%%identif_address%%
#Generate Token
url = "https://arcgis.com/sharing/rest/generateToken"
data = list('username'= "%%username%%",
            'password'= "%%pwd%%",
            'referer' = 'http://arcgis.com',
            'expiration' = 1209600,
            'f'= 'json')
r<-POST(url,body = data)
content(r)
x <- fromJSON(content(r))
token<-x$token
print(location)
 root <- "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find"
  u <- paste(root,  "?text=",location, "&token=", token, "&f=json", sep = "")
u <- gsub(' ','%20',u) #Encode URL Parameters
print(u)
require("plyr")
doc <- aaply(u,1,getURL)
json <- alply(doc,1,fromJSON,simplify = FALSE)
coord = laply(json,function(x) {
   
      lat <- x$locations[[1]]$feature$geometry$x
    lng <- x$locations[[1]]$feature$geometry$y
      return(c(lat,lng))
   
  })

if (is.null(nrow(coord))){
lng<-c(coord[1])
lat<-c(coord[2]) } else{
lng<-c(coord[,1])
lat<-c(coord[,2])}

modelerData<-cbind(modelerData,lat)
print(modelerData)
var1<-c(fieldName="Latitude",fieldLabel="",fieldStorage="real",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var1)
modelerData<-cbind(modelerData,lng)
print(modelerData)
var2<-c(fieldName="Longitude",fieldLabel="",fieldStorage="real",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var2)

