#install.packages("caret")
#library(caret)
                 
#install.packages("palmerpenguins")
#library(palmerpenguins)

trainrows <- sample(1:nrow(penguins_omit), replace = F, size = nrow(penguins_omit)*0.66)

X = penguins_omit[trainrows, 1:4]
Y = penguins_omit[trainrows, 5]
head(X)
nrow(X)
table(Y)
nrow(Y)
 
#sigmoid function
sigmoid<-function(x){
  1/(1+exp(-x))
}

# derivative of sigmoid function
derivatives_sigmoid<-function(x){
  x*(1-x)
}

# variable initialization
epoch=5000
lr=0.1
inputlayer_neurons=ncol(X)
hiddenlayer_neurons=15
output_neurons=1



#weight and bias initialization
wh=matrix(rnorm(inputlayer_neurons*hiddenlayer_neurons,mean=0,sd=1), inputlayer_neurons, hiddenlayer_neurons)
bias_in=runif(hiddenlayer_neurons)
bias_in_temp=rep(bias_in, nrow(X))
bh=matrix(bias_in_temp, nrow = nrow(X), byrow = FALSE)
wout=matrix(rnorm(hiddenlayer_neurons*output_neurons,mean=0,sd=1), hiddenlayer_neurons, output_neurons)

bias_out=runif(output_neurons)
bias_out_temp=rep(bias_out,nrow(X))
bout=matrix(bias_out_temp,nrow = nrow(X),byrow = FALSE)

X<- as.matrix(X)
X

Y<-as.matrix(Y)
Y

# forward propagation
for(i in 1:epoch){
  
  hidden_layer_input1=X%*%wh
  hidden_layer_input=hidden_layer_input1+bh
  hidden_layer_activations=sigmoid(hidden_layer_input)
  output_layer_input1=hidden_layer_activations%*%wout
  output_layer_input=output_layer_input1+bout
  output= sigmoid(output_layer_input)
  
  
  # Back Propagation
  E=Y-output
  slope_output_layer=derivatives_sigmoid(output)
  slope_hidden_layer=derivatives_sigmoid(hidden_layer_activations)
  d_output=E*slope_output_layer
  
  Error_at_hidden_layer=d_output%*%t(wout)
  
  d_hiddenlayer=Error_at_hidden_layer*slope_hidden_layer
  wout= wout + (t(hidden_layer_activations)%*%d_output)*lr
  bout= bout+rowSums(d_output)*lr
  wh = wh +(t(X)%*%d_hiddenlayer)*lr
  bh = bh + rowSums(d_hiddenlayer)*lr
  
}


output

#Attempt at CV on MLP
cat("

penguins_omit[sapply(penguins_omit, is.factor)] <- data.matrix(penguins_omit[sapply(penguins_omit, is.factor)])
results <- train(
  cvX = penguins_omit[,1:4],       # The input features
  cvY = penguins_omit[,5],         # The target variable
  method = mlp_model(output),   # The gradient descent function
  trControl = trainControl(
    method = cv,        # Use cross validation
    number = 5            # Use 5 folds
  ),
  tuneGrid = expand.grid(
    input_neurons = 4,   # The number of input neurons
    hidden_neurons = 15, # The number of hidden neurons
    output_neurons = 1,  # The number of output neurons
    epoch = 5000,        # The number of epochs
    lr = 0.1            # The learning rate
  )
)

head(cvX)
head(cvY)")



