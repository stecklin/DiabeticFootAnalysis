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

    # transform POSIX time to ints
    data <- transform(data, Time=as.numeric(Time))

    # normalize temperatures to start from 0
    for (id in unique(data$ID)) {
      for (varIdx in 3:11) {
        data[data$ID == id,varIdx] <- 
          data[data$ID == id,varIdx] - 
          data[which(data$ID == id)[1],varIdx]
      }
    }
    return(data)
}

loadDistData <- function(path) {
    data <- readRDS(path)
    return(data)
}
