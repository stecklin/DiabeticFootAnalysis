addPredictions <- function(data, clustering) {
  predictions <- data.frame(ID = unique(data$ID), Prediction = clustering) 
  data <- left_join(data, predictions)
  return(data)
}

getMean <- function(data, var) {
  meanCurves <- aggregate(var ~ Prediction + Time, data, mean)
  return(meanCurves)
}

getStatistics <- function(data) {
  statistics <- aggregate(. ~ Label + Prediction, unique(data[, c("ID", "Label", "Prediction")]), length)
  return(statistics)
}