# plot4 makes four graphs, tiled in a 2x2 array!
# in the upper left, global active power is plotted vs. time
# in the upper right, voltage is plotted vs. time
# in the lower left, the three energy sub meterings are plotted vs. time
# in the lower right, the global reactive power is plotted vs. time

plot4 <- function() {
    
    # The name of the file that contains all the power consumption data.
    filename <- "household_power_consumption.txt"
    
    # The directory where the power consumption data file is located.
    filedir <- "/Users/nick/Documents/Data Science/JHU-data-sci/"
    
    # The library sqldf provides an easy way to perform SQL selects on R data frames.
    library(sqldf)
    
    # Since we only want two days worth of data, for 1/2/2007 and 2/2/2007
    # we write a SQL select to read only rows where Date is one of these two.
    
    sql_cmd <- "SELECT * FROM file WHERE Date IN ('1/2/2007','2/2/2007')"
    
    # using read.csv.sql allows us to use a SQL select for only the desired dates.
    # columns in the data file are separated by semicolons
    powerdata <- read.csv.sql(file = paste(filedir,filename,sep = ""), sql = sql_cmd, header = TRUE, sep = ";")
    
    # we need to coerce the variable Time to the Time class using strptime
    powerdata$Time <- strptime(paste(powerdata$Date, powerdata$Time, sep = "-"), format = "%d/%m/%Y-%H:%M:%S")
    
    # we need to coerce the variable Date to the Date class using as.Date
    powerdata$Date <- as.Date(powerdata$Date, format = "%d/%m/%Y")
    
    # We will use a png file as the graphics device
    png(filename = "plot4.png",
        width = 480, height = 480, units = "px", pointsize = 12,
        bg = "white",  res = NA)
    
    # We will plot four graphs total, row-wise in a 2x2 grid
    par(mfrow = c(2,2))
    
    # First plot: global active power vs. time
    plot(powerdata$Time, powerdata$Global_active_power, type = "n",
         xlab = "", ylab = "Global Active Power")
    lines(powerdata$Time, powerdata$Global_active_power)
    
    # Second plot: voltage vs. time
    plot(powerdata$Time, powerdata$Voltage, type = "n",
         xlab = "datetime", ylab = "Voltage")
    lines(powerdata$Time, powerdata$Voltage)
    
    # Third plot: energy sub metering vs. time
    plot(powerdata$Time, powerdata$Sub_metering_1, type = "n",
         xlab = "", ylab = "Energy sub metering")
    
    # Add lines for the three energy sub meterings vs. time
    lines(powerdata$Time, powerdata$Sub_metering_1, col = "black")
    lines(powerdata$Time, powerdata$Sub_metering_2, col = "red")
    lines(powerdata$Time, powerdata$Sub_metering_3, col = "blue")
    
    # Add a legend in the upper right corner
    legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
           lty = c(1,1), col = c("black", "red", "blue"), bty = "n")
    
    # Fourth plot: global reactive power vs. time
    plot(powerdata$Time, powerdata$Global_reactive_power, type = "n",
         xlab = "datetime", ylab = "Global Rective Power")
    lines(powerdata$Time, powerdata$Global_reactive_power)
    
    # Need to call dev.off() so that we can look at the png
    dev.off()

}
    