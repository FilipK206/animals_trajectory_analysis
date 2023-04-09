library(tidyverse)
library(magrittr)
library(dplyr)
library(readr)

#imports multiple csv files and combines them
all_coords <- list.files(path = "~/animals_trajectory_analysis/R_scripts/videos_data/") %>%
  lapply(read_csv) %>%
  bind_rows(.id = "id")

#deletes two first rows
all_coords <- all_coords[-(1:2),]

#renames columns
all_coords %<>%
  rename(front_left_leg__x = DLC_resnet50_HabituationAug22shuffle1_15000...2, front_left_leg__y = DLC_resnet50_HabituationAug22shuffle1_15000...3,
         front_left_leg__likelihood = DLC_resnet50_HabituationAug22shuffle1_15000...4, front_right_leg__x = DLC_resnet50_HabituationAug22shuffle1_15000...5,
         front_right_leg__y = DLC_resnet50_HabituationAug22shuffle1_15000...6, front_right_leg__likelihood = DLC_resnet50_HabituationAug22shuffle1_15000...7,
         rear_left_leg__x = DLC_resnet50_HabituationAug22shuffle1_15000...8, rear_left_leg__y = DLC_resnet50_HabituationAug22shuffle1_15000...9,
         rear_left_leg__likelihood = DLC_resnet50_HabituationAug22shuffle1_15000...10, rear_right_leg__x = DLC_resnet50_HabituationAug22shuffle1_15000...11,
         rear_right_leg__y = DLC_resnet50_HabituationAug22shuffle1_15000...12, rear_right_leg__likelihood = DLC_resnet50_HabituationAug22shuffle1_15000...13,
         cerci__x = DLC_resnet50_HabituationAug22shuffle1_15000...14, cerci__y = DLC_resnet50_HabituationAug22shuffle1_15000...15, 
         cerci__likelihood = DLC_resnet50_HabituationAug22shuffle1_15000...16, head__x = DLC_resnet50_HabituationAug22shuffle1_15000...17,
         head__y = DLC_resnet50_HabituationAug22shuffle1_15000...18, head__likelihood = DLC_resnet50_HabituationAug22shuffle1_15000...19,
         left_led__x = DLC_resnet50_HabituationAug22shuffle1_15000...20, left_led__y = DLC_resnet50_HabituationAug22shuffle1_15000...21,
         left_led__likelihood = DLC_resnet50_HabituationAug22shuffle1_15000...22, right_led__x = DLC_resnet50_HabituationAug22shuffle1_15000...23,
         right_led__y = DLC_resnet50_HabituationAug22shuffle1_15000...24, right_led__likelihood = DLC_resnet50_HabituationAug22shuffle1_15000...25)

#data wrangling
all_coords %<>%
  pivot_longer(!id:scorer, names_to = "bodyparts", values_to = "coords") %>%
  separate(bodyparts, c("parts", "coord"), sep = "__") %>%
  pivot_wider(names_from = coord, values_from = coords) %>%
  rename(bodyparts = parts)

#deletes unnecessary rows and changes data types
all_coords %<>%
  filter(scorer != 'bodyparts' & scorer != 'coords') %>%
  mutate(id = as.factor(id), scorer = as.integer(scorer), x = as.double(x), y = as.double(y), likelihood = as.double(likelihood))

summary(all_coords)

#deletes outliers
all_coords %<>%
  filter(x != 0 & y !=0)

#saves csv file
write_csv(all_coords, '~/animals_trajectory_analysis/R_scripts/coords.csv')

