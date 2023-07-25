
Code to create maps for expert witness reports


```
mapshaper -i blocks_simplified/TN_blocks20_simplified.json name=blocks \
  -proj EPSG:3662 \
  -each 'density = TOTAL / (ALAND/2589988)' target=blocks \
  -each 'sqrtdensity = Math.sqrt(density)' \
  -classify field=sqrtdensity save-as=fill nice colors=OrRd classes=9 null-value="#fff" \
  -dissolve COUNTY target=blocks no-replace name=counties \
  -style fill=none stroke=#aaa stroke-width=0.5 \
  -filter target=counties '[157,37,65,93,149].indexOf(COUNTY) > -1' + name=urban \
  -style fill=none stroke=#333 stroke-width=0.5 \
  -each "cx=$.innerX, cy=$.innerY" \
  -dissolve fill target=blocks name=dissolved \
  -each 'type="blocks"' \
  -i '/Volumes/GoogleDrive/My Drive/GitHub/Data Files/GIS/Cartographic/2021/cb_2021_us_all_500k/cb_2021_us_state_500k/cb_2021_us_state_500k.shp' \
  -filter 'GEOID=="47"' \
  -proj EPSG:3662 \
  -style fill=none stroke=#000 stroke-width=1 \
  -o '/Users/cervas/Library/Mobile Documents/com~apple~CloudDocs/Downloads/TN_simplified_pop.svg' format=svg combine-layers
```

