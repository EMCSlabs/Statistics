############# Prep for statistical analysis ################

#Step1: Go to 'Files' on the right-hand side of the window
#Step2: Click the folder where the csv file is located
#Step3: 'More'->'Set as a working directory'
##Alternative to Step 1-3 is to use the function 'setwd'
setwd("~/Downloads")

#Step4: Read the csv file
all=read.csv('vowel_f0.csv')

# if its extension is .xlsx
# install.packages("gdata")
# library(gdata)
# vowels = read.xls (("formants.xlsx"), sheet = 1, header = TRUE)

#Step5: Check if the variable type is assigned correctly

##Show the list of variables and their types (e.g. Factor, int, num, etc.)
str(all) 
##Correct variable types (e.g. as.factor, as.int, as.num, etc.)
all$Tone = as.factor(all$Tone) # 'int' -> 'Factor'
##Create new variables 'dur', 'contour51' and 'contour31'
all$dur = all$Word_end - all$Word_start
all$contour53 = all$f0_timepoint5 - all$f0_timepoint3
all$contour31 = all$f0_timepoint3 - all$f0_timepoint1

#Step6: Load required packages
library('lme4')
library('lmerTest')
library('lsmeans')
library('ggplot2')
library('tidyr')

# Step7: From wide to long format: gather(data,new_key_col,new_val_col,rangetomergefrom)

all = gather(all, f0_timepoint, f0, f0_timepoint1:f0_timepoint5)

# Step8: Boxplotting to see how many ouliers exist
T1 = boxplot(f0~f0_timepoint,all[all$Tone == 1,])
T2 = boxplot(f0~f0_timepoint,all[all$Tone == 2,])
T3 = boxplot(f0~f0_timepoint,all[all$Tone == 3,])
T4 = boxplot(f0~f0_timepoint,all[all$Tone == 4,])

# Step9: Remove outliers 
# Create a new function 'remove_outliers'
# outliers -> NA
# You can vary the value multiplied by IQR 

remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 0 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

#Create a new column 'f0new' where outliers are removed
all$f0new = remove_outliers(all$f0)

#Step 10 (optional) : Remove row data where outliers are removed

all_withoutNA = na.omit(all)

# let's see how much they are removed
T1 = boxplot(f0new ~ f0_timepoint,all_withoutNA[all_withoutNA$Tone == 1,])
T2 = boxplot(f0new ~ f0_timepoint,all_withoutNA[all_withoutNA$Tone == 2,])
T3 = boxplot(f0new ~ f0_timepoint,all_withoutNA[all_withoutNA$Tone == 3,])
T4 = boxplot(f0new ~ f0_timepoint,all_withoutNA[all_withoutNA$Tone == 4,])

############# Prep for statistical analysis has finished! ################


################### Statistical anlaysis starts! ########################

## CORRELATION

# correlation coefficient
# correlation only works with cor matrix without NA, 
# so get prepared with the matrix in advance
cor(all_withoutNA$dur, all_withoutNA$f0)


## T-TEST (I.V. should have exactly 2 levels)

# built-in data
sleep

# Independent-samples t-test (Welch)
t.test(extra ~ group, sleep)
# Independent-samples t-test (assume equal var)
t.test(extra ~ group, sleep, var.equal = TRUE)

# Paired-samples t-test
# Sort by group then ID, and test!
sleep <- sleep[order(sleep$group, sleep$ID), ]
t.test(extra ~ group, sleep, paired=TRUE) # x: binary factor

t.test(all_withoutNA$dur, all_withoutNA$f0) # x: numeric



## LINEAR REGRESSION & ANOVA (between subjects ANOVA)

# Fitting Linear Models (drawing regression line) (one way anova)

# 1) When the predictor is continuous(numeric)
# Predictor = 'contour53', Outcome = 'dur', from the data 'all'
# Function 'lm' computes the coefficients for the predictors
# These calls have the same results
fit1=lm(dur ~ contour53, all) 
fit1=lm(all$dur ~ all$contour53)
fit1
# Get more detailed information (coefficient, t-value, p-value)
summary(fit1) 
# The line fit is dur = 0.3168279 + 0.0005587 * contour53 

