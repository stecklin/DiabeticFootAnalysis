loadRawData <- function(path) {
    # Load data
    data <- readRDS(path) %>% 
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
    return(data)
}

loadDistData <- function(path) {
    data <- readRDS(path)
    return(data)
}
