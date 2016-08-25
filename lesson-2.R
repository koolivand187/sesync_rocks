## Tidy data concept

counts_df <- data.frame(
  day = c("Monday","Tuseday","Wednesday"),
  wolf = c(2, 1, 3),
  hare = c(02,25,30),
  fox  = c(4,4,4)
)

## Reshaping multiple columns in category/value pairs

library(tidyr)
counts_gather <- gather(counts_df, 
                        key='species',
                        value='count',
                        wolf:fox)

counts_spread <- spread(counts_gather, 
                        key=species,
                        value=count)

## Exercise 1
# remove the 8th row from the counts_gather data file
counts_gather <- counts_gather[-8,]
soll <- spread(counts_gather,
               key=species,
               value=count, fill=0)
## Read comma-separated-value (CSV) files

surveys <- read.csv("data/surveys.csv", na.string="")

## Subsetting and sorting

library(dplyr)
surveys_1990_winter <- filter(surveys,
                              year == 1990,
                              month %in% 1:3)

surveys_1990_winter <- select(surveys_1990_winter, record_id,
                              month,day, plot_id, species_id,
                              sex,hindfoot_length, weight)
#surveys_1990_winter2 <- select(surveys_1990_winter, -year)

sorted <- arrange(surveys_1990_winter, desc(species_id), weight)

## Exercise 2
#1st solution
surveys_1990_winter3 <- select(surveys, record_id,
                             sex, weight,species_id)
filter(surveys_1990_winter3,species_id == "RO")
#2ndt solution
select(filter(surveys,species_id =="RO"), record_id,sex,weight)
## Grouping and aggregation

surveys_1990_winter_gb <- group_by(surveys_1990_winter,species_id)

counts_1990_winter <- summarize(surveys_1990_winter_gb, count = n())
head(counts_1990_winter)
## Exercise 3
#find the average of DM species for each month.
surveys_dm <- filter(surveys, species_id=="DM")
surveys_dm <- group_by(surveys_dm, month)
surveys_dm_sum <- summarize(surveys_dm, avg_wt=mean(weight, na.rm=T),
                            avg_hf=mean(hindfoot_length, na.rm=T))
## Transformation of variables

prop_1990_winter <- mutate(counts_1990_winter, prop= count /sum(count))

## Exercise 4
surveys_grp <- group_by(surveys_1990_winter, species_id)
filter(surveys_grp, weight==min(weight, na.rm = T))
mutate(surveys_grp, rank=row_number(hindfoot_length))
## Chainning with pipes

prop_1990_winter_piped <- surveys %>%
  filter(year == 1990, month %in% 1:3)%>%
  select(-year)%>% # select all columns but year
  group_by(species_id) %>%# group by species_id
  summarize(count=n())%>% # summarize with counts
  mutat(prop=count/sum(count)) # mutate into proportions