# One-way ANOVA (df, F-value, p-value)
anova(fit1)
# What is the difference between 'aov' and 'anova'?
# fit1.aov = aov(fit1)
# summary(fit1.aov) = anova(fit1)


# 2) Where the predictor is discrete (Factor)  
# Predictor = 'Tone', Outcome = 'dur', from the data 'all'
fit2=lm(dur ~ Tone, all) 
fit2=lm(all$dur ~ all$Tone)
fit2
summary(fit2)
# In this case, you interpret the coefficients as follows: 
# Avg dur of Tone1 is the coeff of Intercept (0.30420)
# Avg dur of Tone2 is the coeff of Intercept (0.30420) + the coeff of Tone2 (0.04298)
# Avg dur of Tone3 is the coeff of Intercept (0.30420) + the coeff of Tone3 (0.10187)
# Avg dur of Tone4 is the coeff of Intercept (0.30420) - the coeff of Tone4 (0.01791)
# That is, 3 regression lines in total are drawn
anova(fit2)


# Fitting multiple regression (two or more-way anova) 

# Multiple independent factors without interaction: '+'
fit3= lm(dur~Tone + Condition, all) 
anova(fit3) 

# Multiple independent factors with interaction: '*'
# Tone*Condition = Tone + Condition + Tone:Condition
fit4= lm(dur~Tone*Condition, all)
anova(fit4)

# Only interaction between factors: ':'
fit5 = lm(dur~Tone:Condition, all)
anova(fit5)


# Fitting Linear Mixed-Effects Models (within subjects ANOVA)

# random effects(variation among and by groups) are reflected in this model: lmer(y~x+(1|subject))
# 'subject' as random factor (random intercept jittering)
# y = ax + b + c, c: random effects (e.g. subject, words..)
# 'c' is a n-long vector (n: the number of subset of random effects)
# as a result, n models (each for each subject) are fitted with the same slope(a)
# => y = ax + b + c1, y = ax + b + c2, ..., y = ax + b + cn
# here, c1 is 'the total avg(b) - the avg of subject1'
# therefore, the vector 'c' (c1,c2,..cn) is normally distributed (mean = 0, sd = 1)
# Among n models, the best fitting one is chosen
fit6=lmer(dur~Tone+(1|Subject), all) 
fit2
fit6 #compare lm with lmm
anova(fit6)

# multiple random effects with multiple group factors(subject, order)
fit7=lmer(dur~Tone+(1|Subject)+(1|Order), all) 
#######Question: how many models are fitted for fit4?

# Mixed effect models with random intercept and random slope: lmer(y~x+(1+x|subject))
fit8 = lmer(dur~Tone + Condition + (1+Condition|Subject), all)
anova(fit8) 
# y = ax+b+c*1+d*x<-c:random intercept, d:random slope

# Mixed effect models with random slope only (not random intercept)
fit9 = lmer(dur~Tone + Condition + (0+Condition|Subject), all)
anova(fit9) 

# Mixed effect models with nested group effect
fit10 = lmer(dur~Tone + Condition + (1|Subject/Order), all)
anova(fit10)

# Mixed effect model with a random slope (nested group effect)
fit11 = lmer(dur~Tone + (1+Tone|Subject/Order), all)
anova(fit11)

##################### POST-HOC! #########################

lsmeans(fit8, pairwise~Tone, adjust="tukey") # any diff between tones?
lsmeans(fit8, pairwise~Condition, adjust="tukey") # any diff between conditions?
lsmeans(fit8, pairwise~Tone|Condition, adjust="tukey") #Given Condition, any diff between tones?
lsmeans(fit8, pairwise~Condition|Tone, adjust="tukey") #Given Tone, any difference between conditions?
# filter out the ones that have high p.value


# example 
fit11=lm(dur~Tone*Condition*Vowel, all)
anova(fit11)
lsmeans(fit11, pairwise~Condition*Vowel|Tone, adjust = "tukey")

################### Statistical anlaysis has finished! ########################