```
mapshaper -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Senate Plans/2022 Enacted/TN-Senate-enacted.geojson' name=enacted \
  -proj EPSG:2274 \
  -filter target=enacted '[17,19,20,21].indexOf(id) > -1' + name=enacted_zoom \
  -each target=enacted_zoom "cx=$.innerX, cy=$.innerY" \
  -style target=enacted_zoom label-text=NAME \
  -points target=enacted_zoom x=cx y=cy + name=enacted-district-labels \
  -innerlines target=enacted_zoom + name=enacted-lines \
  -style target=enacted-lines stroke=#aaa stroke-width=0.5 stroke-dasharray="2" \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Senate Plans/Concept 1/concept1.geojson' name=concept1 \
  -proj EPSG:2274 \
  -filter target=concept1 '[18,19,20,21].indexOf(id) > -1' + name=concept1_zoom \
  -each target=concept1_zoom "cx=$.innerX, cy=$.innerY" \
  -style target=concept1_zoom label-text=NAME \
  -points target=concept1_zoom x=cx y=cy + name=concept1-district-labels \
  -innerlines target=concept1_zoom + name=concept1-lines \
  -style target=concept1-lines stroke=#aaa stroke-width=0.5 stroke-dasharray="2" \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Senate Plans/Concept 1a/concept1a.geojson' name=concept1a \
  -proj EPSG:2274 \
  -filter target=concept1a '[18,19,20,21].indexOf(id) > -1' + name=concept1a_zoom \
  -each target=concept1a_zoom "cx=$.innerX, cy=$.innerY" \
  -style target=concept1a_zoom label-text=NAME \
  -points target=concept1a_zoom x=cx y=cy + name=concept1a-district-labels \
  -innerlines target=concept1a_zoom + name=concept1a-lines \
  -style target=concept1a-lines stroke=#aaa stroke-width=0.5 stroke-dasharray="2" \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Senate Plans/Concept 1b/concept1b.geojson' name=concept1b \
  -proj EPSG:2274 \
  -filter target=concept1b '[18,19,20,21].indexOf(id) > -1' + name=concept1b_zoom \
  -each target=concept1b_zoom "cx=$.innerX, cy=$.innerY" \
  -style target=concept1b_zoom label-text=NAME \
  -points target=concept1b_zoom x=cx y=cy + name=concept1b-district-labels \
  -innerlines target=concept1b_zoom + name=concept1b-lines \
  -style target=concept1b-lines stroke=#aaa stroke-width=0.5 stroke-dasharray="2" \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Senate Plans/Senate-Constitutional-Numbering-Map/sendems.geojson' name=sendems \
  -proj EPSG:2274 \
  -filter target=sendems '[18,19,20,21].indexOf(id) > -1' + name=sendems_zoom \
  -each target=sendems_zoom "cx=$.innerX, cy=$.innerY" \
  -style target=sendems_zoom label-text=NAME \
  -points target=sendems_zoom x=cx y=cy + name=sendems-district-labels \
  -innerlines target=sendems_zoom + name=sendems-lines \
  -style target=sendems-lines stroke=#aaa stroke-width=0.5 stroke-dasharray="2" \
  -i '/Volumes/GoogleDrive/My Drive/GitHub/Data Files/Census/TN2020.pl/GIS/counties/TN_counties20.shp' name=counties \
  -proj EPSG:2274 \
  -filter target=counties '["Davidson","Rutherford","Shelby","Hamilton","Knox"].indexOf(NAME) > -1' + name=urban \
  -each target=urban "cx=$.centroidX, cy=$.centroidY" \
  -style target=urban label-text=NAMELSAD \
  -points target=urban x=cx y=cy + name=county-labels-urban \
  -style target=county-labels-urban font-size=12 font-weight=bold fill=#fff stroke=#333 \
  -filter target=counties '["Davidson"].indexOf(NAME) > -1' + name=davidson \
  -each target=davidson "cx=$.centroidX, cy=$.centroidY" \
  -style target=davidson label-text=NAMELSAD \
  -points target=davidson x=cx y=cy + name=county-labels \
  -style target=county-labels font-size=20 font-weight=bold fill=#333 \
  -colorizer name=ContColor random colors="#EFDECD,#CD9575,#FDD9B5,#78DBE2,#87A96B,#FFA474,#FAE7B5,#9F8170,#FD7C6E,#ACE5EE,#1F75FE,#A2A2D0,#6699CC,#0D98BA,#7366BD,#DE5D83,#CB4154,#B4674D,#FF7F49,#EA7E5D,#B0B7C6,#FFFF99,#1CD3A2,#FFAACC,#DD4492,#1DACD6,#BC5D58,#DD9475,#9ACEEB,#FFBCD9,#FDDB6D,#2B6CC4,#EFCDB8,#6E5160,#CCFF00,#71BC78,#6DAE81,#C364C5,#CC6666,#E7C697,#FCD975,#A8E4A0,#95918C,#1CAC78,#1164B4,#ADFF2F,#FF1DCE,#B2EC5D,#5D76CB,#CA3767,#3BB08F,#FFFF66,#FCB4D5,#FFF44F,#FFBD88,#F664AF,#AAF0D1,#CD4A4C,#EDD19C,#979AAA,#FF8243,#C8385A,#EF98AA,#FDBCB4,#1A4876,#30BA8F,#C54B8C,#1974D2,#FFA343,#BAB86C,#FF7538,#FF2B2B,#F8D568,#E6A8D7,#414A4C,#FF6E4A,#1CA9C9,#FFCFAB,#C5D0E6,#FDDDE6,#158078,#FC74FD,#F78FA7,#8E4585,#7442C8,#9D81BA,#FE4EDA,#FF496C,#D68A59,#714B23,#FF48D0,#E3256B,#EE204D,#FF5349,#C0448F,#1FCECB,#7851A9,#FF9BAA,#FC2847,#66FF66,#9FE2BF,#A5694F,#8A795D,#45CEA2,#FB7EFD,#CDC5C2,#80DAEB,#ECEABE,#FFCF48,#FD5E53,#FAA76C,#18A7B5,#EBC7DF,#FC89AC,#DBD7D2,#17806D,#DEAA88,#77DDE7,#FFFF83,#926EAE,#324AB2,#F75394,#FFA089,#8F509D,#A2ADD0,#FF43A4,#FC6C85,#CDA4DE,#FFFF00,#C5E384,#FFAE42" \
  -style target=enacted_zoom fill='ContColor(id)' \
  -style target=sendems_zoom fill='ContColor(id)' \
  -style target=concept1_zoom fill='ContColor(id)' \
  -style target=concept1a_zoom fill='ContColor(id)' \
  -style target=concept1b_zoom fill='ContColor(id)' \
  -style target=enacted fill='ContColor(id)' stroke="#333333" \
  -style target=concept1 fill='ContColor(id)' stroke="#333333" \
  -style target=concept1a fill='ContColor(id)' stroke="#333333" \
  -style target=concept1b fill='ContColor(id)' stroke="#333333" \
  -style target=sendems fill='ContColor(id)' stroke="#333333" \
  -style target=davidson fill=none stroke=#000 stroke-width=2 \
  -proj EPSG:2274 target="enacted_zoom,concept1_zoom,concept1a_zoom,concept1b_zoom,enacted-lines,concept1-lines,concept1a-lines,concept1b-lines,davidson,enacted-district-labels,concept1-district-labels,concept1a-district-labels,concept1b-district-labels,county-labels,davidson,counties" \
  -o target="enacted_zoom,enacted-lines,davidson,enacted-district-labels,county-labels" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Zoom/TN_Senate_enacted.svg' format=svg combine-layers \
  -o target="sendems_zoom,sendems-lines,davidson,sendems-district-labels,county-labels" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Zoom/TN_Senate_sendems.svg' format=svg combine-layers \
  -o target="concept1_zoom,concept1-lines,davidson,concept1-district-labels,county-labels" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Zoom/TN_Senate_concept1.svg' format=svg combine-layers \
  -o target="concept1a_zoom,concept1a-lines,davidson,concept1a-district-labels,county-labels" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Zoom/TN_Senate_concept1a.svg' format=svg combine-layers \
  -o target="concept1b_zoom,concept1b-lines,davidson,concept1b-district-labels,county-labels" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Zoom/TN_Senate_concept1b.svg' format=svg combine-layers \
  -innerlines target=counties + name=counties-lines \
  -style target=counties-lines stroke=#aaa stroke-width=0.5 stroke-dasharray="2 2"  \
  -dissolve target=counties STATEFP no-replace name=TN \
  -style target=TN fill=none stroke=#000 \
  -dissolve target=enacted_zoom + name=enacted_zoom-area \
  -dissolve target=concept1_zoom + name=concept1_zoom-area \
  -style target="enacted_zoom-area" stroke=none fill=#222 \
  -style target="concept1_zoom-area" stroke=none fill=#222 \
  -o target="counties-lines,enacted_zoom-area,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Zoom/TN_Senate_enacted_st.svg' format=svg combine-layers width=200 \
  -o target="counties-lines,concept1_zoom-area,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Zoom/TN_Senate_concepts_st.svg' format=svg combine-layers width=200 \
  -o target="counties-lines,enacted,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Plans/TN_Senate_enacted.svg' format=svg combine-layers \
  -o target="counties-lines,sendems,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Plans/TN_Senate_sendems.svg' format=svg combine-layers \
  -o target="counties-lines,concept1,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Plans/TN_Senate_concept1.svg' format=svg combine-layers \
  -o target="counties-lines,concept1a,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Plans/TN_Senate_concept1a.svg' format=svg combine-layers \
  -o target="counties-lines,concept1b,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/Plans/TN_Senate_concept1b.svg' format=svg combine-layers \
  -o target="counties-lines,urban,TN,county-labels-urban" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/TN_House-urban.svg' format=svg combine-layers
```

