# This script reads data from the UCI Machine Learning Laboratory
# Electric Power Consumption dataset and creates an overlay
# line plot of energy sub-metering, by Thursday through Saturday, 
# for the date range February 1-2, 2007. The script then sends 
# this plot to a PNG file named plot3.png'.

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

png(filename = "plot3.png",
    width=480,
    height=480,
    units="px")

# Generate a line plot with overlayed sub-metering variables
# in black, red, and blue. Labels and legends accordingly.

with(data, {
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
             lty=1,
             col=c("black","red","blue"),
             legend=c("Sub_metering_1",
                      "Sub_metering_2",
                      "Sub_metering_3"))
})

# Close PNG device.

dev.off()

