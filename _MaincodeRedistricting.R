# libs <- c("censusapi", "tigris", "spdep", "rgdal", "rgeos", "dplyr", "maptools", "sp", "raster", "redist")
# sapply(libs, install.packages)


require(censusapi, quietly=TRUE)
require(tigris, quietly=TRUE)
require(spdep, quietly=TRUE)
require(tidyverse)
require(redist)
require(tidycensus)
require(spdep)
require(rgdal)
require(rgeos)
require(maptools)
require(sp)

key <- "7865f31139b09e17c5865a59c240bdf07f9f44fd"
# census_api_key(key)
options(stringsAsFactors=FALSE)

source("https://raw.githubusercontent.com/jcervas/districting/master/redistricting.R")

time <- proc.time()
# states.geo <- states()
ca.tracts <- tracts(state="ca")
# ca.counties <- counties(state="ca")


ca.tracts.data <- getCensus(name="acs5", vintage=2015, vars="B01003_001E", region="tract:*", regionin="state:06", key=key)
ca.tracts.data$GEOID <- paste0(ca.tracts.data$state,ca.tracts.data$county,ca.tracts.data$tract)
ca.tracts@data <- full_join(ca.tracts@data, ca.tracts.data)
ca <- ca.tracts

# ca <- ca.counties
# ca.data <- getCensus(name="acs5", vintage=2015, vars="B01003_001E", region="county:*", regionin="state:06", key=key)
# ca.data$GEOID <- paste0(ca.data$state,ca.data$county)
# ca@data <- full_join(ca@data, ca.data)

districts <- 3
pop.var <- "population"
colnames(ca@data)[colnames(ca@data)=="B01003_001E"] <- pop.var

adjlist <- poly2nb(ca, queen = T)
            for(i in 1:length(adjlist)){
                adjlist[[i]] <- adjlist[[i]] - 1
            }
            class(adjlist) <- "list"
# maps <- redist.rsg(adjlist, ca@data$population, districts, 0.01)

maps <- redist.mcmc(adjobj = ca,
                          popvec = ca@data$population,
                          nsims = 10000,
                          popcons = .01, 
                          ndists=53,
                          maxiterrsg =2000000)
write.csv(unlist(maps), "maps.csv", row.names=F)
dataframe <- data.frame(GEOID=as.character(ca@data$GEOID), district=maps$partitions[1], population=ca@data[,pop.var])


# # 
# dataframe <- redistricting(shapefile=ca, dataframe=dataframe, pop.var="population", districts=districts)
dataframe.save <- dataframe

map1 <- make.map(ca, dataframe.save, "population")

# # pdf("/Users/jcervas/Google Drive/School/UCI/Papers/Extreme Gerrymandering/ca_redistrict.pdf", width=12, height=6)
# par(mfrow=c(1,3), mar=c(0,2,0,2), mai=c(0,0,1,0), omi=c(0,0,0,0), oma=c(0,0,0,0))
# plot(ca.counties, lty=3, border="gray70", main="California Counties (original)")
# plot(map1, col=c(color3, color5, color7), main="Simulated Districts \n (Unequal Populations) ")
# text(coordinates(map1)[,1], coordinates(map1)[,2], paste(map1@data$district,"\n",format(map1@data[,pop.var],big.mark=",", trim=TRUE)), cex=0.9)
# plot(ca.counties, lty=3, lwd=.5, border="gray70", add=T)


# dataframe <- even.populations(ca, dataframe, "population", districts)
# while (max(district.pop$population) >= 1.05*(sum(district.pop$population)/districts)) {dataframe <- even.populations(ca, dataframe, "population", districts)}
# dataframe.complete.save <- dataframe
# region.new <- make.map(ca, dataframe, "population")


# plot(region.new, col=c(color3, color5, color7), border="gray70", main="Simulated Districts \n (Equal Populations)")
# plot(ca, border="gray70", lty=3, lwd=.5, add=T)
# text(coordinates(region.new)[,1], coordinates(region.new)[,2], paste(region.new@data$district,"\n",format(region.new@data[,pop.var],big.mark=",", trim=TRUE)), cex=0.9)
# # text(coordinates(ca)[,1], coordinates(ca)[,2], paste(ca@data$district,"\n",format(ca@data[,pop.var],big.mark=",", trim=TRUE)), cex=0.29)

# dev.off()





proc.time() - time