```{r}
    rm(list=ls(all=TRUE))   # Remove all objects just to be safe.
    options(scipen=999)     # Turn off Scientific Notation
    options(stringsAsFactors = FALSE)

plan_sum <- function(plan=NULL) {

  plan_tmp <- merge(plan, tn_blocks, by.x="GEOID20", by.y="GEOCODE")
    plan_tmp$uniq <- paste0(plan_tmp$District, "_", plan_tmp$COUNTY)
    uni_dist_cnty <- aggregate(plan_tmp$TOTAL, by=list(plan_tmp$uniq), FUN = sum)
  plan_tmp <- merge(plan_tmp, uni_dist_cnty, by.x="uniq", by.y= "Group.1")
  a = split(plan_tmp, plan_tmp$COUNTY)

  b <- list()
  bpop <- list()
      for (i in 1:length(a)) {
        b[[i]] <- unique(a[[i]]$District)
        }

  cntysplits <- c()
  for (i in 1:length(a)) {
    if (length(b[[i]]) > 1) {
      cntysplits <- c(cntysplits, 1)
    }
  }

  totalsplits <- c()
  for (i in 1:length(a)) {
    if (length(b[[i]]) > 1) {
      totalsplits <- c(totalsplits, length(b[[i]]))
    }
  }

  tnsplits <- list()
  data_new <- list()
  for (i in 1:length(a)) {
    if (length(b[[i]]) > 1) {
      data_new[[i]] <- a[[i]][!duplicated(a[[i]]$District),]
    }
  }
  tnsplits_tmp <- do.call(rbind, data_new)
  tnsplits <- tnsplits_tmp[(tnsplits_tmp$x < 66316),]

  dist_pop <- aggregate(list(TOTAL=plan_tmp$TOTAL), by=list(District=plan_tmp$District), FUN=sum)
  ideal <- sum(dist_pop$TOTAL)/length(dist_pop$TOTAL)

splits.table <- 
  rbind(
    sum(cntysplits),
    sum(totalsplits) - length(totalsplits),
    length(aggregate(tnsplits$x, by=list(tnsplits$COUNTY), FUN=sum)[,1]),
    min(dist_pop$TOTAL),
    round(100*((min(dist_pop$TOTAL)-ideal)/ideal),2),
    max(dist_pop$TOTAL),
    round(100*((max(dist_pop$TOTAL)-ideal)/ideal),2),
    round(100*((max(dist_pop$TOTAL)-ideal)/ideal + abs((min(dist_pop$TOTAL)-ideal)/ideal)),2),
    round(100*(mean(abs(dist_pop$TOTAL-ideal)/ideal)),2)
    )
row.names(splits.table) <- 
  c(
    "County Splits", 
    "Total Splits", 
    "TN Splits", 
    "Smallest District",
    "Smallest Percentage",
    "Largest District",
    "Largest Percentage",
    "Overall Deviation",
    "Average Deviation")

  return(splits.table)
}


tn_blocks <- read.csv("/Volumes/GoogleDrive/My Drive/GitHub/Data Files/Census/TN2020.pl/clean data/TN_blocks.csv")

House13a <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13a/TN House 13a.csv")
House13b <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13b/TN House 13b.csv")
House13.5a <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13.5a/TN House 13.5a.csv")
House13.5b <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13.5b/TN House 13.5b.csv")
House14a <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/14a/TN House 14a.csv")

demconcept <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/House Dem Concept 12-15-21/House Dem Concept 12-15-21.csv")
enacted <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/2022 Enacted/2022 Enacted.csv")


tn13b_err <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/response_report/TN House 13b_erratum.csv", colClasses=c("character"))
tn14a_err <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/response_report/TN House 14a_erratum.csv", colClasses=c("character"))
tn13.5a_err <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/response_report/TN House 13.5a_erratum.csv", colClasses=c("character"))
tn13.5b_err <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/response_report/TN House 13.5b_erratum.csv", colClasses=c("character"))
tn13c <- read.csv("/Users/cervas/Library/Mobile Documents/com~apple~CloudDocs/Downloads/TN House 13c.csv", colClasses=c("character"))
tn13d <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13d/TN House 13d.csv", colClasses=c("character"))
tn13d_e <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13d_e/TN House 13d_e.csv", colClasses=c("character"))

tn13e <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13e/TN House 13e.csv", colClasses=c("character"))


plan <- read.csv("/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13d_e/TN House 13d_e.csv", colClasses=c("character"))
plan_sum(plan)

plan_sum(enacted)
plan_sum(House13a)
plan_sum(House13b)
plan_sum(House14a)
plan_sum(House13.5a)
plan_sum(House13.5b)

plan_sum(tn13b_err)
plan_sum(tn14a_err)
plan_sum(tn13.5a_err)
plan_sum(tn13.5b_err)
plan_sum(tn13c)
plan_sum(tn13d)
plan_sum(tn13e)
```

