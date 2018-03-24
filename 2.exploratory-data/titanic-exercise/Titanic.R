library(dplyr)
library(tidyr)
library(titanic)
library(ggplot2)

# 0: Load the data in RStudio
titanic_original = read.csv("titanic3.csv", header = TRUE)

# Select the (4) columns from the original Titanic data set and rename the columns to match the online exercise
titanic <- titanic_original %>% select(Survived = survived, Pclass = pclass, Age = age, Sex = sex) %>%
  filter(!is.na(Survived))

# 1 - Check the structure of titanic
str(titanic)

# 2 - Use ggplot() for the first instruction
ggplot(titanic, aes(x = factor(Pclass), fill = factor(Sex))) +
  geom_bar(position = "dodge") 

# 3 - Plot 2, add facet_grid() layer
ggplot(titanic, aes(x = factor(Pclass), fill = factor(Sex))) +
  geom_bar(position = "dodge") + 
  facet_grid(". ~ Survived") 

# 4 - Define an object for position jitterdodge, to use below
posn.j <- position_jitterdodge(0.5, 0, 0.6)

# 5 - Plot 3, but use the position object from instruction 4
ggplot(titanic, aes(x = factor(Pclass), y = Age, col = factor(Sex))) +
  geom_jitter(size = 3, alpha = 0.5, position = posn.j) 
