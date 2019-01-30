# Redistricting Algorithm v2.1


First we must download the data we will use.
We begin with the geography files from the US Census Tigerline:

```
	shapeFile <- "tl_2018_us_county"

	# Only Run this if the file isn't already downloaded
	# tmp <- tempfile()
	# download.file("ftp://ftp2.census.gov/geo/tiger/TIGER2018/COUNTY/tl_2018_us_county.zip", destfile = tmp)
	# unzip(tmp, exdir = ".")


	counties <- readOGR("." , shapeFile)
	va.counties <- counties[counties@data$STATEFP=="51",c("STATEFP", "COUNTYFP", "GEOID", "NAMELSAD", "NAME")]
	rownames(va.counties@data) <- paste(1:length(va.counties@data$NAMELSAD),va.counties@data$NAMELSAD)
	va.counties <- va.counties[map,]
```


We then need to add in the most recent population data that will be used for districting:

```
va.pop <- getCensus(name="sf1", vintage=2010, vars=c("NAME","P0010001"), region="county:*", regionin="state:51", key=key)
va.pop$GEOID <- as.character(paste0(va.pop$state,va.pop$county))
colnames(va.pop)[colnames(va.pop)=="NAME"] <- "NAMELSAD"
va.counties@data <- left_join(va.counties@data, va.pop)
```

We now create a contiguity list using the poly2nb function with queen set to FALSE (this means point contiguity is not enough):
```
adjlist <- poly2nb(va.counties, queen = F, row.names=va.counties@data$NAMELSAD)
            for(i in 1:length(adjlist)){
                adjlist[[i]] <- adjlist[[i]]
            }
            class(adjlist) <- "list"
```

We can map the contiguous boundaries to help get a sense of how places will be combined:
Queen == FALSE
```
res <- 4
png("VA_county_contiquity.png", units="px", width=800*res, height=500*res)
	xxnb <- poly2nb(va.counties, queen=F)
	plot(va.counties, lwd=4)
		points(cbind(va.counties@data$xtext, va.counties@data$ytext), col=paste0("#000000", opacity[120]), cex=res, pch=16)
		text(va.counties@data$xtext, va.counties@data$ytext, labels = va.counties@data$NAME, col=paste0("#000000", opacity[30]), cex=2.5)
	plot(xxnb, cbind(va.counties@data$xtext, va.counties@data$ytext), add=TRUE, col="blue", lwd=4)
dev.off()
```
<img src= "https://github.com/jcervas/districting/blob/master/VA_county_contiquity.png" width="800" />