## Compare plan files

```{r}
tn13b <- cbind(House13b[order(House13b[,1]),], tn13b_err[order(tn13b_err[,1]),])
tn14a <- cbind(House14a[order(House14a[,1]),], tn14a_err[order(tn14a_err[,1]),])
tn135a <- cbind(House13.5a[order(House13.5a[,1]),], tn13.5a_err[order(tn13.5a_err[,1]),])
tn135b <- cbind(House13.5b[order(House13.5b[,1]),], tn13.5b_err[order(tn13.5b_err[,1]),])

diff_geo <- function(a) {
changes.blocks <- cbind(a[,1][!(a[,2] == a[,4])], a[,2][!(a[,2] == a[,4])])
colnames(changes.blocks) <- c("GEOID20","District")

changes.tmp <- merge(changes.blocks, tnblocks, by="GEOID20")

return(
  aggregate(list(pop=changes.tmp$P1_001N), by=list(district=changes.tmp$District), FUN=sum)
    )
  }

diff_geo(tn13b)
diff_geo(tn14a)
diff_geo(tn135a)
diff_geo(tn135b)


a=read.csv("/Users/cervas/Library/Mobile Documents/com~apple~CloudDocs/Downloads/districts-across-maps.csv")
mean(a[,13][!duplicated(a[,1])])
```

Changes in erratum:
13b: D12,13,37,49 (Zero population)
14a: D13,37,49 (Zero population)
13.5a: D12,13,37,49,91,99 (Zero population)
13.5b: D13,37,49,68,75 (Zero population)

Cores (downloaded from DRA):
Enacted: 80.1%
13b_e: 71.5%
14a_e: 69.2%
13.5a_e: 70.6%
13.5b_e: 67.9%
13c: 73.7%
13d: 80.1%
13d_e:

# Shelby Districts

#House MAPS

