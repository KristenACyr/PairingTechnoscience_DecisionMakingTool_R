#required libraries
library(dplyr)
library(tidyr)

###After downloading csv file provided in github repository###
DecisionChart = read.csv("DS.csv")

##remove publications that did not report values for
#depth, length of species, tracking data, or recording hours.
DS = DecisionChart %>%
  drop_na(Depth_groups|Length_Groups|Tracking_Days|Recording_Hours)

##create a total column to be calculated in sunchart function that will##
##identify percentage of total publication under each condition/topic##
DS = DS %>%
  group_by(Taxa, Water_Type, Theme, Topic,
           Depth_groups, Length_Groups, Tracking_Days, Recording_Hours, 
           Combination) %>%
  summarise(total = n_distinct(Publication))


###Create a column that combines columns in order that will be displayed in sunchart##
DS$V1 = paste(DS$Taxa,"-", DS$Water_Type)
DS$V1 = paste(DS$V1,"-", DS$Theme)
DS$V1 = paste(DS$V1,"-", DS$Topic)
DS$V1 = paste(DS$V1,"-", DS$Depth_groups)
DS$V1 = paste(DS$V1,"-", DS$Length_Groups)
DS$V1 = paste(DS$V1,"-", DS$Tracking_Days)
DS$V1 = paste(DS$V1,"-", DS$Recording_Hours)
DS$V1 = paste(DS$V1,"-", DS$Combination)


##Ungroup so dataframe can be graphed in sunchart function##
DS = DS %>%
  ungroup() %>%
  select(V1, total)



###Graph publications into deicision making tool - sunchart
sunburst(
  DS,
  withD3 = TRUE,
  colors= htmlwidgets::JS("
function() {
  debugger
  // this will be d3 version 4
  const node = d3.select(this).datum()
  let color
  
  if(node.depth > 0) {  // 2nd level
    const ancestors = node.depth === 1 ? [node.parent, node] : node.ancestors().reverse()
    // inefficient to define every time but will do this way for now
    color = d3.scaleOrdinal(d3.schemeCategory10)
      .domain(ancestors[0].children.map(d=>d.data.name))
    return(d3.color(color(ancestors[1].data.name)).brighter((node.depth - 1)/4))
  }
}
  ")
)
