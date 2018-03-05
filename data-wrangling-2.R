library(dplyr)
library(tidyr)

# 0: Load the data in RStudio
titanic_original = read.csv("titanic3.csv", header = TRUE)
#View(titanic_original)

# 1: Port of embarkation
titanic_original$embarked <- gsub("^$", "S", titanic_original$embarked)

# 2: Age
titanic_original$age[is.na(titanic_original$age)] <- round(mean(titanic_original$age, na.rm = TRUE))

# 3: Lifeboat
titanic_original$boat <- gsub("^$", "NONE", titanic_original$boat)

# 4: Cabin
titanic_original <- titanic_original %>% mutate(has_cabin_number = ifelse(cabin == '', FALSE, TRUE))

# 5: Submit the project on Github
write.csv(dat, file = "titanic_clean.csv")

# OUTPUT
View(titanic_original)