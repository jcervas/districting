

color1 <- rgb(247,252,253, max = 255)
color2 <- rgb(229,245,249, max = 255)
color3 <- rgb(204,236,230, max = 255)
color4 <- rgb(153,216,201, max = 255)
color5 <- rgb(102,194,164, max = 255)
color6 <- rgb(65,174,118, max = 255)
color7 <- rgb(35,139,69, max = 255)
color8 <- rgb(0,109,44, max = 255)
color9 <- rgb(0,68,27, max = 255)
greycol <- rgb(red = 190, green = 190, blue = 190, alpha = 170, maxColorValue = 255)
#/# shapefile should be the original, lowest aggregation file
#/# dataframe should be the population, a district list, and GEOID equivilent to that found in shapefile.new

redistricting <- function (shapefile, dataframe, pop.var, districts) { 
	ptm <- proc.time()

while (length(unique(dataframe$district)) > districts) {
	shapefile.new <- shapefile
	shapefile.new <- make.map(shapefile.new, dataframe, pop.var)
coords <- coordinates(shapefile.new)
# Select random unit
col.knn <- knearneigh(coords, k=1)
select <- sample(col.knn$nn, 1)
select2 <- which(col.knn$nn==select)

#development
# rownames(shapefile@data) <- shapefile@data$district
# adjlist <- poly2nb(shapefile, queen = T)
            # for(i in 1:length(adjlist)){
                # adjlist[[i]] <- adjlist[[i]] - 1
            # }
            # class(adjlist) <- "list"
# rand.comb <- sample(1:length(unique(dataframe[,"district"])),1)
# # combine <- c(rand.comb, adjlist[[rand.comb]][sample(1:length(adjlist[[rand.comb]]),1)])
# dataframe$district[dataframe$district %in% adjlist[[rand.comb]]] <- rand.comb


geoid.tmp <- shapefile.new@data$district[select]
geoid.tmp2 <- shapefile.new@data$district[select2[1]]

new.dta <- shapefile.new@data[,c("district", pop.var)]
dataframe$district[dataframe$district== shapefile.new@data$district[select]]	<- geoid.tmp
dataframe$district[dataframe$district==geoid.tmp2]	<- geoid.tmp

cat(paste("***** Number of Districts: ", length(unique(dataframe$district)), "\n"))
print(proc.time() - ptm)
}
return(dataframe)
}

make.map <- function (shapefile, dataframe, pop.var) {
	baseshape <- shapefile
			baseshape@data <- full_join(baseshape@data, dataframe, by="GEOID")
			baseshape <- gUnaryUnion(baseshape, id = baseshape@data$district)
			baseshape <- spChFIDs(baseshape, row.names(baseshape))
			row.names(baseshape) <- as.character(1:length(baseshape))
	new.data <- aggregate.data.frame(list(pop.var=as.numeric(dataframe[,pop.var])), by=list(district=dataframe$district), FUN=sum)
	colnames(new.data) <- c("district", pop.var)
baseshape <- SpatialPolygonsDataFrame(baseshape, new.data)
return(baseshape)
}