```
mapshaper -i '/Volumes/GoogleDrive/My Drive/GitHub/Data Files/GIS/USA_Major_Cities.geojson' name=cities \
  -i '/Volumes/GoogleDrive/My Drive/GitHub/Data Files/GIS/USA_Major_Cities.geojson' name=cities-label \
  -i '/Volumes/GoogleDrive/My Drive/GitHub/Data Files/Census/TN2020.pl/GIS/counties/TN_counties20.shp' name=counties \
  -filter target=cities '["TN"].indexOf(ST) > -1' \
  -filter target=cities-label '["TN"].indexOf(ST) > -1' \
  -filter target=cities '["Knoxville","Memphis","Nashville","Chattanooga","Clarksville"].indexOf(NAME) > -1' \
  -filter target=cities-label '["Knoxville","Memphis","Nashville","Chattanooga","Clarksville"].indexOf(NAME) > -1' \
  -proj target="cities-label,cities,counties" EPSG:2274 \
  -style target=cities stroke="#333333" r=3 \
  -style target=cities-label label-text=NAME \
  -dissolve target=counties STATEFP no-replace name=TN \
  -style target=TN fill=none stroke=#000 \
  -o target="TN,cities,cities-label" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/TN_cities.svg' format=svg combine-layers
```

# Zoom

```
mapshaper \
  -i '/Volumes/GoogleDrive/My Drive/GitHub/Data Files/Census/TN2020.pl/GIS/counties/TN_counties20.shp' name=counties \
  -filter target=counties '["Shelby"].indexOf(NAME) > -1' + name=Shelby \
  -style target=Shelby fill=none stroke=#000 \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/2022 Enacted/2022 Enacted.geojson' name=enacted \
  -colorizer name=ContColor random colors="#EFDECD,#CD9575,#FDD9B5,#78DBE2,#87A96B,#FFA474,#FAE7B5,#9F8170,#FD7C6E,#ACE5EE,#1F75FE,#A2A2D0,#6699CC,#0D98BA,#7366BD,#DE5D83,#CB4154,#B4674D,#FF7F49,#EA7E5D,#B0B7C6,#FFFF99,#1CD3A2,#FFAACC,#DD4492,#1DACD6,#BC5D58,#DD9475,#9ACEEB,#FFBCD9,#FDDB6D,#2B6CC4,#EFCDB8,#6E5160,#CCFF00,#71BC78,#6DAE81,#C364C5,#CC6666,#E7C697,#FCD975,#A8E4A0,#95918C,#1CAC78,#1164B4,#ADFF2F,#FF1DCE,#B2EC5D,#5D76CB,#CA3767,#3BB08F,#FFFF66,#FCB4D5,#FFF44F,#FFBD88,#F664AF,#AAF0D1,#CD4A4C,#EDD19C,#979AAA,#FF8243,#C8385A,#EF98AA,#FDBCB4,#1A4876,#30BA8F,#C54B8C,#1974D2,#FFA343,#BAB86C,#FF7538,#FF2B2B,#F8D568,#E6A8D7,#414A4C,#FF6E4A,#1CA9C9,#FFCFAB,#C5D0E6,#FDDDE6,#158078,#FC74FD,#F78FA7,#8E4585,#7442C8,#9D81BA,#FE4EDA,#FF496C,#D68A59,#714B23,#FF48D0,#E3256B,#EE204D,#FF5349,#C0448F,#1FCECB,#7851A9,#FF9BAA,#FC2847,#66FF66,#9FE2BF,#A5694F,#8A795D,#45CEA2,#FB7EFD,#CDC5C2,#80DAEB,#ECEABE,#FFCF48,#FD5E53,#FAA76C,#18A7B5,#EBC7DF,#FC89AC,#DBD7D2,#17806D,#DEAA88,#77DDE7,#FFFF83,#926EAE,#324AB2,#F75394,#FFA089,#8F509D,#A2ADD0,#FF43A4,#FC6C85,#CDA4DE,#FFFF00,#C5E384,#FFAE42" \
  -clip target=enacted source="Shelby" remove-slivers \
  -each target=enacted "cx=$.innerX, cy=$.innerY" \
  -points target=enacted x=cx y=cy + name=enacted-district-labels \
  -style target=enacted fill='ContColor(id)' stroke="#333333" stroke-opacity=0.75 stroke-dasharray="2 2" \
  -style target=enacted-district-labels label-text=NAME \
  -o target="Shelby,enacted-district-labels,enacted" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/Zoom/TN_House_enacted.svg' format=svg combine-layers height=200 \
```

