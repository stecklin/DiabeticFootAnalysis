library(dplyr)
library(dtw)
source("dataUtils.R")

data <- loadRawData("../data.rds")

## Transform data frame to matrix tsMat with 
## tsMat[timestep, variant, patientID] and pad end with zeros

# Get number of patient IDs
numID <- length(unique(data$ID))
# Get column names of timeseries variants
vNames <- c("MTK1.T", "MTK2.T", "MTK3.T", "MTK4.T", "MTK5.T", "D1.T", "L.T", "C.T")
# Initialize timeseries matrix
tsMat <- array(0, dim = c(700, 10, numID))

# For each timeseries variant
for (var in 1:length(vNames)) {
  # Get all time points grouped by patient ID
  groupedList <- aggregate(data[, vNames[var]], list(data$ID), identity)
  groupedList <- groupedList[, "x"]
  # For each patient ID
  for (i in 1:numID)
    # Add timeseries variant to timeseries matrix
    tsMat[1:length(unlist(groupedList[i])), var, i] <- unlist(groupedList[i])
}

## Input tsMat into the dynamic time warping distance function

# Initialize distance matrix
distMat <- array(NaN, dim = c(numID, numID))

# For each patient ID
for (i in 1:numID) { 
    print(as.character(i))
    for (j in 1:numID) {
        # Calculate dtw distance to each other patient 
        distMat[i,j] <- dtw(dist(tsMat[,,i], tsMat[,,j]), 
                            distance.only=TRUE, 
                            open.end = TRUE)$normalizedDistance
    }
}

distMat <- as.dist(distMat)