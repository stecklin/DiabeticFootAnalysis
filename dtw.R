library(dplyr)
library(dtw)

# Load data
data <- readRDS("data.rds") %>% 
        tidyr::unnest() %>% 
        select(c(ID, Label, Time, MTK1.T, MTK2.T, MTK3.T, MTK4.T, MTK5.T, D1.T, L.T, C.T))

# remove probands with invalid measures
allowed_range = 25
data <- data %>% 
  group_by(ID) %>% 
  filter((max(MTK1.T) - min(MTK1.T) <= allowed_range) &
         (max(MTK2.T) - min(MTK2.T) <= allowed_range) &
         (max(MTK3.T) - min(MTK3.T) <= allowed_range) &
         (max(MTK4.T) - min(MTK4.T) <= allowed_range) &
         (max(MTK5.T) - min(MTK5.T) <= allowed_range) &
         (max(D1.T)   - min(D1.T)   <= allowed_range) &
         (max(L.T)    - min(L.T)    <= allowed_range) &
         (max(C.T)    - min(C.T)    <= allowed_range)
  )

# drop label
clus_data <- subset(data, select=-Label)

# transform POSIX time to ints
clus_data <- transform(clus_data, Time=as.numeric(Time))

# normalize temperatures to start from 0
for (id in unique(clus_data$ID)) {
  for (varIdx in 2:10) {
    clus_data[clus_data$ID == id,varIdx] <- 
      clus_data[clus_data$ID == id,varIdx] - 
      clus_data[which(clus_data$ID == id)[1],varIdx]
  }
}

# Get column names of timeseries variants
vNames <- c("MTK1.T", "MTK2.T", "MTK3.T", "MTK4.T", "MTK5.T", "D1.T", "L.T", "C.T")
## Transform data frame to matrix tsMat with 
## tsMat[timestep, variant, patientID] and pad end with zeros

# Get number of patient IDs
numID <- length(unique(data$ID))
# Get column names of timeseries variants
vNames <- colnames(data)[4:10]
# Initialize timeseries matrix
tsMat <- array(0, dim = c(700, 10, length(groupedList)))

# For each timeseries variant
for (var in 1:length(vNames)) {
# Get all time points grouped by patient ID
groupedList <- aggregate(data[, vNames[var]], list(data$ID), identity)
groupedList <- groupedList[, vNames[var]]
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