```
mapshaper \
  -i '/Volumes/GoogleDrive/My Drive/GitHub/Data Files/Census/TN2020.pl/GIS/counties/TN_counties20.shp' name=counties \
  -filter target=counties '["Shelby","Tipton"].indexOf(NAME) > -1' + name=Shelby \
  -filter target=counties '["Shelby"].indexOf(NAME) > -1' + name=Shelby-Tipton \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13.5a/TN House 13.5a.geojson' name=13.5a \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13.5b/TN House 13.5b.geojson' name=13.5b \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/14a/TN House 14a.geojson' name=14a \
  -colorizer name=ContColor random colors="#EFDECD,#CD9575,#FDD9B5,#78DBE2,#87A96B,#FFA474,#FAE7B5,#9F8170,#FD7C6E,#ACE5EE,#1F75FE,#A2A2D0,#6699CC,#0D98BA,#7366BD,#DE5D83,#CB4154,#B4674D,#FF7F49,#EA7E5D,#B0B7C6,#FFFF99,#1CD3A2,#FFAACC,#DD4492,#1DACD6,#BC5D58,#DD9475,#9ACEEB,#FFBCD9,#FDDB6D,#2B6CC4,#EFCDB8,#6E5160,#CCFF00,#71BC78,#6DAE81,#C364C5,#CC6666,#E7C697,#FCD975,#A8E4A0,#95918C,#1CAC78,#1164B4,#ADFF2F,#FF1DCE,#B2EC5D,#5D76CB,#CA3767,#3BB08F,#FFFF66,#FCB4D5,#FFF44F,#FFBD88,#F664AF,#AAF0D1,#CD4A4C,#EDD19C,#979AAA,#FF8243,#C8385A,#EF98AA,#FDBCB4,#1A4876,#30BA8F,#C54B8C,#1974D2,#FFA343,#BAB86C,#FF7538,#FF2B2B,#F8D568,#E6A8D7,#414A4C,#FF6E4A,#1CA9C9,#FFCFAB,#C5D0E6,#FDDDE6,#158078,#FC74FD,#F78FA7,#8E4585,#7442C8,#9D81BA,#FE4EDA,#FF496C,#D68A59,#714B23,#FF48D0,#E3256B,#EE204D,#FF5349,#C0448F,#1FCECB,#7851A9,#FF9BAA,#FC2847,#66FF66,#9FE2BF,#A5694F,#8A795D,#45CEA2,#FB7EFD,#CDC5C2,#80DAEB,#ECEABE,#FFCF48,#FD5E53,#FAA76C,#18A7B5,#EBC7DF,#FC89AC,#DBD7D2,#17806D,#DEAA88,#77DDE7,#FFFF83,#926EAE,#324AB2,#F75394,#FFA089,#8F509D,#A2ADD0,#FF43A4,#FC6C85,#CDA4DE,#FFFF00,#C5E384,#FFAE42" \
  -filter target="13.5a" '[79,83,84,85,86,87,88,91,93,95,96,97,98,99].indexOf(id) > -1' \
  -filter target="13.5b" '[79,83,84,85,86,87,88,91,93,95,96,97,98,99].indexOf(id) > -1' \
  -filter target="14a" '[79,83,84,85,86,87,88,91,93,95,96,97,98,99].indexOf(id) > -1' \
  -each target=13.5a "cx=$.innerX, cy=$.innerY" \
  -each target=13.5b "cx=$.innerX, cy=$.innerY" \
  -each target=14a "cx=$.innerX, cy=$.innerY" \
  -points target=13.5a x=cx y=cy + name=13.5a-district-labels \
  -points target=13.5b x=cx y=cy + name=13.5b-district-labels \
  -points target=14a x=cx y=cy + name=14a-district-labels \
  -style target=13.5a fill='ContColor(id)' stroke="#333333" stroke-opacity=0.75 stroke-dasharray="2 2" \
  -style target=13.5b fill='ContColor(id)' stroke="#333333" stroke-opacity=0.75 stroke-dasharray="2 2" \
  -style target=14a fill='ContColor(id)' stroke="#333333" stroke-opacity=0.75 stroke-dasharray="2 2" \
  -style target=13.5a-district-labels label-text=NAME \
  -style target=13.5b-district-labels label-text=NAME \
  -style target=14a-district-labels label-text=NAME \
  -style target=Shelby fill=none stroke=#000 \
  -style target=Shelby-Tipton fill=none stroke=#000 \
  -o target="Shelby,enacted-district-labels,enacted" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/Zoom/TN_House_enacted.svg' format=svg combine-layers height=200 \
  -o target="Shelby,13.5a-district-labels,13.5a" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/Zoom/TN_House_13.5a.svg' format=svg combine-layers height=200 \
  -o target="Shelby,13.5b-district-labels,13.5b" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/Zoom/TN_House_13.5b.svg' format=svg combine-layers height=200 \
  -o target="Shelby-Tipton,14a-district-labels,14a" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/Zoom/TN_House_14a.svg' format=svg combine-layers height=200
```

