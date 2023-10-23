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
sunburstR::sunburst(unname(DS), 
                    colors= list("#012d4a", "#ebf1f5", "#cae7fa", "#afdcfa", 
                                 "#91d0fa", "#6ec2fa", "#4bb4fa", 
                                 "#28a4f7", "#0a9afa", "#0365a6" 
                    ))
