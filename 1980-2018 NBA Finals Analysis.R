# All NBA Finals Games (Wins and Losses) from the championship team from 1980 - 2018

# Loading Packages
library(ggplot2)
library(dplyr)

# Reading CSV
champ <- read.csv('~/Desktop/championsdata.csv')

summary(champ) # Includes mean, median, etc. for each column

# 1.Logistic Regression to evaluate the correlation between free throw attempts (independent) and Wins (dependent)
summary(glm(Win~FTA, data=champ, family='binomial')) # FTA p-value: .000227 (statistically significant)

# Logistic Regression Visualization
ggplot(champ, aes(x=FTA, y=Win)) + 
  xlab("Free Throw Attemps") + 
  ylab('Wins') +
  stat_smooth(method='glm', color='red', se=FALSE, method.args = list(family = binomial))
# Positive correlation between FTA (discrete independent) and Wins (binary dependent) backs up our logistic regression summary
# Free throw attempts generate easy points via the free throw line, but it also shows a sign of a team's ability to get into the paint. That allows the defense to collapse and create easier shots for the team


# 2.Does the home team have a higher chance of winning?
summary(glm(Win~Home, data=champ, family='binomial'))

# Home p-value: 0.00098 (statistically significant)
ggplot(champ, aes(x=Home, y=Win)) +
  stat_smooth(method='glm', color='red', se=FALSE, method.args = list(family=binomial))
# Positive correlation between playing at home and winning 

# 3. Multi-Logistic Regression with Assists, Rebounds, and Turnovers
summary(glm(Win~AST+TRB+TOV, data=champ, family='binomial'))
# Assists p-value: 0.00561 
# Total Rebounds: 3.92e-05
# Turnovers: 8.48e-06 
# All are significant, rebounds, and turnovers extremely significant

# Let's visualize the negative correlation between turnovers and wins
ggplot(champ, aes(x=TOV, y=Win)) + 
  stat_smooth(method='glm', color='red', se=FALSE, method.args = list(family=binomial))
# More turnovers = Less opportunities to score and easier opportunities for opponent to score

# 4. Scoring Volume By Year
model <- lm(PTS~Year, data=champ)
newdata <- data.frame(Year = c(1980, 1985, 1990, 1995, 2000, 2005, 2010, 2015, 2018))
predict(model,newdata = newdata, interval='confidence')
# Predicts the scores to range from 97 to 102 with earlier years having higher scores

summary(model) 
# Statistically significant, but low r-squared (approx. .04) shows that the year does not have a large impact on the amount of points scored

# Visualization that shows how the year affects the amount of points scored in a finals game
ggplot(champ, aes(x = Year, y=PTS, color=Win)) + geom_point() +
  geom_smooth(method='lm', se=FALSE, color = 'red')

# Line of best fit shows slight decrease in scoring volume

# 5. Comparing Three Point Rates between years 1980-1984 and 2014-2018

# Creating Subsets
early <- subset(champ, Year <= 1984)
modern <- subset(champ, Year >= 2014)

# Adding column that contains the three point rate (Percentage of field goals that are threes)
early <- early %>% mutate('TPR' = TPA / FGA)
modern <- modern %>% mutate('TPR' = TPA / FGA)

summary(early$TPR)
# Max is only 6%, which means that the highest percentage of three point shots taken compared to the total field goals was just 6%

# Bar Graph of Three Point Rates from 1980-1984
ggplot(early, aes(x=TPR)) + geom_bar(color='blue')

summary(modern$TPR)
# Min is 25% and max is 48%, much higher than the 1980-1984 sample

# Bar Graph of Three Point Rates from 2014-2018
ggplot(modern, aes(x=TPR)) + geom_bar(color='red')

# Immense difference in three point rates between both subsets
# 1980s basketball featured very low amounts of three pointers and more mid range shots/paint shots
# 2014-2018 finals included the Spurs and the Warriors; two teams that were well known for attempting a lot of threes

# 6. Despite this, one of our previous graphs showed scoring volume dipping from the 1980s, why?
summary(early$FTA)
summary(modern$FTA)
#Max FTA from 1980-1984 subset is a lot higher (51) compared to modern's 31

# Combining early and modern subsets
early_and_modern <- subset(champ, Year <= 1984 | Year >= 2014)

# Visualization of FTA disparity
ggplot(early_and_modern, aes(x=Year, y=FTA)) + geom_point() +
  geom_smooth(method = 'lm', se=FALSE, method.args = list(family=binomial))
# Shows reduction in FTA, not overwhelming

# We can also look at turnovers
ggplot(early_and_modern, aes(x=Year, y=TOV)) + geom_point() +
  geom_smooth(method = 'lm', se=FALSE, method.args = list(family=binomial))

# A lot steeper slope
# This could be due to the increased pace that the modern basketball game has, more mistakes are prone to happening in comparison to the 80s because of its sped up nature
# This strips away possessions that could have resulted in points and turns them into opportunities for opponents


# Conclusion
# This dataset definitely does not tell the whole story about the evolution of basketball, but it gives a good idea
# The game has become a lot faster over the years and more perimeter-centric
# This does not change the basic stats that can predict wins like assists, turnovers, free throw attempts, and rebounds