```
mapshaper \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/2022 Enacted/2022 Enacted.geojson' name=enacted \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13a/TN House 13a.geojson' name=13a \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13b/TN House 13b.geojson' name=13b \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/14a/TN House 14a.geojson' name=14a \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13.5a/TN House 13.5a.geojson' name=13.5a \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13.5b/TN House 13.5b.geojson' name=13.5b \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13c/TN House 13c.geojson' name=13c \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/13d/TN House 13d.geojson' name=13d \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/House Plans/House Dem Concept 12-15-21/House Dem Concept 12-15-21.geojson' name=demconcept \
  -i '/Volumes/GoogleDrive/My Drive/GitHub/Data Files/Census/TN2020.pl/GIS/counties/TN_counties20.shp' name=counties \
  -proj target="enacted,13a,13b,14a,13.5a,13.5b,13c,13d,demconcept,counties" EPSG:2274 \
  -innerlines target=counties + name=counties-lines \
  -style target=counties-lines stroke=#000 stroke-width=0.5 stroke-dasharray="2 2" \
  -dissolve target=counties STATEFP no-replace name=TN \
  -style target=TN fill=none stroke=#000 \
  -colorizer name=ContColor random colors="#EFDECD,#CD9575,#FDD9B5,#78DBE2,#87A96B,#FFA474,#FAE7B5,#9F8170,#FD7C6E,#ACE5EE,#1F75FE,#A2A2D0,#6699CC,#0D98BA,#7366BD,#DE5D83,#CB4154,#B4674D,#FF7F49,#EA7E5D,#B0B7C6,#FFFF99,#1CD3A2,#FFAACC,#DD4492,#1DACD6,#BC5D58,#DD9475,#9ACEEB,#FFBCD9,#FDDB6D,#2B6CC4,#EFCDB8,#6E5160,#CCFF00,#71BC78,#6DAE81,#C364C5,#CC6666,#E7C697,#FCD975,#A8E4A0,#95918C,#1CAC78,#1164B4,#ADFF2F,#FF1DCE,#B2EC5D,#5D76CB,#CA3767,#3BB08F,#FFFF66,#FCB4D5,#FFF44F,#FFBD88,#F664AF,#AAF0D1,#CD4A4C,#EDD19C,#979AAA,#FF8243,#C8385A,#EF98AA,#FDBCB4,#1A4876,#30BA8F,#C54B8C,#1974D2,#FFA343,#BAB86C,#FF7538,#FF2B2B,#F8D568,#E6A8D7,#414A4C,#FF6E4A,#1CA9C9,#FFCFAB,#C5D0E6,#FDDDE6,#158078,#FC74FD,#F78FA7,#8E4585,#7442C8,#9D81BA,#FE4EDA,#FF496C,#D68A59,#714B23,#FF48D0,#E3256B,#EE204D,#FF5349,#C0448F,#1FCECB,#7851A9,#FF9BAA,#FC2847,#66FF66,#9FE2BF,#A5694F,#8A795D,#45CEA2,#FB7EFD,#CDC5C2,#80DAEB,#ECEABE,#FFCF48,#FD5E53,#FAA76C,#18A7B5,#EBC7DF,#FC89AC,#DBD7D2,#17806D,#DEAA88,#77DDE7,#FFFF83,#926EAE,#324AB2,#F75394,#FFA089,#8F509D,#A2ADD0,#FF43A4,#FC6C85,#CDA4DE,#FFFF00,#C5E384,#FFAE42" \
  -style target=enacted fill='ContColor(id)' stroke="#333333" \
  -style target=13a fill='ContColor(id)' stroke="#333333" \
  -style target=13b fill='ContColor(id)' stroke="#333333" \
  -style target=14a fill='ContColor(id)' stroke="#333333" \
  -style target=13.5a fill='ContColor(id)' stroke="#333333" \
  -style target=13.5b fill='ContColor(id)' stroke="#333333" \
  -style target=13c fill='ContColor(id)' stroke="#333333" \
  -style target=13d fill='ContColor(id)' stroke="#333333" \
  -style target=demconcept fill='ContColor(id)' stroke="#333333" \
  -o target="enacted,counties-lines,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_enacted.svg' format=svg combine-layers height=200 \
  -o target="13a,counties-lines,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_13a.svg' format=svg combine-layers height=200 \
  -o target="13b,counties-lines,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_13b.svg' format=svg combine-layers height=200 \
  -o target="demconcept,counties-lines,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_demconcept.svg' format=svg combine-layers height=200 \
  -o target="14a,counties-lines,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_14a.svg' format=svg combine-layers height=200 \
  -o target="13.5a,counties-lines,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_13.5a.svg' format=svg combine-layers height=200 \
  -o target="13.5b,counties-lines,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_13.5b.svg' format=svg combine-layers \
  -o target="13c,counties-lines,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_13c.svg' format=svg combine-layers \
  -o target="13d,counties-lines,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_13d.svg' format=svg combine-layers \
  -filter target=enacted '[5, 6, 7, 8, 13, 14, 15, 16, 18, 19, 20, 26, 27, 28, 29, 30, 31, 34, 37, 39, 48, 49, 50, 51, 52, 53, 54, 55, 56, 58, 59, 60, 66, 67, 68, 75, 83, 84, 85, 86, 87, 88, 89, 90, 91, 93, 95, 96, 97, 98, 99].indexOf(id) > -1' + name=sameenacted \
  -o target="counties-lines,sameenacted,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/House/TN_House_sameenacted.svg' format=svg combine-layers height=200 \
  -filter target=enacted '[84,91,83,87,54,28,58,86,98,93,88,85,80,79,96].indexOf(id) > -1' + name=Black14a \
  -style target=Black14a fill="#333333" stroke="#000000" stroke-opacity=1 \
  -o target="counties-lines,Black14a,TN" '/Users/cervas/Library/Mobile Documents/com~apple~CloudDocs/Downloads/black14a.svg' format=svg combine-layers height=200 \
```


