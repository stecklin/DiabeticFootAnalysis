library(ggplot2)
library(dplyr)
library(tidyr)

# load data
data <- readRDS("data.rds") %>% tidyr::unnest() %>% select(c(ID, Label, Time, MTK1.T, MTK2.T, MTK3.T, MTK4.T, MTK5.T, D1.T, L.T, C.T))
# get basic information about data
summary(data)
# define range limits
lower <- 0
upper <- 50
# filter by limits
data2 <- data %>% filter(MTK1.T > lower & MTK1.T < upper &
                MTK2.T > lower & MTK2.T < upper &
                MTK3.T > lower & MTK3.T < upper &
                MTK4.T > lower & MTK4.T < upper &
                MTK5.T > lower & MTK5.T < upper &
                D1.T   > lower & D1.T   < upper &
                L.T    > lower & L.T    < upper &
                C.T    > lower & C.T    < upper)
# get information of filtered data
summary(data2)
# group data by ID and assign group-specific row number (used for plotting)
grouped <- data2 %>% group_by(ID) %>% mutate(rn = row_number())
ggplot(grouped, aes(rn, MTK1.T, colour=ID)) + geom_line()
