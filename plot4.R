#  Exploratory Data Analysis
#  Programming Assignment # 1
#  plot4.R

#################################

# Load packages
install.packages("downloader")
install.packages("data.table")

require(downloader)
require(data.table)
require(reshape2)

# Check for and create directory
if(!file.exists("data")){
  dir.create("data")
}

# Download data
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download(fileURL, temp, mode = "wb")
unzip(temp, exdir ="./data")
fileMetaData <- unzip(temp, list = TRUE)
fileName <- paste("./data/", fileMetaData$Name, sep = "")
unlink(temp)
dateDownloaded <- date()

# Read in and subset data
rawData <- read.table(fileName, header = TRUE, sep = ";", na.strings="?")
tidyData <- subset(rawData, Date == "1/2/2007" | Date == "2/2/2007")

# Create Date-Time column
date <- as.Date(tidyData$Date, "%d/%m/%Y")
time <- as.character(tidyData$Time)
rawDateTime <- paste(date, time)
tidyData$Date_Time <- strptime(rawDateTime, "%Y-%m-%d %H:%M:%S")

# Create png file
png(filename = "plot4.png")
par(mfrow = c(2,2))
with(tidyData, {
  plot(tidyData$Date_Time, tidyData$Global_active_power, 
       ylab = "Global Active Power", xlab = "", type = "l")
  plot(tidyData$Date_Time, tidyData$Voltage, 
       ylab = "Voltage", xlab = "datetime", type = "l")
  plot(tidyData$Date_Time, tidyData$Sub_metering_1, 
                ylab = "Energy sub metering", xlab = "", type = "l", col = "black")
  lines(tidyData$Date_Time, tidyData$Sub_metering_2, col = "red")
  lines(tidyData$Date_Time, tidyData$Sub_metering_3, col = "blue")
  legend("topright", lty = 1, col = c("black", "red", "blue"), 
                  legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(tidyData$Date_Time, tidyData$Global_reactive_power, 
       ylab = "Global_reactive_power", xlab = "datetime", type = "l")
})
dev.off()