### Not used

```
  -style target=TN fill=none stroke=#e6e6e6 stroke-width=3 stroke-opacity=0.70 \


  -classify target=map save-as=fill colors='#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928' non-adjacent \
  -o target="counties-lines,map,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/TN_Senate-Constitutional-Numbering-Map.svg' format=svg combine-layers \
  -i '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Senate Plans/Concept 1/Concept-1/Concept-1.shp' name=map1 \
  -proj EPSG:3662 target="map1" \
  -info target=map1 \
  -classify target=map1 save-as=fill colors='#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928' non-adjacent \
  -o target="counties-lines,map1,TN" '/Volumes/GoogleDrive/My Drive/Projects/Redistricting/2022/TN/Maps/Senate/TN_Senate-Concept-1.svg' format=svg combine-layers


-classify target=enacted save-as=fill colors='#80CDC1,#FF8585,#B8FFF4,#85FFA7' non-adjacent \




-colorizer name=ContColor random colors="#EFDECD,#CD9575,#FDD9B5,#78DBE2,#87A96B,#FFA474,#FAE7B5,#9F8170,#FD7C6E,#000000,#ACE5EE,#1F75FE,#A2A2D0,#6699CC,#0D98BA,#7366BD,#DE5D83,#CB4154,#B4674D,#FF7F49,#EA7E5D,#B0B7C6,#FFFF99,#1CD3A2,#FFAACC,#DD4492,#1DACD6,#BC5D58,#DD9475,#9ACEEB,#FFBCD9,#FDDB6D,#2B6CC4,#EFCDB8,#6E5160,#CCFF00,#71BC78,#6DAE81,#C364C5,#CC6666,#E7C697,#FCD975,#A8E4A0,#95918C,#1CAC78,#1164B4,#ADFF2F,#FF1DCE,#B2EC5D,#5D76CB,#CA3767,#3BB08F,#FFFF66,#FCB4D5,#FFF44F,#FFBD88,#F664AF,#AAF0D1,#CD4A4C,#EDD19C,#979AAA,#FF8243,#C8385A,#EF98AA,#FDBCB4,#1A4876,#30BA8F,#C54B8C,#1974D2,#FFA343,#BAB86C,#FF7538,#FF2B2B,#F8D568,#E6A8D7,#414A4C,#FF6E4A,#1CA9C9,#FFCFAB,#C5D0E6,#FDDDE6,#158078,#FC74FD,#F78FA7,#8E4585,#7442C8,#9D81BA,#FE4EDA,#FF496C,#D68A59,#714B23,#FF48D0,#E3256B,#EE204D,#FF5349,#C0448F,#1FCECB,#7851A9,#FF9BAA,#FC2847,#66FF66,#9FE2BF,#A5694F,#8A795D,#45CEA2,#FB7EFD,#CDC5C2,#80DAEB,#ECEABE,#FFCF48,#FD5E53,#FAA76C,#18A7B5,#EBC7DF,#FC89AC,#DBD7D2,#17806D,#DEAA88,#77DDE7,#FFFF83,#926EAE,#324AB2,#F75394,#FFA089,#8F509D,#A2ADD0,#FF43A4,#FC6C85,#CDA4DE,#FFFF00,#C5E384,#FFAE42" \
-style fill='ContColor(id)' \
```
