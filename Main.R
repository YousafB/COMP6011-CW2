#Main File to import dataset, train, test, validate and plot learning curves

install.packages("palmerpenguins")
library(palmerpenguins)
install.packages("caret")
library(caret)
#install.packages("keras")
#library(keras)
head(penguins)
#View(penguins)
#1Adiele
#2Gentoo 
#Chinstrap
any(is.na(penguins))

penguins_omit <- na.omit(penguins)
head(penguins_omit)

#removedPenguins <- penguins[,-2]
#removedPenguins

#penguins_omit <- removedPenguins[,-6:-7]
#head(penguins_omit)

penguins_omit <- na.omit(penguins_omit)

nrow(penguins_omit)


penguins_omit[sapply(penguins_omit, is.factor)] <- data.matrix(penguins_omit[sapply(penguins_omit, is.factor)])

head(penguins_omit)

any(is.na(penguins_omit))
#Install pre-requisite packages if not present
head(penguins_omit)
nrow(penguins_omit)
#install.packages("readr")
install.packages("ggplot2")


library(ggplot2)

#Randomly shuffle the dataset rows (repeatedly shuffled for 5 times)


penguins_changedRows <- penguins_omit[, c(2,3,4,5,1)]
head(penguins_changedRows)
penguins_omit <- penguins_omit[, c(3,4,5,6,1)]
head(penguins_omit)


for(k in 1:5){
  penguins_omit<-penguins_omit[sample(rows_count),]
}
nrow(penguins_omit)

source("Perceptron.r")
source("Evaluation_Cross_Validation.r")
source("Evaluation_Validation.r")
source("Evaluation_Curves.r")
source("MLP.r")
#source("MLp2.r")




#Hold out 1/5 rd validation dataset
validation_instances <- sample(nrow(penguins_omit)/3)
penguins_omit_validation<-penguins_omit[validation_instances,] #1/3 rd validation set
penguins_omit_train <- penguins_omit[-validation_instances,] #2/3 rd training set

nrow(penguins_omit_train)
nrow(penguins_omit_validation)
#Build Perceptron Model
p_model <- Perceptron(0.1)

#Set number of epochs (iterations)
num_of_epochs <- 5000 #Ideally, run with 1000 number of epochs but 1000 takes considerable amount (>10 min) to train

#plot Learning Curve - Accuracy vs Training Sample size
plot_learning_curve(p_model, penguins_omit_train, penguins_omit_validation, number_of_iterations = num_of_epochs)

#plot Learning Curve - Accuracy vs Number of Epochs (Iterations)
plot_learning_curve_epochs(p_model, penguins_omit_train, penguins_omit_validation)

#plot Learning Curve - Accuracy vs Learning Rate values
plot_learning_curve_learning_Rates(penguins_omit_train, penguins_omit_validation, num_of_epochs = num_of_epochs)

#Train - Test - Cross Validate accross 10 folds
Cross_Validate(p_model, penguins_omit_train, num_of_iterations = num_of_epochs, num_of_folds = 10)
#Cross_Validate(ml_model, dataset, num_of_iterations, num_of_folds)

#Validate results with held out validation dataset

Validate(p_model, penguins_omit_train, penguins_omit_validation, number_of_iterations = 10)


