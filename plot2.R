# This script reads data from the UCI Machine Learning Laboratory
# Electric Power Consumption dataset and creates a line plot of 
# global active power, by Thursday through Saturday, for the date 
# range February 1-2, 2007. The script then sends this plot 
# to a PNG file named plot2.png'.

library(graphics)
library(grDevices)
library(lubridate)
library(dplyr)

if (!file.exists("./consume.zip")) {
      src_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(src_url, destfile = "./consume.zip", method="auto")
      unzip("./consume.zip")  
}

data <- tbl_df(read.table("./household_power_consumption.txt", 
                          header=T, 
                          sep=";",
                          stringsAsFactors=F, 
                          na.strings="?"))

# Create a subset data table for plotting.

data <- data %>%
      filter(Date == "1/2/2007" | Date== "2/2/2007") %>%
      mutate(datetime = dmy_hms(paste(Date, Time))) %>%
      select(10, 3:9)

# Opens PNG device for plotting.

png(filename = "plot2.png",
    width=480,
    height=480,
    units="px")

# Generate a line plot with Y-axis label and no other titles.

plot(data$datetime, 
     data$Global_active_power, 
     type="l", 
     main = NULL, 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)")     

# Close PNG device.

dev.off()