switched.district.tmp <<- "00000"
even.populations <- function (shapefile, dataframe, pop.var, districts) {
		ptm <- proc.time()
pop.var <<- pop.var
baseshape <- make.map(shapefile, dataframe, pop.var)

	temp.matrix <- nb2mat(poly2nb(baseshape, queen=FALSE), style="B")
		colnames(temp.matrix) <- baseshape@data$district
		rownames(temp.matrix) <- baseshape@data$district
			brds <- which(temp.matrix==1, arr.ind=TRUE)
				rnames <- rownames(temp.matrix)[brds[,1]]
				cnames <- colnames(temp.matrix)[brds[,2]]
		pop.diff <- data.frame(GEOIDr=rnames, GEOIDc=cnames, popr=NA, popc=NA)
			pop.diff$popr <-  baseshape@data[,pop.var][match(pop.diff$GEOIDr,baseshape@data$district)]
			pop.diff$popc <-  baseshape@data[,pop.var][match(pop.diff$GEOIDc,baseshape@data$district)]
			pop.diff$diff <- abs(pop.diff$popr-pop.diff$popc)
				rid <- pop.diff$GEOIDr[which(pop.diff$diff==max(pop.diff$diff))][1]
				cid <- pop.diff$GEOIDc[which(pop.diff$diff==max(pop.diff$diff))][1]
				
				get.district <- function (rid=rid, cid=cid) {
				ifelse(baseshape@data[,pop.var][as.character(baseshape@data$district)==rid]>baseshape@data[,pop.var][as.character(baseshape@data$district)==cid], m <<- as.character(rid), m <<- as.character(cid))
				ifelse(baseshape@data[,pop.var][as.character(baseshape@data$district)==rid]>baseshape@data[,pop.var][as.character(baseshape@data$district)==cid], l <<- as.character(cid), l <<- as.character(rid))
							morepopulated <<- as.character(dataframe$GEOID[as.character(dataframe$district)==m])
							lesspopulated <<- as.character(dataframe$GEOID[as.character(dataframe$district)==l])
										dissolved <<- shapefile[shapefile@data$GEOID %in% lesspopulated,]
							more.p <<- shapefile[shapefile@data$GEOID %in% morepopulated,]
							less.p <<- shapefile[shapefile@data$GEOID %in% lesspopulated,]
							switchable.dist <- data.frame(GEOID=more.p@data$GEOID, contiguity=NA)
				for (GEOID in unique(more.p@data$GEOID)) 
					{
					geo.true <- gIntersects(shapefile[shapefile@data$GEOID %in% GEOID,], dissolved)
					if (geo.true==TRUE) 
						{switchable.dist$contiguity[switchable.dist$GEOID==GEOID] <- 1}
					switchable.dist$distance[switchable.dist$GEOID==GEOID] <- gDistance(gCentroid(shapefile[shapefile@data$GEOID==GEOID,]), gCentroid(more.p)) - gDistance( 
						gCentroid(shapefile[shapefile@data$GEOID==GEOID,]), gCentroid(less.p))
						
				#development, selection based on population
				switchable.dist$diff[switchable.dist$GEOID==GEOID] <- abs((shapefile@data[,pop.var][shapefile@data$GEOID %in% morepopulated] - shapefile@data[,pop.var][shapefile@data$GEOID==GEOID]) - (shapefile@data[,pop.var][shapefile@data$GEOID %in% lesspopulated] + shapefile@data[,pop.var][shapefile@data$GEOID==GEOID]))
					}
						switchable.dist <- switchable.dist[!is.na(switchable.dist$contiguity),]
						switchable.dist <- switchable.dist[order(switchable.dist$distance, decreasing=T),]
				#development, selection based on population
				switchable.dist <- switchable.dist[order(switchable.dist$diff, decreasing=F),]
									n <- 1
								switched.district <- switchable.dist$GEOID[n]
							if (switched.district.tmp == switched.district) 
								{
								if (length(switchable.dist$GEOID)!=1) 
									{
									 switched.district <- switchable.dist$GEOID[n+1]
									} else {
									pop.diff <- pop.diff[-which(pop.diff$diff == max(pop.diff$diff)),]
									rid <- pop.diff$GEOIDr[which(pop.diff$diff == max(pop.diff$diff))][1]
									cid <- pop.diff$GEOIDc[which(pop.diff$diff == max(pop.diff$diff))][1]
									switched.district <- get.district(rid, cid)
											}
								}
								return(switched.district)
								}
								switched.district <- get.district(rid=rid,cid=cid)
								switched.district.tmp <<- switched.district
								dataframe$district[dataframe$GEOID==switched.district] <- l
			
						
			cat(paste("***** Time Elapsed", "\n"))
				print(proc.time() - ptm)			
			cat(paste("***** Iterations Complete", "\n"))
				district.pop <<- aggregate.districts(dataframe, pop.var)
print(district.pop)
		return(dataframe)


}




aggregate.districts <- function(dataframe, pop.var) {
	x <- aggregate(dataframe[, pop.var], list(dataframe[,"district"]), sum)
	colnames(x) <- c("district", pop.var)
	return(x)
}

















