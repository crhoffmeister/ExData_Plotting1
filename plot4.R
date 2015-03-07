# This script reads data from the UCI Machine Learning Laboratory
# Electric Power Consumption dataset and creates a 2x2 matrix of
# plots detailng, Feb 1-2, 2007:
#
# 1. a line plot of global active power, by Thursday through Saturday
# 2. a line plot of voltage, by Thursday through Saturday
# 3. an overlay line plot of energy sub-metering, by Thursday through Saturday
# 4. a line plot of global active power, by Thursday through Saturday,
# limited by 0.5 kilowatts

# The script then sends these plots to a PNG file named plot4.png'.

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

png(filename = "plot4.png",
    width=480,
    height=480,
    units="px")

# Generate four plots in a 2x2 matrix.

par(mfrow=c(2,2), mar=c(4,4,2,1))

with(data, {
      plot(datetime, 
           Global_active_power, 
           type="l", 
           main = NULL, 
           xlab = "", 
           ylab = "Global Active Power")
      
      plot(datetime, 
           Voltage, 
           type="l", 
           main = NULL, 
           xlab = "datetime", 
           ylab = "Voltage")
      
      plot(datetime,
           Sub_metering_1,
           type="n",
           main=NULL,
           xlab="",
           ylab="Energy sub metering")
      
      lines(datetime, Sub_metering_1, col="black")
      lines(datetime, Sub_metering_2, col="red")
      lines(datetime, Sub_metering_3, col="blue")
      
      legend("topright", 
             bty="n",
             lty=1,
             col=c("black","red","blue"),
             legend=c("Sub_metering_1",
                      "Sub_metering_2",
                      "Sub_metering_3"))
      
      plot(datetime, 
           Global_reactive_power, 
           type="l", 
           main = NULL, 
           xlab = "datetime", 
           ylab = "Global_reactive_power")
})    

# Close PNG device.

dev.off()
