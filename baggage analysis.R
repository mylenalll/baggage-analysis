# loading packages
library(ggplot2)

# information about the baggage already inspected
test_data1 <- read.csv("https://stepic.org/media/attachments/course/524/test_luggage_1.csv")
test_data2 <- read.csv("https://stepic.org/media/attachments/course/524/test_luggage_2.csv")

# $ is_prohibited: chr  "No" "No" "No" "No" ...
# $ weight       : int  69 79 82 81 84 81 64 76 77 88 ...
# $ length       : int  53 52 54 50 48 51 53 52 53 52 ...
# $ width        : int  17 21 20 23 19 20 16 20 23 23 ...
# $ type         : chr  "Suitcase" "Bag" "Suitcase" "Bag" ...


# ==============================================================================
# Plotting
# ==============================================================================


# prohibitions and width in each data set
ggplot(test_data1, aes(is_prohibited, width)) + 
  geom_boxplot() +
  geom_dotplot(binaxis='y', binwidth = 0.15) +
  ggtitle("Prohibitions and width. Test Data 1") 

ggplot(test_data2, aes(is_prohibited, width)) + 
  geom_boxplot() +
  geom_dotplot(binaxis='y', binwidth = 0.45) +
  ggtitle("Prohibitions and width Test Data 2")

# prohibitions and length in each data set
ggplot(test_data1, aes(is_prohibited, length)) + 
  geom_boxplot() +
  geom_dotplot(binaxis='y', binwidth = 0.2) +
  ggtitle("Prohibitions and length. Test Data 1") 

ggplot(test_data2, aes(is_prohibited, length)) + 
  geom_boxplot() +
  geom_dotplot(binaxis='y', binwidth = 0.1) +
  ggtitle("Prohibitions and length. Test Data 2") 

# prohibitions and weight in each data set
ggplot(test_data1, aes(is_prohibited, weight)) + 
  geom_boxplot() +
  geom_dotplot(binaxis='y', binwidth = 0.5) +
  ggtitle("Prohibitions and weight. Test Data 1") 

ggplot(test_data2, aes(is_prohibited, weight)) + 
  geom_boxplot() +
  geom_dotplot(binaxis='y', binwidth = 0.6) +
  ggtitle("Prohibitions and weight. Test Data 2") 

# prohibitions and bag type in each data set
mosaicplot(table(test_data1$is_prohibited, test_data1$type), main='Prohibitions by type. Test Data 1', col='steelblue') 
mosaicplot(table(test_data2$is_prohibited, test_data2$type), main='Prohibitions by type. Test Data 2', col='steelblue') 


# ==============================================================================
# Search for significant predictors affecting baggage prohibition
# ==============================================================================


# this function takes a dataset and returns a list of significant predictors in the data
get_features <- function(dataset){
  # make variables factor
  dataset <- transform(dataset, is_prohibited = factor(is_prohibited), type = factor(type))
  
  # create a logit regression model
  fit <- glm(is_prohibited ~ ., dataset, family = "binomial")
  
  # compare models with different predictors
  result <- anova(fit, test = "Chisq")
  
  # predictor is considered valuable if p-value < 0.05
  names <- rownames(subset(result,`Pr(>Chi)`<0.05))
  
  if (length(names) != 0) {
    return(names)
  } else {
    return("Prediction makes no sense")
  }
}

get_features(test_data1) # "Prediction makes no sense"
get_features(test_data2)  # "length" "width"  "type"  


# information about the baggage already inspected
test_data <- read.csv("https://stepic.org/media/attachments/course/524/test_data_passangers.csv")

# information about new baggage that is being scanned
data_for_predict <- read.csv("https://stepic.org/media/attachments/course/524/predict_passangers.csv")


# ==============================================================================
# Predicting baggage prohibition
# ==============================================================================


# this function returns name(s) of the owner(s) of the most suspicious baggage so they can be called for an additional check. 
# baggage is considered suspicious if the predicted probability if greater than 0.7
most_suspicious <- function(test_data, data_for_predict){
  # make variables factor
  test_data <- transform(test_data, is_prohibited = factor(is_prohibited))
  
  # create logit regression model
  fit <- glm(is_prohibited ~ ., test_data, family = "binomial")
  
  # predict the probability that baggage is prohibited.
  data_for_predict$predicted <<- predict(fit, data_for_predict, type="response")
  
  # select suspicious pieces of baggage
  indexes <- which(data_for_predict$predicted > 0.7)
  
  # return people's names
  return(data_for_predict[indexes, ]$passangers)
}

most_suspicious(test_data, data_for_predict) # "Ivan" "Polina" "Svetozar"

