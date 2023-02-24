mapshaper \
  -i '/Users/cervas/Library/CloudStorage/GoogleDrive-jcervas@uci.edu/My Drive/Projects/Redistricting/2022/TN/House Plans/13d_e/TN House 13d_e.geojson' name=13d_e \
  -i '/Users/cervas/Library/CloudStorage/GoogleDrive-jcervas@uci.edu/My Drive/GitHub/Data Files/Census/TN2020.pl/GIS/counties/TN_counties20.shp' name=counties \
  -proj target="13d_e,counties" EPSG:2274 \
  -innerlines target=counties + name=counties-lines \
  -style target=counties-lines stroke=#000 stroke-width=0.5 stroke-dasharray="2 2" \
  -dissolve target=counties STATEFP no-replace name=TN \
  -style target=TN fill=none stroke=#000 \
  -colorizer name=ContColor random colors="#EFDECD,#CD9575,#FDD9B5,#78DBE2,#87A96B,#FFA474,#FAE7B5,#9F8170,#FD7C6E,#ACE5EE,#1F75FE,#A2A2D0,#6699CC,#0D98BA,#7366BD,#DE5D83,#CB4154,#B4674D,#FF7F49,#EA7E5D,#B0B7C6,#FFFF99,#1CD3A2,#FFAACC,#DD4492,#1DACD6,#BC5D58,#DD9475,#9ACEEB,#FFBCD9,#FDDB6D,#2B6CC4,#EFCDB8,#6E5160,#CCFF00,#71BC78,#6DAE81,#C364C5,#CC6666,#E7C697,#FCD975,#A8E4A0,#95918C,#1CAC78,#1164B4,#ADFF2F,#FF1DCE,#B2EC5D,#5D76CB,#CA3767,#3BB08F,#FFFF66,#FCB4D5,#FFF44F,#FFBD88,#F664AF,#AAF0D1,#CD4A4C,#EDD19C,#979AAA,#FF8243,#C8385A,#EF98AA,#FDBCB4,#1A4876,#30BA8F,#C54B8C,#1974D2,#FFA343,#BAB86C,#FF7538,#FF2B2B,#F8D568,#E6A8D7,#414A4C,#FF6E4A,#1CA9C9,#FFCFAB,#C5D0E6,#FDDDE6,#158078,#FC74FD,#F78FA7,#8E4585,#7442C8,#9D81BA,#FE4EDA,#FF496C,#D68A59,#714B23,#FF48D0,#E3256B,#EE204D,#FF5349,#C0448F,#1FCECB,#7851A9,#FF9BAA,#FC2847,#66FF66,#9FE2BF,#A5694F,#8A795D,#45CEA2,#FB7EFD,#CDC5C2,#80DAEB,#ECEABE,#FFCF48,#FD5E53,#FAA76C,#18A7B5,#EBC7DF,#FC89AC,#DBD7D2,#17806D,#DEAA88,#77DDE7,#FFFF83,#926EAE,#324AB2,#F75394,#FFA089,#8F509D,#A2ADD0,#FF43A4,#FC6C85,#CDA4DE,#FFFF00,#C5E384,#FFAE42" \
  -style target=13d_e fill='ContColor(id)' stroke="#333333" \
  -o target="13d_e,counties-lines,TN" '/Users/cervas/Library/CloudStorage/GoogleDrive-jcervas@uci.edu/My Drive/Projects/Redistricting/2022/TN/Maps/House/Plans/TN_House_13d_e.svg' format=svg combine-layers \
  -filter target=13d_e '[1,2,3].indexOf(id) > -1' + name=sameenacted \
  -o target="counties-lines,sameenacted,TN" '/Users/cervas/Library/CloudStorage/GoogleDrive-jcervas@uci.edu/My Drive/Projects/Redistricting/2022/TN/Maps/House/TN_House_13_d_e.svg' format=svg combine-layers height=200

tn_blocks <- read.csv("/Users/cervas/Library/CloudStorage/GoogleDrive-jcervas@uci.edu/My Drive/GitHub/Data Files/Census/TN2020.pl/clean data/TN_blocks.csv")
tn <- blocks[,c(3,6)]

new_plan <- read.csv("/Users/cervas/Library/CloudStorage/GoogleDrive-jcervas@uci.edu/My Drive/Projects/Redistricting/2022/TN/House Plans/13c/TN House 13c.csv", colClasses=c("character"))
compare_plan <- read.csv("/Users/cervas/Library/CloudStorage/GoogleDrive-jcervas@uci.edu/My Drive/Projects/Redistricting/2022/TN/House Plans/TN 2020 State House/TN 2020 State House.csv", colClasses=c("character"))

core_retention <- function(new_plan=NA, compare_plan=NA, blocks=NA) {

compare_plan_tmp <- compare_plan[match(tn[,1],compare_plan[,1]),2]
new_plan_tmp <- new_plan[match(tn[,1],new_plan[,1]),2]
tmp <- (cbind(tn, compare_plan_tmp, new_plan_tmp))
n_dist <- length(unique(tmp$new_plan_tmp))
output <- data.frame(District=NA,Core=NA)

for (i in 1:n_dist) {
a <- tmp[tmp$new_plan_tmp == i,]

d_total <- aggregate(a$TOTAL, by=list(a$new_plan_tmp), FUN=sum)[,2]


dis_tmp <- aggregate(a$TOTAL, by=list(a$compare_plan_tmp,a$new_plan_tmp), FUN=sum)
dis_tmp <- dis_tmp[order(dis_tmp$x, decreasing=T),]
same_total <- dis_tmp[1,3]

output[i,] <- cbind(i, same_total/d_total)
}

return(output)
}

mean(core_retention[,2])